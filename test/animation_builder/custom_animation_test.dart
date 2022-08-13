import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';

import './widget_tester_extension.dart';

void main() {
  testWidgets('CustomAnimationBuilder case1', (WidgetTester tester) async {
    var values = <int>[];
    final animation = MaterialApp(
        home: CustomAnimationBuilder<int>(
      duration: const Duration(days: 100),
      tween: IntTween(begin: 0, end: 100),
      builder: (context, value, child) {
        values.add(value);
        return Container();
      },
    ));

    await tester.addAnimationWidget(animation);

    for (var i = 0; i < 200; i++) {
      await tester.wait(const Duration(days: 1));
    }

    expect(values, expectedValues1);
  });

  testWidgets('CustomAnimationBuilder play from start',
      (WidgetTester tester) async {
    var values = <int>[];
    final animation = MaterialApp(
        home: CustomAnimationBuilder<int>(
      control: Control.playFromStart,
      duration: const Duration(days: 100),
      tween: IntTween(begin: 0, end: 100),
      startPosition: 0.5,
      builder: (context, value, child) {
        values.add(value);
        return Container();
      },
    ));

    await tester.addAnimationWidget(animation);

    for (var i = 0; i < 200; i++) {
      await tester.wait(const Duration(days: 1));
    }

    expect(values, expectedValues2);
  });

  testWidgets('CustomAnimationBuilder play reverse from end',
      (WidgetTester tester) async {
    var values = <int>[];
    final animation = MaterialApp(
        home: CustomAnimationBuilder<int>(
      control: Control.playReverseFromEnd,
      duration: const Duration(days: 100),
      tween: IntTween(begin: 0, end: 100),
      startPosition: 0.5,
      builder: (context, value, child) {
        values.add(value);
        return Container();
      },
    ));

    await tester.addAnimationWidget(animation);

    for (var i = 0; i < 200; i++) {
      await tester.wait(const Duration(days: 1));
    }

    expect(values, expectedValues3);
  });

  testWidgets('CustomAnimationBuilder child test', (WidgetTester tester) async {
    var animation = MaterialApp(
        home: CustomAnimationBuilder<int>(
      duration: const Duration(days: 100),
      tween: IntTween(begin: 0, end: 100),
      builder: (context, value, child) =>
          Row(children: [Text('$value'), child!]),
      child: const Text('static child'),
    ));

    await tester.addAnimationWidget(animation);

    expect(find.text('static child'), findsOneWidget);

    // start of animation
    expect(find.text('0'), findsOneWidget);

    // half time
    await tester.wait(const Duration(days: 50));
    expect(find.text('static child'), findsOneWidget);
    expect(find.text('50'), findsOneWidget);

    // end of animation
    await tester.wait(const Duration(days: 50));
    expect(find.text('static child'), findsOneWidget);
    expect(find.text('100'), findsOneWidget);

    // after animation
    await tester.wait(const Duration(days: 10));
    expect(find.text('static child'), findsOneWidget);
    expect(find.text('100'), findsOneWidget);
  });

  testWidgets('CustomAnimationBuilder delay', (WidgetTester tester) async {
    var animation = MaterialApp(
        home: CustomAnimationBuilder<int>(
      delay: const Duration(days: 10),
      duration: const Duration(days: 100),
      tween: IntTween(begin: 0, end: 100),
      builder: (context, value, child) => Text('$value'),
    ));

    await tester.addAnimationWidget(animation);

    // delaying
    expect(find.text('0'), findsOneWidget);

    // start of animation / after delay
    await tester.wait(const Duration(days: 10));
    expect(find.text('0'), findsOneWidget);

    // half time
    await tester.wait(const Duration(days: 50));
    expect(find.text('50'), findsOneWidget);

    // end of animation
    await tester.wait(const Duration(days: 50));
    expect(find.text('100'), findsOneWidget);
  });

  testWidgets('CustomAnimationBuilder reverse', (WidgetTester tester) async {
    var animation = MaterialApp(
        home: CustomAnimationBuilder<int>(
      control: Control.playReverse,
      duration: const Duration(days: 100),
      tween: IntTween(begin: 0, end: 100),
      builder: (context, value, child) => Text('$value'),
    ));

    await tester.addAnimationWidget(animation);

    // start of animation
    expect(find.text('0'), findsOneWidget); // animation is already at start

    // more time
    await tester.wait(const Duration(days: 10));
    expect(find.text('0'), findsOneWidget); // same result
  });

  testWidgets('CustomAnimationBuilder startPosition end & reverse',
      (WidgetTester tester) async {
    var animation = MaterialApp(
        home: CustomAnimationBuilder<int>(
      control: Control.playReverse,
      duration: const Duration(days: 100),
      tween: IntTween(begin: 0, end: 100),
      startPosition: 1.0,
      builder: (context, value, child) => Text('$value'),
    ));

    await tester.addAnimationWidget(animation);

    // start of animation
    expect(find.text('100'), findsOneWidget);

    // half time
    await tester.wait(const Duration(days: 50));
    expect(find.text('50'), findsOneWidget);

    // end of animation
    await tester.wait(const Duration(days: 50));
    expect(find.text('0'), findsOneWidget);

    // after animation
    await tester.wait(const Duration(days: 10));
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('CustomAnimationBuilder startPosition middle & stopped',
      (WidgetTester tester) async {
    var animation = MaterialApp(
        home: CustomAnimationBuilder<int>(
      control: Control.stop,
      duration: const Duration(days: 100),
      tween: IntTween(begin: 0, end: 100),
      startPosition: 0.5,
      builder: (context, value, child) {
        return Text('$value');
      },
    ));

    await tester.addAnimationWidget(animation);

    // start of animation
    expect(find.text('50'), findsOneWidget);

    await tester.wait(const Duration(days: 50));
    expect(find.text('50'), findsOneWidget);
  });

  testWidgets('CustomAnimationBuilder statusListener',
      (WidgetTester tester) async {
    var values = <String>[];
    var animation = MaterialApp(
        home: CustomAnimationBuilder<int>(
      control: Control.play,
      duration: const Duration(days: 100),
      tween: IntTween(begin: 0, end: 100),
      animationStatusListener: (status) => values.add(status.toString()),
      builder: (context, value, child) => Text('$value'),
    ));

    await tester.addAnimationWidget(animation);
    await tester.wait(const Duration(days: 200));

    expect(values, [
      AnimationStatus.forward.toString(),
      AnimationStatus.completed.toString()
    ]);
  });
}

const expectedValues1 = [
  0,
  0,
  1,
  1,
  2,
  2,
  3,
  3,
  4,
  4,
  5,
  5,
  6,
  6,
  7,
  7,
  8,
  8,
  9,
  9,
  10,
  10,
  11,
  11,
  12,
  12,
  13,
  13,
  14,
  14,
  15,
  15,
  16,
  16,
  17,
  17,
  18,
  18,
  19,
  19,
  20,
  20,
  21,
  21,
  22,
  22,
  23,
  23,
  24,
  24,
  25,
  25,
  26,
  26,
  27,
  27,
  28,
  28,
  29,
  29,
  30,
  30,
  31,
  31,
  32,
  32,
  33,
  33,
  34,
  34,
  35,
  35,
  36,
  36,
  37,
  37,
  38,
  38,
  39,
  39,
  40,
  40,
  41,
  41,
  42,
  42,
  43,
  43,
  44,
  44,
  45,
  45,
  46,
  46,
  47,
  47,
  48,
  48,
  49,
  49,
  50,
  50,
  51,
  51,
  52,
  52,
  53,
  53,
  54,
  54,
  55,
  55,
  56,
  56,
  57,
  57,
  58,
  58,
  59,
  59,
  60,
  60,
  61,
  61,
  62,
  62,
  63,
  63,
  64,
  64,
  65,
  65,
  66,
  66,
  67,
  67,
  68,
  68,
  69,
  69,
  70,
  70,
  71,
  71,
  72,
  72,
  73,
  73,
  74,
  74,
  75,
  75,
  76,
  76,
  77,
  77,
  78,
  78,
  79,
  79,
  80,
  80,
  81,
  81,
  82,
  82,
  83,
  83,
  84,
  84,
  85,
  85,
  86,
  86,
  87,
  87,
  88,
  88,
  89,
  89,
  90,
  90,
  91,
  91,
  92,
  92,
  93,
  93,
  94,
  94,
  95,
  95,
  96,
  96,
  97,
  97,
  98,
  98,
  99,
  99,
  100
];

const expectedValues2 = [
  0,
  0,
  1,
  1,
  2,
  2,
  3,
  3,
  4,
  4,
  5,
  5,
  6,
  6,
  7,
  7,
  8,
  8,
  9,
  9,
  10,
  10,
  11,
  11,
  12,
  12,
  13,
  13,
  14,
  14,
  15,
  15,
  16,
  16,
  17,
  17,
  18,
  18,
  19,
  19,
  20,
  20,
  21,
  21,
  22,
  22,
  23,
  23,
  24,
  24,
  25,
  25,
  26,
  26,
  27,
  27,
  28,
  28,
  29,
  29,
  30,
  30,
  31,
  31,
  32,
  32,
  33,
  33,
  34,
  34,
  35,
  35,
  36,
  36,
  37,
  37,
  38,
  38,
  39,
  39,
  40,
  40,
  41,
  41,
  42,
  42,
  43,
  43,
  44,
  44,
  45,
  45,
  46,
  46,
  47,
  47,
  48,
  48,
  49,
  49,
  50,
  50,
  51,
  51,
  52,
  52,
  53,
  53,
  54,
  54,
  55,
  55,
  56,
  56,
  57,
  57,
  58,
  58,
  59,
  59,
  60,
  60,
  61,
  61,
  62,
  62,
  63,
  63,
  64,
  64,
  65,
  65,
  66,
  66,
  67,
  67,
  68,
  68,
  69,
  69,
  70,
  70,
  71,
  71,
  72,
  72,
  73,
  73,
  74,
  74,
  75,
  75,
  76,
  76,
  77,
  77,
  78,
  78,
  79,
  79,
  80,
  80,
  81,
  81,
  82,
  82,
  83,
  83,
  84,
  84,
  85,
  85,
  86,
  86,
  87,
  87,
  88,
  88,
  89,
  89,
  90,
  90,
  91,
  91,
  92,
  92,
  93,
  93,
  94,
  94,
  95,
  95,
  96,
  96,
  97,
  97,
  98,
  98,
  99,
  99,
  100
];

const expectedValues3 = [
  100,
  100,
  99,
  99,
  98,
  98,
  97,
  97,
  96,
  96,
  95,
  95,
  94,
  94,
  93,
  93,
  92,
  92,
  91,
  91,
  90,
  90,
  89,
  89,
  88,
  88,
  87,
  87,
  86,
  86,
  85,
  85,
  84,
  84,
  83,
  83,
  82,
  82,
  81,
  81,
  80,
  80,
  79,
  79,
  78,
  78,
  77,
  77,
  76,
  76,
  75,
  75,
  74,
  74,
  73,
  73,
  72,
  72,
  71,
  71,
  70,
  70,
  69,
  69,
  68,
  68,
  67,
  67,
  66,
  66,
  65,
  65,
  64,
  64,
  63,
  63,
  62,
  62,
  61,
  61,
  60,
  60,
  59,
  59,
  58,
  58,
  57,
  57,
  56,
  56,
  55,
  55,
  54,
  54,
  53,
  53,
  52,
  52,
  51,
  51,
  50,
  50,
  49,
  49,
  48,
  48,
  47,
  47,
  46,
  46,
  45,
  45,
  44,
  44,
  43,
  43,
  42,
  42,
  41,
  41,
  40,
  40,
  39,
  39,
  38,
  38,
  37,
  37,
  36,
  36,
  35,
  35,
  34,
  34,
  33,
  33,
  32,
  32,
  31,
  31,
  30,
  30,
  29,
  29,
  28,
  28,
  27,
  27,
  26,
  26,
  25,
  25,
  24,
  24,
  23,
  23,
  22,
  22,
  21,
  21,
  20,
  20,
  19,
  19,
  18,
  18,
  17,
  17,
  16,
  16,
  15,
  15,
  14,
  14,
  13,
  13,
  12,
  12,
  11,
  11,
  10,
  10,
  9,
  9,
  8,
  8,
  7,
  7,
  6,
  6,
  5,
  5,
  4,
  4,
  3,
  3,
  2,
  2,
  1,
  1,
  0
];
