import 'package:flutter/widgets.dart';
import 'package:simple_animations/simple_animations.dart';

/// Abstract class that represents a single animation task that can be processed
/// inside an [AnimationControllerX].
abstract class AnimationTask {
  /// Time when start started
  Duration startedTime;

  /// Value of [AnimationControllerX] when task started
  double startedValue;
  bool _isCompleted = false;

  /// Callback fired when task starts
  AnimationTaskCallback onStart;

  /// Callback fired when task completes
  AnimationTaskCallback onComplete;

  AnimationTask({this.onStart, this.onComplete});

  /// Called when task starts
  started(Duration time, double value) {
    startedTime = time;
    startedValue = value;
    if (onStart != null) onStart();
  }

  /// Returns the new value of the animation
  double computeValue(Duration time);

  /// Called by [computeValue] when task completes.
  completeTask() {
    _isCompleted = true;
    if (onComplete != null) onComplete();
  }

  /// Returns whether the task is completed
  bool isCompleted() => _isCompleted;

  /// Called when task disposes
  void dispose() {}

  @mustCallSuper
  @override
  String toString() {
    return "(startedTime: $startedTime, startedValue: $startedValue)";
  }
}

typedef AnimationTaskCallback = Function();
