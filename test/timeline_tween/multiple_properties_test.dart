import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';

void main() {
  test('multi props - simple', () {
    var timeline = TimelineTween<Prop>();
    timeline
        .addScene(
            begin: const Duration(seconds: 0),
            duration: const Duration(seconds: 1))
        .animate(Prop.width, tween: Tween(begin: 100.0, end: 200.0))
        .animate(Prop.height, tween: Tween(begin: 200.0, end: 100.0))
        .animate(Prop.color,
            tween: ColorTween(
                begin: const Color(0xFF000000), end: const Color(0xFFFF0000)));

    expect(timeline.duration, const Duration(seconds: 1));

    expect(timeline.transform(0.0 / 1.0).get<double>(Prop.width), 100.0);
    expect(timeline.transform(0.5 / 1.0).get<double>(Prop.width), 150.0);
    expect(timeline.transform(1.0 / 1.0).get<double>(Prop.width), 200.0);

    expect(timeline.transform(0.0 / 1.0).get<double>(Prop.height), 200.0);
    expect(timeline.transform(0.5 / 1.0).get<double>(Prop.height), 150.0);
    expect(timeline.transform(1.0 / 1.0).get<double>(Prop.height), 100.0);

    expect(timeline.transform(0.0 / 1.0).get<Color>(Prop.color),
        const Color(0xFF000000));
    expect(timeline.transform(0.5 / 1.0).get<Color>(Prop.color),
        const Color(0xFF7f0000));
    expect(timeline.transform(1.0 / 1.0).get<Color>(Prop.color),
        const Color(0xFFFF0000));
  });

  test('multi props - cascaded', () {
    var timeline = TimelineTween<Prop>();
    timeline
        .addScene(
            begin: const Duration(seconds: 0),
            duration: const Duration(seconds: 2))
        .animate(Prop.width, tween: Tween(begin: 100.0, end: 200.0));

    timeline
        .addScene(
            begin: const Duration(seconds: 1), end: const Duration(seconds: 3))
        .animate(Prop.height, tween: Tween(begin: 200.0, end: 100.0));

    timeline
        .addScene(
            end: const Duration(seconds: 4),
            duration: const Duration(seconds: 2))
        .animate(Prop.color,
            tween: ColorTween(
                begin: const Color(0xFF000000), end: const Color(0xFFFF0000)));

    expect(timeline.duration, const Duration(seconds: 4));

    expect(timeline.transform(0.0 / 4.0).get<double>(Prop.width), 100.0);
    expect(timeline.transform(1.0 / 4.0).get<double>(Prop.width), 150.0);
    expect(timeline.transform(2.0 / 4.0).get<double>(Prop.width), 200.0);
    expect(timeline.transform(2.5 / 4.0).get<double>(Prop.width), 200.0);
    expect(timeline.transform(4.0 / 4.0).get<double>(Prop.width), 200.0);

    expect(timeline.transform(0.0 / 4.0).get<double>(Prop.height), 200.0);
    expect(timeline.transform(1.0 / 4.0).get<double>(Prop.height), 200.0);
    expect(timeline.transform(2.0 / 4.0).get<double>(Prop.height), 150.0);
    expect(timeline.transform(3.0 / 4.0).get<double>(Prop.height), 100.0);
    expect(timeline.transform(4.0 / 4.0).get<double>(Prop.height), 100.0);

    expect(timeline.transform(0.0 / 4.0).get<Color>(Prop.color),
        const Color(0xFF000000));
    expect(timeline.transform(1.0 / 4.0).get<Color>(Prop.color),
        const Color(0xFF000000));
    expect(timeline.transform(2.0 / 4.0).get<Color>(Prop.color),
        const Color(0xFF000000));
    expect(timeline.transform(3.0 / 4.0).get<Color>(Prop.color),
        const Color(0xFF7f0000));
    expect(timeline.transform(4.0 / 4.0).get<Color>(Prop.color),
        const Color(0xFFFF0000));
  });
}

enum Prop { width, height, color }
