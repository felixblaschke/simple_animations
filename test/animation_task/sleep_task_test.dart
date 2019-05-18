import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';

main() {
  test("asserts", () {
    // ignore: missing_required_param
    expect(() => SleepTask(), throwsA(isAssertionError));
  });

  test("with duration", () {
    final task = SleepTask(duration: Duration(milliseconds: 500));
    task.started(Duration.zero, 0.0);
    expect(task.isCompleted(), false);
    expect(task.computeValue(Duration(milliseconds: 250)), 0.0);
    expect(task.isCompleted(), false);
    expect(task.computeValue(Duration(milliseconds: 500)), 0.0);
    expect(task.isCompleted(), true);
  });

  test("callbacks", () {
    var started = false;
    var completed = false;
    final task = SleepTask(
        duration: Duration(milliseconds: 500),
        onStart: () => started = true,
        onComplete: () => completed = true);
    task.started(Duration.zero, 0.0);
    expect(started, true);
    expect(task.computeValue(Duration(milliseconds: 250)), 0.0);
    expect(completed, false);
    expect(task.computeValue(Duration(milliseconds: 500)), 0.0);
    expect(completed, true);
  });

  test("toString", () {
    final task = SleepTask(duration: Duration(milliseconds: 500));
    expect(task.toString(),
        "SleepAnimationTask(duration: 0:00:00.500000)(startedTime: null, startedValue: null)");
  });
}
