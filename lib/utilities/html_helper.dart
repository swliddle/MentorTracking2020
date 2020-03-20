import 'dart:convert';

import 'package:flutter/material.dart';

class HtmlHelper {
  static final _cachedImages = Map<String, String>();

  static Future<String> inlineHtml(BuildContext context, String html,
      {bool clearCache = false}) async {
    final inlineHtml = await _inlineImages(
        context,
        await _inlineJavaScriptResources(
            context, await _inlineCSSResources(context, html)));

    if (clearCache) {
      _cachedImages.clear();
    }

    return inlineHtml;
  }

  static Future<String> inlineHtmlAsset(BuildContext context, String assetName,
      {bool clearCache = false}) async {
    final html = await DefaultAssetBundle.of(context)
        .loadString('assets/html/$assetName');

    return inlineHtml(context, html, clearCache: clearCache);
  }

  static Future<void> _cacheImage(
      BuildContext context, String imageFile) async {
    final key = "url('$imageFile')";

    if (!_cachedImages.containsKey(key)) {
      final data =
          await DefaultAssetBundle.of(context).load('assets/html/$imageFile');
      final intData =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      _cachedImages[key] =
          'url(data:image/png;base64,${base64Encode(intData)})';
    }
  }

  static Future<String> _inlineCSSImages(
      BuildContext context, String html) async {
    var regexp = RegExp(r"url[(]'([^']*)'[)];", caseSensitive: false);
    var matches = regexp.allMatches(html).toList();

    if (matches.isNotEmpty) {
      matches.forEach((match) {
        print("Cache ${match[1]}");
        _cacheImage(context, match[1]);
      });
    }

    _cachedImages.forEach((key, encodedImage) {
      html = html.replaceAll(key, encodedImage);
    });

    return html;
  }

  static Future<String> _inlineCSSImports(
      BuildContext context, String html) async {
    // @import url("citation.css");

    var regexp = RegExp(r'@import\s*url[(]"([^"]*)"[)];', caseSensitive: false);
    var matches = regexp.allMatches(html).toList();

    if (matches.isNotEmpty) {
      for (int i = matches.length - 1; i >= 0; i--) {
        RegExpMatch match = matches[i];

        if (match.groupCount == 1) {
          var scriptSource = match.group(1);
          var scriptComponents = scriptSource.split(".");

          if (scriptComponents.length == 2) {
            var contents = await DefaultAssetBundle.of(context)
                .loadString('assets/html/$scriptSource');

            contents = await _inlineCSSImports(
                context, await _inlineCSSImages(context, contents));
            html = html.replaceRange(match.start, match.end, contents);
          }
        }
      }
    }

    return html;
  }

  static Future<String> _inlineCSSResources(
      BuildContext context, String html) async {
    // <link rel="stylesheet" type="text/css" href="gcen.css">

    var regexp = RegExp(r'<link\s*rel="stylesheet"[^>]*href="([^"]*)"[^>]*>',
        caseSensitive: false);
    var matches = regexp.allMatches(html).toList();

    if (matches.isNotEmpty) {
      for (int i = matches.length - 1; i >= 0; i--) {
        RegExpMatch match = matches[i];

        if (match.groupCount == 1) {
          var scriptSource = match.group(1);
          var scriptComponents = scriptSource.split(".");

          if (scriptComponents.length == 2) {
            var contents = await DefaultAssetBundle.of(context)
                .loadString('assets/html/$scriptSource');

            contents = await _inlineCSSImports(context, contents);
            contents = await _inlineCSSImports(
                context, await _inlineCSSImages(context, contents));
            html = html.replaceRange(match.start, match.end,
                '<style type="text/css">\n$contents</style>');
          }
        }
      }
    }

    return html;
  }

  static Future<String> _inlineImage(
      BuildContext context, String imageName) async {
    print("Inline $imageName");
    var imageData =
        await DefaultAssetBundle.of(context).load('assets/html/$imageName');
    var imageInts = imageData.buffer
        .asUint8List(imageData.offsetInBytes, imageData.lengthInBytes);

    return 'data:image/png;base64,${base64Encode(imageInts)}';
  }

  static Future<String> _inlineImages(BuildContext context, String html) async {
    var regexp =
        RegExp(r'(<img[^>]*src=")([^"]*)("[^>]*>)', caseSensitive: false);
    var matches = regexp.allMatches(html).toList();

    if (matches.isNotEmpty) {
      for (int i = matches.length - 1; i >= 0; i--) {
        RegExpMatch match = matches[i];

        if (match.groupCount == 3) {
          var prefix = match.group(1);
          var imageSource = match.group(2);
          var imageName = imageSource.split("/").last;
          var suffix = match.group(3);

          html = html.replaceRange(match.start, match.end,
              '$prefix${await _inlineImage(context, imageName)}$suffix');
        }
      }
    }

    return html;
  }

  static Future<String> _inlineJavaScriptResources(
      BuildContext context, String html) async {
    var regexp = RegExp(r'<script[^>]*src="([^"]*)"[^>]*>\s*</script>',
        caseSensitive: false);
    var matches = regexp.allMatches(html).toList();

    if (matches.isNotEmpty) {
      for (int i = matches.length - 1; i >= 0; i--) {
        RegExpMatch match = matches[i];

        if (match.groupCount == 1) {
          var scriptSource = match.group(1);
          var scriptComponents = scriptSource.split('.');

          if (scriptComponents.length == 2) {
            var contents = await DefaultAssetBundle.of(context)
                .loadString('assets/html/$scriptSource');

            html = html.replaceRange(match.start, match.end,
                '<script type="text/javascript">$contents</script>');
          }
        }
      }
    }

    return html;
  }
}
