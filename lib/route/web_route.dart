import 'package:flutter/material.dart';
import 'package:mentor_tracking/widget/app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mentoringAppBar(context, "Web View Demo"),
      body: Center(
        child: Container(
          child: WebView(
            initialUrl: 'https://www.byu.edu',
            javascriptMode: JavascriptMode.unrestricted,
          ),
        ),
      ),
    );
  }
}
