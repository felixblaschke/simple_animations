import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';

void main() {
  test('overlapping property', () {
    var timeline = TimelineTween<Prop>();
    timeline
        .addScene(
            begin: const Duration(seconds: 0),
            duration: const Duration(seconds: 2))
        .animate(Prop.width, tween: Tween(begin: 0.0, end: 100.0));

    timeline
        .addScene(
            begin: const Duration(seconds: 1),
            duration: const Duration(seconds: 2))
        .animate(Prop.width, tween: Tween(begin: 200.0, end: 300.0));

    expect(timeline.transform(0.0 / 3.0).get<double>(Prop.width), 0.0);
    expect(timeline.transform(0.5 / 3.0).get<double>(Prop.width), 25.0);
    expect(timeline.transform(1.0 / 3.0).get<double>(Prop.width), 50.0);
    expect(timeline.transform(1.5 / 3.0).get<double>(Prop.width), 75.0);
    expect(timeline.transform(2.0 / 3.0).get<double>(Prop.width), 100.0);
    expect(timeline.transform(2.5 / 3.0).get<double>(Prop.width), 275.0);
    expect(timeline.transform(3.0 / 3.0).get<double>(Prop.width), 300.0);
  });

  test('between multiple scenes', () {
    var timeline = TimelineTween<Prop>();
    timeline
        .addScene(
            begin: const Duration(seconds: 0), end: const Duration(seconds: 1))
        .animate(Prop.width, tween: Tween(begin: 10.0, end: 20.0));

    timeline
        .addScene(
            begin: const Duration(seconds: 2), end: const Duration(seconds: 3))
        .animate(Prop.width, tween: Tween(begin: 100.0, end: 200.0));

    timeline
        .addScene(
            begin: const Duration(seconds: 4), end: const Duration(seconds: 5))
        .animate(Prop.width, tween: Tween(begin: 1000.0, end: 2000.0));

    expect(timeline.transform(1.5 / 5.0).get<double>(Prop.width), 20.0);
    expect(timeline.transform(3.5 / 5.0).get<double>(Prop.width), 200.0);
  });
}

enum Prop { width }
