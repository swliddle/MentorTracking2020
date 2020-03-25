import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mentor_tracking/utilities/html_helper.dart';
import 'package:mentor_tracking/widget/app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mentoringAppBar(context, "Web View Demo", hideWebAction: true),
      body: Center(
        child: Container(
          child: FutureBuilder<String>(
              future: HtmlHelper.inlineHtmlAsset(context, "ioshelp.html"),
              builder: (context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  return GestureDetector(
                    onPanUpdate: (details) {
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text(details.delta.dx > 0
                              ? "Swipe right"
                              : "Swipe left"),
                        ),
                      );
                    },
                    child: WebView(
                      initialUrl: Uri.dataFromString(snapshot.data,
                              mimeType: 'text/html',
                              encoding: Encoding.getByName('utf-8'))
                          .toString(),
                      javascriptMode: JavascriptMode.unrestricted,
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ),
      ),
    );
  }
}
