// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mentor_tracking/utilities/html_helper.dart';

_testHtmlHelper(BuildContext context) async {
  var html = await DefaultAssetBundle.of(context)
      .loadString('assets/html/ioshelp.html');

  var inlinedHtml = await HtmlHelper.inlineHtml(context, html);

  expect(inlinedHtml, html);
  expect(0, 1);
}

class TestHtmlHelper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _testHtmlHelper(context);

    return Placeholder();
  }
}

void main() {
  testWidgets('HTML Helper', (WidgetTester tester) async {
    await tester.pumpWidget(TestHtmlHelper(), Duration(seconds: 5));
  });
  /*
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(null));

    // Verify that our counter starts at 0.
    expect(find.text('CET Mentor Tracking'), findsNothing);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('Enter Mentee Info:'), findsOneWidget);
  });

   */
}
