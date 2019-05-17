import 'package:flutter/animation.dart';
import 'package:flutter/scheduler.dart';
import 'package:meta/meta.dart';

import 'package:simple_animations/simple_animations/animation_task/animation_task.dart';

class AnimationControllerX extends Animation<double>
    with
        AnimationEagerListenerMixin,
        AnimationLocalListenersMixin,
        AnimationLocalStatusListenersMixin {
  Ticker _ticker;
  StatusChangeCallback onStatusChange;

  AnimationTask _currentTask;
  List<AnimationTask> _tasks = [];

  AnimationControllerX({@required TickerProvider vsync, this.onStatusChange}) {
    if (vsync != null) {
      configureVsync(vsync);
    }
  }

  void configureVsync(TickerProvider vsync) {
    assert(_ticker == null, "Vsync is already configured.");
    assert(vsync != null, "Expected to provide a 'vsync'.");
    _ticker = vsync.createTicker(_tick);
    _ticker.start();
  }

  void _tick(Duration time) {
    if (_tasks.isEmpty && _currentTask == null) {
      return;
    }

    if (_currentTask == null) {
      _createNewTask(time);
    }

    _computeValue(time);

    if (_currentTask.isCompleted()) {
      completeCurrentTask();
    }
  }

  void _createNewTask(Duration time) {
    _currentTask = _tasks.removeAt(0);
    _currentTask.started(time, _value);
    if (onStatusChange != null)
      onStatusChange(AnimationControllerXStatus.startTask, _currentTask);
  }

  void _computeValue(Duration time) {
    final newValue = _currentTask.computeValue(time);
    assert(newValue != null,
        "Value passed from 'computeValue' method must be non null.");
    if (newValue != _value) {
      _updateStatusOnNewValue(_value, newValue);
      _value = newValue;
      notifyListeners();
    }
  }

  void completeCurrentTask() {
    _updateStatusOnTaskComplete();
    if (onStatusChange != null)
      onStatusChange(AnimationControllerXStatus.completeTask, _currentTask);
    _currentTask.dispose();
    _currentTask = null;
  }

  dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  AnimationStatus get status => _status;
  AnimationStatus _status = AnimationStatus.dismissed;

  @override
  double get value => _value;
  double _value = 0.0;

  void addTask(AnimationTask task) {
    _tasks.add(task);
  }

  void addTasks(List<AnimationTask> tasks) {
    tasks.forEach((task) => addTask(task));
  }

  List<AnimationTask> get tasks =>
      [if (_currentTask != null) _currentTask, ..._tasks];

  void stop() {
    reset();
  }

  void forceCompleteCurrentTask() {
    if (_currentTask != null) {
      _currentTask.taskCompleted();
    } else if (_tasks.isNotEmpty) {
      _tasks.removeAt(0);
    }
  }

  void reset([List<AnimationTask> tasksToExecuteAfterReset]) {
    _tasks.clear();
    if (_currentTask != null) {
      _currentTask.dispose();
      _currentTask = null;
    }

    if (tasksToExecuteAfterReset != null) {
      addTasks(tasksToExecuteAfterReset);
    }
  }

  void _updateStatusOnNewValue(double oldValue, newValue) {
    if (_status != AnimationStatus.forward && oldValue < newValue) {
      _status = AnimationStatus.forward;
      notifyStatusListeners(_status);
    }

    if (_status != AnimationStatus.reverse && oldValue > newValue) {
      _status = AnimationStatus.reverse;
      notifyStatusListeners(_status);
    }
  }

  void _updateStatusOnTaskComplete() {
    if (_status != AnimationStatus.completed && _value == 1.0) {
      _status = AnimationStatus.completed;
      notifyStatusListeners(_status);
    }

    if (_status != AnimationStatus.dismissed && _value == 0.0) {
      _status = AnimationStatus.dismissed;
      notifyStatusListeners(_status);
    }
  }
}

enum AnimationControllerXStatus { startTask, completeTask }

typedef StatusChangeCallback = Function(
    AnimationControllerXStatus status, AnimationTask task);