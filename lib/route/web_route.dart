import 'dart:convert';

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
            initialUrl: Uri.dataFromString("""
              <p>This is <b>dynamic</b> HTML that I've hard-coded into
              my <code>WebView</code>.  Isn't it sweet?  Yes, <em>yes</em>,
              I do believe it <em>is</em>.
              </p>
              """, mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
                .toString(),
            javascriptMode: JavascriptMode.unrestricted,
          ),
        ),
      ),
    );
  }
}
