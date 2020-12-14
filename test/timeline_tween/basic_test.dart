import 'package:simple_animations/simple_animations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supercharged/supercharged.dart';

void main() {
  test('basic timeline', () {
    var timeline = TimelineTween<Prop>();
    timeline
        .addScene(begin: 0.seconds, duration: 1.seconds)
        .animate(Prop.width, tween: 100.0.tweenTo(200.0));

    expect(timeline.duration, 1.seconds);
    expect(timeline.transform(0.0 / 1.0).get<double>(Prop.width), 100.0);
    expect(timeline.transform(0.5 / 1.0).get<double>(Prop.width), 150.0);
    expect(timeline.transform(1.0 / 1.0).get<double>(Prop.width), 200.0);
  });

  test('delayed timeline', () {
    var timeline = TimelineTween<Prop>();
    timeline
        .addScene(begin: 1.seconds, duration: 1.seconds)
        .animate(Prop.width, tween: 100.0.tweenTo(200.0));

    expect(timeline.duration, 2.seconds);
    expect(timeline.transform(0.0 / 2.0).get<double>(Prop.width), 100.0);
    expect(timeline.transform(0.5 / 2.0).get<double>(Prop.width), 100.0);
    expect(timeline.transform(1.0 / 2.0).get<double>(Prop.width), 100.0);
    expect(timeline.transform(1.5 / 2.0).get<double>(Prop.width), 150.0);
    expect(timeline.transform(2.0 / 2.0).get<double>(Prop.width), 200.0);
  });

  test('extrapolating after scene', () {
    var timeline = TimelineTween<Prop>();
    timeline
        .addScene(begin: 1.seconds, duration: 1.seconds)
        .animate(Prop.width, tween: 100.0.tweenTo(200.0))
        .addSubsequentScene(duration: 1.seconds);

    expect(timeline.duration, 3.seconds);
    expect(timeline.transform(1.5 / 3.0).get<double>(Prop.width), 150.0);
    expect(timeline.transform(2.0 / 3.0).get<double>(Prop.width), 200.0);
    expect(timeline.transform(2.5 / 3.0).get<double>(Prop.width), 200.0);
    expect(timeline.transform(3.0 / 3.0).get<double>(Prop.width), 200.0);
  });

  test('multiple scenes', () {
    var timeline = TimelineTween<Prop>();
    timeline
        .addScene(begin: 1.seconds, end: 2.seconds)
        .animate(Prop.width, tween: 100.0.tweenTo(200.0));

    timeline
        .addScene(begin: 3.seconds, end: 4.seconds)
        .animate(Prop.width, tween: 300.0.tweenTo(400.0));

    timeline.addScene(end: 5.seconds, duration: 0.seconds);

    expect(timeline.duration, 5.seconds);
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
        .addScene(begin: 1.seconds, end: 2.seconds)
        .animate(Prop.width, tween: 100.0.tweenTo(200.0));

    first
        .addSubsequentScene(delay: 1.seconds, duration: 1.seconds)
        .animate(Prop.width, tween: 300.0.tweenTo(400.0));

    timeline.addScene(end: 5.seconds, duration: 0.seconds);

    expect(timeline.duration, 5.seconds);
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
