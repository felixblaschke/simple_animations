import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';

import './widget_tester_extension.dart';

void main() {
  testWidgets('CustomAnimation forward', (WidgetTester tester) async {
    var playing = false;
    final animation = MaterialApp(
        home: CustomAnimation<int>(
      control: CustomAnimationControl.play,
      duration: const Duration(days: 100),
      tween: IntTween(begin: 0, end: 100),
      builder: (context, child, value) => Container(),
      onStart: () => playing = true,
      onComplete: () => playing = false,
    ));

    expect(playing, false);

    await tester.addAnimationWidget(animation);
    await tester.wait(const Duration(days: 1));
    expect(playing, true);

    await tester.wait(const Duration(days: 100));
    expect(playing, false);
  });

  testWidgets('CustomAnimation backwards', (WidgetTester tester) async {
    var playing = false;
    final animation = MaterialApp(
        home: CustomAnimation<int>(
      control: CustomAnimationControl.playReverse,
      startPosition: 1.0,
      duration: const Duration(days: 100),
      tween: IntTween(begin: 0, end: 100),
      builder: (context, child, value) => Container(),
      onStart: () => playing = true,
      onComplete: () => playing = false,
    ));

    expect(playing, false);

    await tester.addAnimationWidget(animation);
    await tester.wait(const Duration(days: 1));
    expect(playing, true);

    await tester.wait(const Duration(days: 100));
    expect(playing, false);
  });

  testWidgets('PlayAnimation forward', (WidgetTester tester) async {
    var playing = false;
    final animation = MaterialApp(
        home: PlayAnimation<int>(
      duration: const Duration(days: 100),
      tween: IntTween(begin: 0, end: 100),
      builder: (context, child, value) => Container(),
      onStart: () => playing = true,
      onComplete: () => playing = false,
    ));

    expect(playing, false);

    await tester.addAnimationWidget(animation);
    await tester.wait(const Duration(days: 1));
    expect(playing, true);

    await tester.wait(const Duration(days: 100));
    expect(playing, false);
  });
}
