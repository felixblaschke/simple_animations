import 'package:flutter/animation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';

main() {
  test("no value", () {
    // ignore: missing_required_param
    expect(() => LoopAnimationTask(), throwsA(isAssertionError));
    // ignore: missing_required_param
    expect(() => LoopAnimationTask(duration: Duration(seconds: 1)),
        throwsA(isAssertionError));
    // ignore: missing_required_param
    expect(() => LoopAnimationTask(to: 1.0), throwsA(isAssertionError));
    // ignore: missing_required_param
    expect(
        () => LoopAnimationTask(from: 0.0, to: 1.0), throwsA(isAssertionError));
  });

  // TODO more tests for different cases
  // TODO - fromCurrentStartPosition
  // TODO - interval [0.25-0.75]
  // TODO - non-linear curve
  // TODO - limit iterations
  // TODO - unlimited iteration
  // TODO - mirrored

  test("callbacks", () {
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
    expect(task.toString(), "");
  });
}

expectValue(AnimationTask task, int durationMillis, double expectedValue,
    bool expectedIsComplete) {
  final value = task.computeValue(Duration(milliseconds: durationMillis));
  final isCompleted = task.isCompleted();

  expect((value * 1000.0).round() / 1000.0, expectedValue);
  expect(isCompleted, expectedIsComplete);
}
