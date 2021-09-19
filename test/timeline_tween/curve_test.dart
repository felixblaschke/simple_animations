import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';

void main() {
  test('curve on scene', () {
    var timeline = TimelineTween<Prop>();
    timeline
        .addScene(
            begin: const Duration(seconds: 0),
            duration: const Duration(seconds: 1),
            curve: Curves.easeOut)
        .animate(Prop.width, tween: Tween(begin: 100.0, end: 200.0));

    expect(timeline.duration, const Duration(seconds: 1));
    expect(timeline.transform(0.0 / 1.0).get<double>(Prop.width).round(), 100);
    expect(timeline.transform(0.5 / 1.0).get<double>(Prop.width).round(), 168);
    expect(timeline.transform(1.0 / 1.0).get<double>(Prop.width).round(), 200);
  });

  test('curve on item overrides scene', () {
    var timeline = TimelineTween<Prop>();
    timeline
        .addScene(
            begin: const Duration(seconds: 0),
            duration: const Duration(seconds: 1),
            curve: Curves.easeOut)
        .animate(Prop.width,
            tween: Tween(begin: 100.0, end: 200.0), curve: Curves.linear)
        .animate(Prop.height, tween: Tween(begin: 100.0, end: 200.0));

    expect(timeline.duration, const Duration(seconds: 1));
    expect(timeline.transform(0.0 / 1.0).get<double>(Prop.width), 100.0);
    expect(timeline.transform(0.25 / 1.0).get<double>(Prop.width), 125.0);
    expect(timeline.transform(0.5 / 1.0).get<double>(Prop.width), 150.0);
    expect(timeline.transform(0.75 / 1.0).get<double>(Prop.width), 175.0);
    expect(timeline.transform(1.0 / 1.0).get<double>(Prop.width), 200.0);

    expect(timeline.transform(0.0 / 1.0).get<double>(Prop.height).round(), 100);
    expect(
        timeline.transform(0.25 / 1.0).get<double>(Prop.height).round(), 138);
    expect(timeline.transform(0.5 / 1.0).get<double>(Prop.height).round(), 168);
    expect(
        timeline.transform(0.75 / 1.0).get<double>(Prop.height).round(), 191);
    expect(timeline.transform(1.0 / 1.0).get<double>(Prop.height).round(), 200);
  });

  test('default curve on timeline tween', () {
    var timeline = TimelineTween<Prop>();
    timeline
        .addScene(
            begin: const Duration(seconds: 0),
            duration: const Duration(seconds: 1),
            curve: Curves.easeOut)
        .animate(Prop.width, tween: Tween(begin: 100.0, end: 200.0));

    expect(timeline.duration, const Duration(seconds: 1));
    expect(timeline.transform(0.0 / 1.0).get<double>(Prop.width).round(), 100);
    expect(timeline.transform(0.5 / 1.0).get<double>(Prop.width).round(), 168);
    expect(timeline.transform(1.0 / 1.0).get<double>(Prop.width).round(), 200);
  });
}

enum Prop { width, height }
