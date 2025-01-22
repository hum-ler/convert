import 'dart:convert';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:document_client/document_client.dart';
import 'package:http/http.dart' as http;
import 'package:convert_unit/data/exchange_rates.dart';
import 'package:convert_unit/models/currency.dart';

/// Service for downloading the latest exchange rates.
class ExchangeRatesUpdateService {
  /// AWS region.
  static const _region = String.fromEnvironment('AWS_REGION');

  /// Amazon Cognito base URL.
  static const _baseUrl = String.fromEnvironment('AMAZON_COGNITO_BASE_URL');

  /// Amazon Cognito Client ID.
  static const _clientId = String.fromEnvironment('AMAZON_COGNITO_CLIENT_ID');

  /// Amazon Cognito User Pool ID.
  static const _userPoolId =
      String.fromEnvironment('AMAZON_COGNITO_USER_POOL_ID');

  /// Amazon Cognito Indentity Pool ID.
  static const _identityPoolId =
      String.fromEnvironment('AMAZON_COGNITO_IDENTITY_POOL_ID');

  /// User-facing sign-in URL for Amazon Cognito.
  static final _authnUrl =
      '$_baseUrl/login?client_id=$_clientId&response_type=code&scope=email%20openid&redirect_uri=convert://';

  /// Authorization URL for getting temporary credentials.
  static final _authzUrl =
      '$_baseUrl/token?client_id=$_clientId&grant_type=authorization_code&redirect_uri=convert://&code=';

  /// Table name in database (AWS DynamoDB).
  static const _tableName =
      String.fromEnvironment('AWS_DYNAMODB_EXCHANGE_RATES');

  /// Amazon Cognito user.
  CognitoUser? _user;

  /// AWS client credentials.
  AwsClientCredentials? _credentials;

  /// User-facing sign-in URL for Amazon Cognito.
  String get signInUrl => _authnUrl;

  /// Checks if user is required to login for credentials.
  Future<bool> requiresLogin() async {
    if (_user == null) {
      return true;
    }

    final session = await _user!.getSession();
    if (session != null && session.isValid()) {
      return false;
    }

    return true;
  }

  /// Logs into Amazon Cognito to get AWS client credentials.
  Future<void> login(String code) async {
    final uri = Uri.parse(_authzUrl + code);

    final response = await http.post(uri,
        body: {},
        headers: {'Content-Type': 'application/x-www-form-urlencoded'});
    if (response.statusCode != 200) {
      throw Exception(
          'Unable to obtain authorization from service. Please try again later.');
    }

    final parsedTokens = _parseTokens(response.body);
    if (parsedTokens == null) {
      throw Exception(
          'Unable to obtain authorization from service. Please try again later.');
    }

    final session = CognitoUserSession(
        parsedTokens.idToken, parsedTokens.accessToken,
        refreshToken: parsedTokens.refreshToken);
    final userPool = CognitoUserPool(_userPoolId, _clientId);
    _user = CognitoUser('', userPool, signInUserSession: session);

    final cognitoCredentials = CognitoCredentials(_identityPoolId, userPool);
    await cognitoCredentials
        .getAwsCredentials(session.getIdToken().getJwtToken());
    _credentials = AwsClientCredentials(
        accessKey: cognitoCredentials.accessKeyId!,
        secretKey: cognitoCredentials.secretAccessKey!,
        sessionToken: cognitoCredentials.sessionToken!);
  }

  /// Logs out from Amazon Cognito.
  Future<void> logout() async {
    if (_user != null) {
      await _user?.signOut();

      _user = _credentials = null;
    }
  }

  /// Downloads the latest exchange rates and updates [ExchangeRates].
  Future<void> updateCurrencies() async {
    final payload = await _downloadCurrencies();
    final parsedCurrencies = _parseCurrencies(payload);

    if (parsedCurrencies != null) {
      ExchangeRates.currencies = parsedCurrencies.currencies;
      ExchangeRates.lastUpdated = parsedCurrencies.lastUpdated;
    }
  }

  /// Downloads the latest exchange rates from database.
  Future<Map<String, dynamic>> _downloadCurrencies() async {
    final client = DocumentClient(region: _region, credentials: _credentials);

    final output = await client
        .get(tableName: _tableName, key: {'rates-id': 'latest-rates'});

    return output.item;
  }

  /// Parses authentication response from Amazon Cognito.
  ({
    CognitoIdToken idToken,
    CognitoAccessToken accessToken,
    CognitoRefreshToken refreshToken
  })? _parseTokens(String responseBody) {
    final tokenData = jsonDecode(responseBody);

    return (
      idToken: CognitoIdToken(tokenData['id_token']),
      accessToken: CognitoAccessToken(tokenData['access_token']),
      refreshToken: CognitoRefreshToken(tokenData['refresh_token'])
    );
  }

  /// Parse downloaded exchange rate data from database.
  ({List<Currency> currencies, DateTime lastUpdated})? _parseCurrencies(
      Map<String, dynamic> payload) {
    if (payload['timestamp'] == null || payload['data'] == null) {
      return null;
    }

    final lastUpdated = DateTime.parse(payload['timestamp']);

    final currencies = List<Currency>.empty(growable: true);
    for (final currency in payload['data']) {
      currencies.add(
        Currency(
          code: currency['code'],
          symbol: currency['symbol'],
          name: currency['name'],
          exchangeRate: (currency['exchange-rate'] as double).toString(),
          precision: (currency['precision'] as double).round(),
          regionEmoji: currency['region-emoji'],
        ),
      );
    }

    return (currencies: currencies, lastUpdated: lastUpdated);
  }
}
