import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supercharged/supercharged.dart';

void main() {
  test('curve on scene', () {
    var timeline = TimelineTween<Prop>();
    timeline
        .addScene(begin: 0.seconds, duration: 1.seconds, curve: Curves.easeOut)
        .animate(Prop.width, tween: 100.0.tweenTo(200.0));

    expect(timeline.duration, 1.seconds);
    expect(timeline.transform(0.0 / 1.0).get<double>(Prop.width).round(), 100);
    expect(timeline.transform(0.5 / 1.0).get<double>(Prop.width).round(), 168);
    expect(timeline.transform(1.0 / 1.0).get<double>(Prop.width).round(), 200);
  });

  test('curve on item overrides scene', () {
    var timeline = TimelineTween<Prop>();
    timeline
        .addScene(begin: 0.seconds, duration: 1.seconds, curve: Curves.easeOut)
        .animate(Prop.width, tween: 100.0.tweenTo(200.0), curve: Curves.linear)
        .animate(Prop.height, tween: 100.0.tweenTo(200.0));

    expect(timeline.duration, 1.seconds);
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
        .addScene(begin: 0.seconds, duration: 1.seconds, curve: Curves.easeOut)
        .animate(Prop.width, tween: 100.0.tweenTo(200.0));

    expect(timeline.duration, 1.seconds);
    expect(timeline.transform(0.0 / 1.0).get<double>(Prop.width).round(), 100);
    expect(timeline.transform(0.5 / 1.0).get<double>(Prop.width).round(), 168);
    expect(timeline.transform(1.0 / 1.0).get<double>(Prop.width).round(), 200);
  });
}

enum Prop { width, height }
