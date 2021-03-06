import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

void main() {
  test('scene durations - begin and duration', () {
    var timeline = TimelineTween<Prop>();
    timeline.addScene(begin: 1.seconds, duration: 1.seconds);
    expect(timeline.duration, 2.seconds);
  });

  test('scene durations - begin and end', () {
    var timeline = TimelineTween<Prop>();
    timeline.addScene(begin: 1.seconds, end: 2.seconds);
    expect(timeline.duration, 2.seconds);
  });

  test('scene durations - duration and end', () {
    var timeline = TimelineTween<Prop>();
    timeline.addScene(duration: 2.seconds, end: 4.seconds);
    expect(timeline.duration, 4.seconds);
  });

  test('scene durations - failures', () {
    expect(
        () => TimelineTween<Prop>().addScene(begin: 2.seconds, end: 0.seconds),
        throwsAssertionError);
    expect(
        () => TimelineTween<Prop>()
            .addScene(begin: 2.seconds, duration: -1.seconds),
        throwsAssertionError);
    expect(
        () => TimelineTween<Prop>()
            .addScene(begin: -1.seconds, duration: 2.seconds),
        throwsAssertionError);
    expect(() => TimelineTween<Prop>().addScene(duration: 2.seconds),
        throwsAssertionError);
  });
}

enum Prop { width }
