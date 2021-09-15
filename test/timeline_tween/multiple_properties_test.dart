import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

void main() {
  test('multi props - simple', () {
    var timeline = TimelineTween<Prop>();
    timeline
        .addScene(begin: 0.seconds, duration: 1.seconds)
        .animate(Prop.width, tween: 100.0.tweenTo(200.0))
        .animate(Prop.height, tween: 200.0.tweenTo(100.0))
        .animate(Prop.color,
            tween: const Color(0xFF000000).tweenTo(const Color(0xFFFF0000)));

    expect(timeline.duration, 1.seconds);

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
        .addScene(begin: 0.seconds, duration: 2.seconds)
        .animate(Prop.width, tween: 100.0.tweenTo(200.0));

    timeline
        .addScene(begin: 1.seconds, end: 3.seconds)
        .animate(Prop.height, tween: 200.0.tweenTo(100.0));

    timeline.addScene(end: 4.seconds, duration: 2.seconds).animate(Prop.color,
        tween: const Color(0xFF000000).tweenTo(const Color(0xFFFF0000)));

    expect(timeline.duration, 4.seconds);

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
