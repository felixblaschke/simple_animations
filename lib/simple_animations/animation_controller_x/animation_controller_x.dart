import 'package:flutter/animation.dart';
import 'package:flutter/scheduler.dart';

import 'package:simple_animations/simple_animations.dart';

/// An powerful implementation of Flutter's [AnimationController] that will work with
/// an [AnimationTask] queue to execute complex custom animations easily.
///
/// You can use [addTask], [addTasks] or [reset] to configure it with tasks.
/// Common used tasks are [FromToTask], [LoopTask], [SetValueTask] or [ConditionalTask].
/// You can create your own tasks by extending the abstract class [AnimationTask].
///
/// ```dart
/// // AnimationController (original implementation)
/// controller.forward();
///
/// // AnimationControllerX (this implementation)
/// controller.addTask(FromToTask(to: 1.0));
/// ```
///
/// You can add multiple tasks to it's internal queue. It will process / animate
/// each one by one. The [tasks] getter lets you read the task list.
///
/// Tween handling is the same like doing it with an [AnimationController]:
/// ```dart
/// width = Tween(begin: 100.0, end: 200.0).animate(controller);
/// ```
///
/// Use [reset] or [stop] to cancel the current animation.
///
/// You can call [forceCompleteCurrentTask] to just complete the currently
/// executed task. It will continue with the next one (if defined).
///
/// It's possible to track the task processing by attaching an [onStatusChange]
/// listener. But keep in mind that [AnimationTask] also has listener to track
/// start and complete status.
class AnimationControllerX extends Animation<double>
    with
        AnimationEagerListenerMixin,
        AnimationLocalListenersMixin,
        AnimationLocalStatusListenersMixin {
  Ticker _ticker;
  StatusChangeCallback onStatusChange;

  AnimationTask _currentTask;
  List<AnimationTask> _tasks = [];

  AnimationControllerX({TickerProvider vsync, this.onStatusChange}) {
    if (vsync != null) {
      configureVsync(vsync);
    }
  }

  /// Configures controller to a [TickerProvider].
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

  /// Appends a new task to the execution queue.
  void addTask(AnimationTask task) {
    _tasks.add(task);
  }

  /// Appends multiple tasks to the execution queue.
  void addTasks(List<AnimationTask> tasks) {
    tasks.forEach((task) => addTask(task));
  }

  /// Returns a copy of the internal task queue.
  List<AnimationTask> get tasks =>
      [if (_currentTask != null) _currentTask, ..._tasks];

  /// Stops and clears the task queue.
  void stop() {
    reset();
  }

  /// Completes the currently executing task. If the queue has remaining tasks
  /// it will continue to process the next task.
  void forceCompleteCurrentTask() {
    if (_currentTask != null) {
      _currentTask.completeTask();
    } else if (_tasks.isNotEmpty) {
      _tasks.removeAt(0);
    }
  }

  /// Clears the current task queue and (optionally) continues to process
  /// tasks provided by the [tasksToExecuteAfterReset] parameter.
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

  void _updateStatusOnNewValue(double oldValue, double newValue) {
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

/// Type of status event of [AnimationControllerX].
enum AnimationControllerXStatus {
  /// Tasks started to process
  startTask,

  /// Tasks completed it's processing
  completeTask
}

typedef StatusChangeCallback = void Function(
    AnimationControllerXStatus status, AnimationTask task);
