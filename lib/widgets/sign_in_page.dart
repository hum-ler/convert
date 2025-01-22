import 'package:convert_unit/controllers/controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key, required String signInUrl})
      : _signInUrl = signInUrl;

  final String _signInUrl;

  @override
  Widget build(BuildContext context) {
    final navigationDelegate = NavigationDelegate(
      onNavigationRequest: (request) {
        if (request.url.startsWith("convert://?code=")) {
          String code = request.url.substring("convert://?code=".length);

          context.read<Controller>().updateServiceLogin(context, code);
          Navigator.of(context).pop();

          return NavigationDecision.prevent;
        }

        return NavigationDecision.navigate;
      },
    );

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Row(
          children: [
            Text('Sign in'),
            SizedBox(width: 4.0),
            Icon(Icons.login),
          ],
        ),
      ),
      body: SafeArea(
        child: WebViewWidget(
          controller: WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setNavigationDelegate(navigationDelegate)
            ..loadRequest(
              Uri.parse(_signInUrl),
            ),
        ),
      ),
    );
  }
}
