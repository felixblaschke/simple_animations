import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';

void main() {
  testWidgets("builder", (WidgetTester tester) async {
    Text text;

    var animation = ControlledAnimation(
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

  testWidgets("builderWithChild", (WidgetTester tester) async {
    Text text;

    var animation = ControlledAnimation(
      duration: Duration(seconds: 100),
      tween: IntTween(begin: 0, end: 100),
      child: Text("static child"),
      builderWithChild: (context, child, value) {
        text = Text(value.toString());
        return MaterialApp(home: Row(children: [text, child]));
      },
    );

    await tester.pumpWidget(animation);
    await tester.pump(Duration(milliseconds: 100));

    expect(find.text("static child"), findsOneWidget);

    // start of animation
    expect(contentOf(text), '0');

    // half time
    await tester.pump(Duration(seconds: 50));
    expect(find.text("static child"), findsOneWidget);
    expect(contentOf(text), '50');

    // end of animation
    await tester.pump(Duration(seconds: 50));
    expect(find.text("static child"), findsOneWidget);
    expect(contentOf(text), '100');

    // after animation
    await tester.pump(Duration(seconds: 10));
    expect(find.text("static child"), findsOneWidget);
    expect(contentOf(text), '100');
  });

  testWidgets("delay", (WidgetTester tester) async {
    Text text;

    var animation = ControlledAnimation(
      delay: Duration(seconds: 10),
      duration: Duration(seconds: 100),
      tween: IntTween(begin: 0, end: 100),
      builder: (context, value) {
        text = Text(value.toString());
        return MaterialApp(home: text);
      },
    );

    await tester.pumpWidget(animation);
    await tester.pump(Duration(milliseconds: 100));

    // delaying
    expect(contentOf(text), '0');

    // start of animation / after delay
    await tester.pump(Duration(seconds: 10));
    expect(contentOf(text), '0');

    // half time
    await tester.pump(Duration(seconds: 50));
    expect(contentOf(text), '50');

    // end of animation
    await tester.pump(Duration(seconds: 50));
    expect(contentOf(text), '100');
  });

  testWidgets("reverse", (WidgetTester tester) async {
    Text text;

    var animation = ControlledAnimation(
      playback: Playback.PLAY_REVERSE,
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
    expect(contentOf(text), '0'); // animation is already at start

    // more time
    await tester.pump(Duration(seconds: 10));
    expect(contentOf(text), '0'); // same result
  });
}

contentOf(Text text) {
  final textToString = text.toString();
  return textToString.substring('Text("'.length, textToString.length - 2);
}
