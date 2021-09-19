import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';

void main() {
  test('basic timeline', () {
    var timeline = TimelineTween<Prop>();
    timeline
        .addScene(
            begin: const Duration(seconds: 0),
            duration: const Duration(seconds: 1))
        .animate(Prop.width, tween: Tween(begin: 100.0, end: 200.0));

    expect(timeline.duration, const Duration(seconds: 1));
    expect(timeline.transform(0.0 / 1.0).get<double>(Prop.width), 100.0);
    expect(timeline.transform(0.5 / 1.0).get<double>(Prop.width), 150.0);
    expect(timeline.transform(1.0 / 1.0).get<double>(Prop.width), 200.0);
  });

  test('delayed timeline', () {
    var timeline = TimelineTween<Prop>();
    timeline
        .addScene(
            begin: const Duration(seconds: 1),
            duration: const Duration(seconds: 1))
        .animate(Prop.width, tween: Tween(begin: 100.0, end: 200.0));

    expect(timeline.duration, const Duration(seconds: 2));
    expect(timeline.transform(0.0 / 2.0).get<double>(Prop.width), 100.0);
    expect(timeline.transform(0.5 / 2.0).get<double>(Prop.width), 100.0);
    expect(timeline.transform(1.0 / 2.0).get<double>(Prop.width), 100.0);
    expect(timeline.transform(1.5 / 2.0).get<double>(Prop.width), 150.0);
    expect(timeline.transform(2.0 / 2.0).get<double>(Prop.width), 200.0);
  });

  test('extrapolating after scene', () {
    var timeline = TimelineTween<Prop>();
    timeline
        .addScene(
            begin: const Duration(seconds: 1),
            duration: const Duration(seconds: 1))
        .animate(Prop.width, tween: Tween(begin: 100.0, end: 200.0))
        .addSubsequentScene(duration: const Duration(seconds: 1));

    expect(timeline.duration, const Duration(seconds: 3));
    expect(timeline.transform(1.5 / 3.0).get<double>(Prop.width), 150.0);
    expect(timeline.transform(2.0 / 3.0).get<double>(Prop.width), 200.0);
    expect(timeline.transform(2.5 / 3.0).get<double>(Prop.width), 200.0);
    expect(timeline.transform(3.0 / 3.0).get<double>(Prop.width), 200.0);
  });

  test('multiple scenes', () {
    var timeline = TimelineTween<Prop>();
    timeline
        .addScene(
            begin: const Duration(seconds: 1), end: const Duration(seconds: 2))
        .animate(Prop.width, tween: Tween(begin: 100.0, end: 200.0));

    timeline
        .addScene(
            begin: const Duration(seconds: 3), end: const Duration(seconds: 4))
        .animate(Prop.width, tween: Tween(begin: 300.0, end: 400.0));

    timeline.addScene(
        end: const Duration(seconds: 5), duration: const Duration(seconds: 0));

    expect(timeline.duration, const Duration(seconds: 5));
    expect(timeline.transform(0.0 / 5.0).get<double>(Prop.width), 100.0);
    expect(timeline.transform(1.0 / 5.0).get<double>(Prop.width), 100.0);
    expect(timeline.transform(1.5 / 5.0).get<double>(Prop.width), 150.0);
    expect(timeline.transform(2.0 / 5.0).get<double>(Prop.width), 200.0);
    expect(timeline.transform(2.5 / 5.0).get<double>(Prop.width), 200.0);
    expect(timeline.transform(2.95 / 5.0).get<double>(Prop.width), 200.0);
    expect(timeline.transform(3.0 / 5.0).get<double>(Prop.width), 300.0);
    expect(timeline.transform(3.5 / 5.0).get<double>(Prop.width), 350.0);
    expect(timeline.transform(4.0 / 5.0).get<double>(Prop.width), 400.0);
    expect(timeline.transform(4.5 / 5.0).get<double>(Prop.width), 400.0);
    expect(timeline.transform(5.0 / 5.0).get<double>(Prop.width), 400.0);
  });

  test('multiple scenes with addSubsequentScene', () {
    var timeline = TimelineTween<Prop>();
    var first = timeline
        .addScene(
            begin: const Duration(seconds: 1), end: const Duration(seconds: 2))
        .animate(Prop.width, tween: Tween(begin: 100.0, end: 200.0));

    first
        .addSubsequentScene(
            delay: const Duration(seconds: 1),
            duration: const Duration(seconds: 1))
        .animate(Prop.width, tween: Tween(begin: 300.0, end: 400.0));

    timeline.addScene(
        end: const Duration(seconds: 5), duration: const Duration(seconds: 0));

    expect(timeline.duration, const Duration(seconds: 5));
    expect(timeline.transform(0.0 / 5.0).get<double>(Prop.width), 100.0);
    expect(timeline.transform(1.0 / 5.0).get<double>(Prop.width), 100.0);
    expect(timeline.transform(1.5 / 5.0).get<double>(Prop.width), 150.0);
    expect(timeline.transform(2.0 / 5.0).get<double>(Prop.width), 200.0);
    expect(timeline.transform(2.5 / 5.0).get<double>(Prop.width), 200.0);
    expect(timeline.transform(2.95 / 5.0).get<double>(Prop.width), 200.0);
    expect(timeline.transform(3.0 / 5.0).get<double>(Prop.width), 300.0);
    expect(timeline.transform(3.5 / 5.0).get<double>(Prop.width), 350.0);
    expect(timeline.transform(4.0 / 5.0).get<double>(Prop.width), 400.0);
    expect(timeline.transform(4.5 / 5.0).get<double>(Prop.width), 400.0);
    expect(timeline.transform(5.0 / 5.0).get<double>(Prop.width), 400.0);
  });
}

enum Prop { width }
