import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';

void main() {
  test('scene durations - begin and duration', () {
    var timeline = TimelineTween<Prop>();
    timeline.addScene(
        begin: const Duration(seconds: 1),
        duration: const Duration(seconds: 1));
    expect(timeline.duration, const Duration(seconds: 2));
  });

  test('scene durations - begin and end', () {
    var timeline = TimelineTween<Prop>();
    timeline.addScene(
        begin: const Duration(seconds: 1), end: const Duration(seconds: 2));
    expect(timeline.duration, const Duration(seconds: 2));
  });

  test('scene durations - duration and end', () {
    var timeline = TimelineTween<Prop>();
    timeline.addScene(
        duration: const Duration(seconds: 2), end: const Duration(seconds: 4));
    expect(timeline.duration, const Duration(seconds: 4));
  });

  test('scene durations - failures', () {
    expect(
        () => TimelineTween<Prop>().addScene(
            begin: const Duration(seconds: 2), end: const Duration(seconds: 0)),
        throwsAssertionError);
    expect(
        () => TimelineTween<Prop>().addScene(
            begin: const Duration(seconds: 2),
            duration: -const Duration(seconds: 1)),
        throwsAssertionError);
    expect(
        () => TimelineTween<Prop>().addScene(
            begin: -const Duration(seconds: 1),
            duration: const Duration(seconds: 2)),
        throwsAssertionError);
    expect(
        () => TimelineTween<Prop>()
            .addScene(duration: const Duration(seconds: 2)),
        throwsAssertionError);
  });
}

enum Prop { width }
