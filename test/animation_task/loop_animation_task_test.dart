import 'package:flutter/animation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';

main() {
  test("asserts", () {
    // ignore: missing_required_param
    expect(() => LoopAnimationTask(), throwsA(isAssertionError));
    // ignore: missing_required_param
    expect(() => LoopAnimationTask(duration: Duration(seconds: 1)),
        throwsA(isAssertionError));
    // ignore: missing_required_param
    expect(() => LoopAnimationTask(to: 1.0), throwsA(isAssertionError));
    expect(
        // ignore: missing_required_param
        () => LoopAnimationTask(from: 0.0, to: 1.0),
        throwsA(isAssertionError));
  });

  test("unlimited from 0.0 to 1.0", () {
    final task = LoopAnimationTask(
      duration: Duration(seconds: 1),
      from: 0.0,
      to: 1.0,
    );

    task.started(Duration.zero, 0.0);
    expectValue(task, 0, 0.0, false);
    expectValue(task, 800, 0.8, false);
    expectValue(task, 1000, 1.0, false);
    expectValue(task, 1200, 0.2, false);
    expectValue(task, 2000, 1.0, false);
    expectValue(task, 50000, 1.0, false);
  });

  test("unlimited from 0.0 to 1.0 with non-linear curve", () {
    final task = LoopAnimationTask(
      duration: Duration(seconds: 1),
      from: 0.0,
      to: 1.0,
      curve: Curves.easeIn,
    );

    task.started(Duration.zero, 0.0);
    expectValue(task, 0, 0.0, false);
    expectValue(task, 200, 0.063, false);
    expectValue(task, 400, 0.215, false);
    expectValue(task, 600, 0.43, false);
    expectValue(task, 800, 0.692, false);
    expectValue(task, 1000, 1.0, false);
    expectValue(task, 1200, 0.063, false);
  });

  test("unlimited from 0.25 to 0.75", () {
    final task = LoopAnimationTask(
      duration: Duration(seconds: 1),
      from: 0.25,
      to: 0.75,
      startOnCurrentPosition: false,
    );

    task.started(Duration.zero, 0.5);
    expectValue(task, 0, 0.25, false);
    expectValue(task, 250, 0.5, false);
    expectValue(task, 500, 0.75, false);
    expectValue(task, 750, 0.25, false);
  });

  test("unlimited from 0.25 to 0.75 with startOnCurrentPosition", () {
    final task = LoopAnimationTask(
      duration: Duration(seconds: 1),
      from: 0.25,
      to: 0.75,
      startOnCurrentPosition: true,
    );

    task.started(Duration.zero, 0.5);
    expectValue(task, 0, 0.5, false);
    expectValue(task, 250, 0.75, false);
    expectValue(task, 500, 0.25, false);
    expectValue(task, 750, 0.25, false);
  });

  test("unlimited from 0.0 to 1.0 mirrored", () {
    final task = LoopAnimationTask(
      duration: Duration(seconds: 1),
      from: 0.0,
      to: 1.0,
      mirror: true,
    );

    task.started(Duration.zero, 0.0);
    expectValue(task, 0, 0.0, false);
    expectValue(task, 800, 0.8, false);
    expectValue(task, 1000, 1.0, false);
    expectValue(task, 1200, 0.8, false);
    expectValue(task, 1800, 0.2, false);
    expectValue(task, 2000, 0.0, false);
    expectValue(task, 2200, 0.2, false);
    expectValue(task, 3000, 1.0, false);
    expectValue(task, 4000, 0.0, false);
    expectValue(task, 5000, 1.0, false);
  });

  test("callbacks / limited iterations", () {
    var started = false;
    var completed = false;
    var numIterationsCompleted = 0;
    final task = LoopAnimationTask(
        duration: Duration(seconds: 1),
        from: 0.0,
        to: 1.0,
        iterations: 2,
        onStart: () => started = true,
        onComplete: () => completed = true,
        onIterationCompleted: () => numIterationsCompleted++);

    task.started(Duration.zero, 0.0);
    expect(started, true);
    expect(numIterationsCompleted, 0);
    expectValue(task, 0, 0.0, false);
    expect(numIterationsCompleted, 0);

    expectValue(task, 1000, 1.0, false);
    expect(numIterationsCompleted, 1);

    expectValue(task, 2000, 1.0, true);
    expect(numIterationsCompleted, 2);
    expect(completed, true);
  });

  test("toString", () {
    final task = LoopAnimationTask(
        duration: Duration(seconds: 1),
        from: 0.0,
        to: 1.0,
        mirror: false,
        curve: Curves.bounceInOut);
    expect(task.toString(),
        "LoopAnimationTask(from: 0.0, to: 1.0, iterationDuration: 0:00:01.000000, iterations: null, mirror: false, curve: _BounceInOutCurve)(startedTime: null, startedValue: null)");
  });
}

expectValue(AnimationTask task, int durationMillis, double expectedValue,
    bool expectedIsComplete) {
  final value = task.computeValue(Duration(milliseconds: durationMillis));
  final isCompleted = task.isCompleted();

  expect((value * 1000.0).round() / 1000.0, expectedValue);
  expect(isCompleted, expectedIsComplete);
}
