import 'package:meta/meta.dart';

abstract class AnimationTask {
  Duration startedTime;
  double startedValue;
  bool _isCompleted = false;

  AnimationTaskCallback onStart;
  AnimationTaskCallback onComplete;

  AnimationTask({this.onStart, this.onComplete});

  started(Duration time, double value) {
    startedTime = time;
    startedValue = value;
    if (onStart != null) onStart();
  }

  computeValue(Duration time);

  taskCompleted() {
    _isCompleted = true;
    if (onComplete != null) onComplete();
  }

  bool isCompleted() => _isCompleted;

  void dispose() {}

  @mustCallSuper
  @override
  String toString() {
    return "(startedTime: $startedTime, startedValue: $startedValue)";
  }
}

typedef AnimationTaskCallback = Function();
