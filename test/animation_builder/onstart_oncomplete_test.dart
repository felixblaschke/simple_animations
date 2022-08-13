import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';

import './widget_tester_extension.dart';

void main() {
  testWidgets('CustomAnimationBuilder forward', (WidgetTester tester) async {
    var playing = false;
    final animation = MaterialApp(
        home: CustomAnimationBuilder<int>(
      control: Control.play,
      duration: const Duration(days: 100),
      tween: IntTween(begin: 0, end: 100),
      builder: (context, value, child) => Container(),
      onStarted: () => playing = true,
      onCompleted: () => playing = false,
    ));

    expect(playing, false);

    await tester.addAnimationWidget(animation);
    await tester.wait(const Duration(days: 1));
    expect(playing, true);

    await tester.wait(const Duration(days: 100));
    expect(playing, false);
  });

  testWidgets('CustomAnimationBuilder backwards', (WidgetTester tester) async {
    var playing = false;
    final animation = MaterialApp(
        home: CustomAnimationBuilder<int>(
      control: Control.playReverse,
      startPosition: 1.0,
      duration: const Duration(days: 100),
      tween: IntTween(begin: 0, end: 100),
      builder: (context, value, child) => Container(),
      onStarted: () => playing = true,
      onCompleted: () => playing = false,
    ));

    expect(playing, false);

    await tester.addAnimationWidget(animation);
    await tester.wait(const Duration(days: 1));
    expect(playing, true);

    await tester.wait(const Duration(days: 100));
    expect(playing, false);
  });

  testWidgets('PlayAnimationBuilder forward', (WidgetTester tester) async {
    var playing = false;
    final animation = MaterialApp(
        home: PlayAnimationBuilder<int>(
      duration: const Duration(days: 100),
      tween: IntTween(begin: 0, end: 100),
      builder: (context, value, child) => Container(),
      onStarted: () => playing = true,
      onCompleted: () => playing = false,
    ));

    expect(playing, false);

    await tester.addAnimationWidget(animation);
    await tester.wait(const Duration(days: 1));
    expect(playing, true);

    await tester.wait(const Duration(days: 100));
    expect(playing, false);
  });
}
