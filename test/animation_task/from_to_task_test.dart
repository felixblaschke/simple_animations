import 'package:flutter/animation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';

main() {
  test("asserts", () {
    // ignore: missing_required_param
    expect(() => FromToTask(), throwsA(isAssertionError));
    // ignore: missing_required_param
    expect(() => FromToTask(duration: Duration(seconds: 1)),
        throwsA(isAssertionError));
    // ignore: missing_required_param
    expect(() => FromToTask(to: 1.0), throwsA(isAssertionError));
  });

  test("non-zero start duration", () {
    final task = FromToTask(duration: Duration(seconds: 1), from: 0.0, to: 1.0);
    task.started(Duration(seconds: 3), 0.3);
    expectValue(task, 3000, 0.0, false);
    expectValue(task, 3500, 0.5, false);
    expectValue(task, 4000, 1.0, true);
  });

  test("linear 0.0 (implicit) to 1.0", () {
    final task = FromToTask(duration: Duration(seconds: 1), to: 1.0);
    task.started(Duration.zero, 0.0);
    expectValue(task, 0, 0.0, false);
    expectValue(task, 100, 0.1, false);
    expectValue(task, 250, 0.25, false);
    expectValue(task, 500, 0.5, false);
    expectValue(task, 750, 0.75, false);
    expectValue(task, 1000, 1.0, true);
    expectValue(task, 1200, 1.0, true);
  });

  test("linear 0.5 (implicit) to 1.0", () {
    final task = FromToTask(duration: Duration(seconds: 1), to: 1.0);
    task.started(Duration.zero, 0.5);
    expectValue(task, 0, 0.5, false);
    expectValue(task, 250, 0.75, false);
    expectValue(task, 500, 1.0, true);
  });

  test("linear 0.5 (implicit) to 1.0 (no recomputeDuration)", () {
    final task = FromToTask(
        duration: Duration(seconds: 1),
        to: 1.0,
        recomputeDurationBasedOnProgress: false);
    task.started(Duration.zero, 0.5);
    expectValue(task, 0, 0.5, false);
    expectValue(task, 500, 0.75, false);
    expectValue(task, 1000, 1.0, true);
  });

  test("linear 0.0 to 1.0", () {
    final task = FromToTask(duration: Duration(seconds: 1), from: 0.0, to: 1.0);
    task.started(Duration.zero, 0.3);
    expectValue(task, 0, 0.0, false);
    expectValue(task, 500, 0.5, false);
    expectValue(task, 1000, 1.0, true);
  });

  test("non-linear 0.0 to 1.0", () {
    final task = FromToTask(
        duration: Duration(seconds: 1),
        from: 0.0,
        to: 1.0,
        curve: Curves.easeIn);
    task.started(Duration.zero, 0.3);
    expectValue(task, 0, 0.0, false);
    expectValue(task, 250, 0.094, false);
    expectValue(task, 500, 0.316, false);
    expectValue(task, 750, 0.622, false);
    expectValue(task, 1000, 1.0, true);
  });

  test("linear 1.0 to 0.0", () {
    final task = FromToTask(duration: Duration(seconds: 1), from: 1.0, to: 0.0);
    task.started(Duration.zero, 0.3);
    expectValue(task, 0, 1.0, false);
    expectValue(task, 500, 0.5, false);
    expectValue(task, 1000, 0.0, true);
  });

  test("linear 0.25 to 0.75 (recomputeDuration)", () {
    final task =
        FromToTask(duration: Duration(seconds: 1), from: 0.25, to: 0.75);
    task.started(Duration.zero, 0.0);
    expectValue(task, 0, 0.25, false);
    expectValue(task, 250, 0.5, false);
    expectValue(task, 500, 0.75, true);
  });

  test("linear 0.25 to 0.75 (no recomputeDuration)", () {
    final task = FromToTask(
        duration: Duration(seconds: 1),
        from: 0.25,
        to: 0.75,
        recomputeDurationBasedOnProgress: false);
    task.started(Duration.zero, 0.0);
    expectValue(task, 0, 0.25, false);
    expectValue(task, 500, 0.5, false);
    expectValue(task, 1000, 0.75, true);
  });

  test("callbacks", () {
    var started = false;
    var completed = false;
    final task = FromToTask(
        duration: Duration(seconds: 1),
        to: 1.0,
        onStart: () => started = true,
        onComplete: () => completed = true);
    task.started(Duration.zero, 0.0);
    expect(started, true);
    task.computeValue(Duration(seconds: 1));
    expect(completed, true);
  });

  test("toString", () {
    final task = FromToTask(from: 0.3, to: 0.7, duration: Duration(seconds: 1));
    expect(task.toString(),
        "FromToAnimationTask(from: 0.3, to: 0.7, duration: 0:00:01.000000, curve: _Linear)(startedTime: null, startedValue: null)");
  });
}

expectValue(AnimationTask task, int durationMillis, double expectedValue,
    bool expectedIsComplete) {
  final value = task.computeValue(Duration(milliseconds: durationMillis));
  final isCompleted = task.isCompleted();

  expect((value * 1000.0).round() / 1000.0, expectedValue);
  expect(isCompleted, expectedIsComplete);
}
