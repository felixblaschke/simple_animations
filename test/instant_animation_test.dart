import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';

void main() {
  testWidgets("InstantAnimation", (WidgetTester tester) async {
    Text text;

    var animation = InstantAnimation(
      duration: Duration(seconds: 100),
      tween: IntTween(begin: 0, end: 100),
      builder: (context, value) {
        text = Text(value.toString());

        return MaterialApp(home: text);
      },
    );

    await tester.pumpWidget(animation);
    await tester.pump(Duration(milliseconds: 100));

    // start of animation
    expect(contentOf(text), '0');

    // half time
    await tester.pump(Duration(seconds: 50));
    expect(contentOf(text), '50');

    // end of animation
    await tester.pump(Duration(seconds: 50));
    expect(contentOf(text), '100');

    // after animation
    await tester.pump(Duration(seconds: 10));
    expect(contentOf(text), '100');
  });
}

contentOf(Text text) {
  final textToString = text.toString();
  return textToString.substring('Text("'.length, textToString.length - 2);
}
