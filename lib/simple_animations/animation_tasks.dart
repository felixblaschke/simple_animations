import 'dart:math';
import 'package:meta/meta.dart';
import 'animation_task.dart';

class ConditionalAnimationTask extends AnimationTask {
  bool Function() predicate;

  ConditionalAnimationTask({
    this.predicate,
    AnimationTaskCallback onStart,
    AnimationTaskCallback onComplete,
  }) : super(onStart: onStart, onComplete: onComplete);

  @override
  computeValue(Duration time) {
    if (predicate()) {
      taskCompleted();
    }

    return startedValue;
  }

  @override
  String toString() {
    return "ConditionalAnimationTask()${super.toString()}";
  }
}

class SleepAnimationTask extends AnimationTask {
  Duration duration;

  SleepAnimationTask({
    @required this.duration,
    AnimationTaskCallback onStart,
    AnimationTaskCallback onComplete,
  })  : assert(duration != null, "Please provide a sleeping duration."),
        super(onStart: onStart, onComplete: onComplete);

  @override
  computeValue(Duration time) {
    final timePassed = time - startedTime;
    if (timePassed.inMilliseconds >= duration.inMilliseconds) {
      taskCompleted();
    }
    return startedValue;
  }

  @override
  String toString() {
    return "SleepAnimationTask(duration: $duration)${super.toString()}";
  }
}

class FromToAnimationTask extends AnimationTask {
  Duration duration;
  bool recomputeDurationBasedOnProgress;
  double from;
  double to;
  // TODO add curve parameter

  FromToAnimationTask({
    @required this.duration,
    @required this.to,
    this.recomputeDurationBasedOnProgress = true,
    this.from,
    AnimationTaskCallback onStart,
    AnimationTaskCallback onComplete,
  })  : assert(to != null,
            "Missing paramter 'to'. You need to specify a value to animate to."),
        super(onStart: onStart, onComplete: onComplete);

  @override
  computeValue(Duration time) {
    final fromValue = (from == null ? startedValue : from).clamp(0.0, 1.0);
    final toValue = to.clamp(0.0, 1.0);
    final delta = (toValue - fromValue).abs();
    final durationMillis = recomputeDurationBasedOnProgress
        ? delta * duration.inMilliseconds
        : duration.inMilliseconds;

    double value;

    if (durationMillis == 0) {
      value = toValue;
    } else {
      final timePassed = time - startedTime;
      final progress = timePassed.inMilliseconds / durationMillis;
      value = (fromValue * (1 - progress) + progress * toValue)
          .clamp(min(fromValue, toValue), max(fromValue, toValue));
    }

    if (value == toValue) taskCompleted();

    return value;
  }

  @override
  String toString() {
    return "FromToAnimationTask(from: $from, to: $to, duration: $duration)${super.toString()}";
  }
}

class LoopAnimationTask extends AnimationTask {
  double from;
  double to;
  Duration iterationDuration;
  int iterations;
  bool startWithCurrentPosition;
  bool mirrorIterations;
  AnimationTaskCallback onIterationCompleted;
  // TODO add curve parameter

  LoopAnimationTask({
    @required this.iterationDuration,
    this.from,
    @required this.to,
    this.iterations,
    this.startWithCurrentPosition = true,
    this.mirrorIterations = false,
    this.onIterationCompleted,
    AnimationTaskCallback onStart,
    AnimationTaskCallback onComplete,
  }) : super(onStart: onStart, onComplete: onComplete);

  FromToAnimationTask _currentIterationTask;
  var _iterationsPassed = 0;

  @override
  computeValue(Duration time) {
    if (_currentIterationTask == null) {
      _createAnimationTaskForCurrentIteration(time);
    }

    final value = _currentIterationTask.computeValue(time);

    if (_currentIterationTask.isCompleted()) {
      finishIteration();
    }

    return value;
  }

  void _createAnimationTaskForCurrentIteration(Duration time) {
    var fromValue = from;
    var toValue = to;

    if (startWithCurrentPosition && _iterationsPassed == 0) {
      fromValue = startedValue;
    }

    if (mirrorIterations && _iterationsPassed % 2 == 1) {
      final swapValue = toValue;
      toValue = fromValue;
      fromValue = swapValue;
    }

    _currentIterationTask = FromToAnimationTask(
        duration: iterationDuration, from: fromValue, to: toValue);
    _currentIterationTask.started(time, startedValue);
  }

  void finishIteration() {
    if (onIterationCompleted != null) onIterationCompleted();

    _currentIterationTask.dispose();
    _currentIterationTask = null;
    _iterationsPassed++;

    if (iterations != null && _iterationsPassed == iterations) {
      taskCompleted();
    }
  }

  @override
  String toString() {
    return "LoopAnimationTask(from: $from, to: $to, iterationDuration: $iterationDuration, iterations: $iterations, mirror: $mirrorIterations)${super.toString()}";
  }
}

class SetValueAnimationTask extends AnimationTask {
  final double value;

  SetValueAnimationTask({
    @required this.value,
    AnimationTaskCallback onStart,
    AnimationTaskCallback onComplete,
  })  : assert(value != null, "Please provide a value"),
        super(onStart: onStart, onComplete: onComplete);

  @override
  computeValue(Duration time) {
    taskCompleted();
    return value;
  }

  @override
  String toString() {
    return "SetValueAnimationTask(value: $value)${super.toString()}";
  }
}
