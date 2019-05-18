import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';

main() {
  test("asserts", () {
    // ignore: missing_required_param
    expect(() => SetValueTask(), throwsA(isAssertionError));
  });

  test("value", () {
    final task = SetValueTask(value: 0.5);
    task.started(Duration.zero, 0.0);
    expect(task.isCompleted(), false);
    expect(task.computeValue(Duration.zero), 0.5);
    expect(task.isCompleted(), true);
  });

  test("callbacks", () {
    var started = false;
    var completed = false;
    final task = SetValueTask(
        value: 0.5,
        onStart: () => started = true,
        onComplete: () => completed = true);
    task.started(Duration.zero, 0.0);
    expect(started, true);
    task.computeValue(Duration.zero);
    expect(completed, true);
  });

  test("toString", () {
    final task = SetValueTask(value: 0.5);
    expect(task.toString(),
        "SetValueAnimationTask(value: 0.5)(startedTime: null, startedValue: null)");
  });
}
