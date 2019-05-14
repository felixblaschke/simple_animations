import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';

main() {
  test("asserts", () {
    // ignore: missing_required_param
    expect(() => ConditionalAnimationTask(), throwsA(isAssertionError));
  });

  test("predicate", () {
    var predicateResult = false;
    final task = ConditionalAnimationTask(predicate: () => predicateResult);
    task.started(Duration.zero, 0.0);
    expect(task.isCompleted(), false);
    expect(task.computeValue(Duration.zero), 0.0);
    expect(task.isCompleted(), false);
    expect(task.computeValue(Duration.zero), 0.0);

    predicateResult = true;
    expect(task.computeValue(Duration.zero), 0.0);
    expect(task.isCompleted(), true);
  });

  test("callbacks", () {
    var started = false;
    var completed = false;
    final task = ConditionalAnimationTask(
        predicate: () => true,
        onStart: () => started = true,
        onComplete: () => completed = true);
    task.started(Duration.zero, 0.0);
    expect(started, true);
    task.computeValue(Duration.zero);
    expect(completed, true);
  });

  test("toString", () {
    final task = ConditionalAnimationTask(predicate: () => true);
    expect(task.toString(),
        "ConditionalAnimationTask()(startedTime: null, startedValue: null)");
  });
}
