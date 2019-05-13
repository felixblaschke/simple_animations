import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:simple_animations/simple_animations/animation_controller_x.dart';

main() {
  testWidgets("Basics", (WidgetTester tester) async {
    AnimationControllerX controller;
    final widget = AnimationControllerXTestWidget((c) => controller = c);

    await tester.pumpWidget(widget);
    await tester.pump(Duration(milliseconds: 100));

    expect(controller != null, true);
    expect(controller.value, 0.0);

    var newTask = SetValueAnimationTask(value: 0.5);
    controller.addTask(newTask);
    expect(controller.tasks, [newTask]);

    await tester.pump(Duration(milliseconds: 100));
    expect(controller.value, 0.5);
  });

  testWidgets("Stop", (WidgetTester tester) async {
    AnimationControllerX controller;
    final widget = AnimationControllerXTestWidget((c) => controller = c);

    await tester.pumpWidget(widget);
    await tester.pump(Duration(milliseconds: 100));

    controller.addTask(
        LoopAnimationTask(duration: Duration(seconds: 1), from: 0.0, to: 1.0));
    await tester.pump(Duration(milliseconds: 100));

    await tester.pump(Duration(milliseconds: 500));
    expect(controller.value, 0.5);
    expect(controller.tasks.length, 1);

    controller.stop();
    await tester.pump(Duration(milliseconds: 100));
    expect(controller.value, 0.5);
    expect(controller.tasks.length, 0);
  });

  testWidgets("Reset", (WidgetTester tester) async {
    AnimationControllerX controller;
    final widget = AnimationControllerXTestWidget((c) => controller = c);

    await tester.pumpWidget(widget);
    await tester.pump(Duration(milliseconds: 100));

    controller.addTask(
        LoopAnimationTask(duration: Duration(seconds: 1), from: 0.0, to: 1.0));
    await tester.pump(Duration(milliseconds: 100));
    expect(controller.tasks.length, 1);

    controller.reset([SetValueAnimationTask(value: 0.7)]);
    await tester.pump(Duration(milliseconds: 100));
    expect(controller.value, 0.7);
  });

  testWidgets("Force complete task", (WidgetTester tester) async {
    AnimationControllerX controller;
    final widget = AnimationControllerXTestWidget((c) => controller = c);

    await tester.pumpWidget(widget);
    await tester.pump(Duration(milliseconds: 100));

    final tasks = Iterable.generate(3)
        .map((_) => LoopAnimationTask(
            duration: Duration(seconds: 1), from: 0.0, to: 1.0))
        .toList();
    controller.addTasks(tasks);
    await tester.pump(Duration(milliseconds: 100));

    await tester.pump(Duration(seconds: 100));
    expect(controller.tasks.length, 3);

    controller.forceCompleteCurrentTask();
    await tester.pump(Duration(seconds: 100));
    expect(controller.tasks.length, 2);

    controller.forceCompleteCurrentTask();
    controller.forceCompleteCurrentTask();
    await tester.pump(Duration(seconds: 100));
    expect(controller.tasks.length, 0);
  });

  testWidgets("Status listener", (WidgetTester tester) async {
    AnimationControllerX controller;
    final widget = AnimationControllerXTestWidget((c) => controller = c);

    List<AnimationStatus> statusListener = [];
    List<AnimationControllerXStatus> aniXStatus = [];
    List<AnimationTask> aniXTask = [];

    await tester.pumpWidget(widget);

    controller.addStatusListener(statusListener.add);
    controller.onStatusChange = (status, task) {
      aniXStatus.add(status);
      aniXTask.add(task);
    };

    await tester.pump(Duration(milliseconds: 100));

    expect(controller.status, AnimationStatus.dismissed);
    expect(statusListener.length, 0);
    expect(aniXStatus.length, 0);
    expect(aniXTask.length, 0);

    final taskFw = FromToAnimationTask(
        duration: Duration(seconds: 10), from: 0.0, to: 1.0);
    controller.addTask(taskFw);
    await tester.pump(Duration(milliseconds: 100));
    await tester.pump(Duration(milliseconds: 100));

    expect(controller.status, AnimationStatus.forward);
    expect(statusListener, [AnimationStatus.forward]);
    expect(aniXStatus, [AnimationControllerXStatus.startTask]);
    expect(aniXTask, [taskFw]);

    await tester.pump(Duration(seconds: 10));
    expect(controller.status, AnimationStatus.completed);
    expect(
        statusListener, [AnimationStatus.forward, AnimationStatus.completed]);
    expect(aniXStatus, [
      AnimationControllerXStatus.startTask,
      AnimationControllerXStatus.completeTask
    ]);
    expect(aniXTask, [taskFw, taskFw]);

    final taskRv = FromToAnimationTask(
        duration: Duration(seconds: 10), from: 1.0, to: 0.0);
    controller.addTask(taskRv);
    await tester.pump(Duration(milliseconds: 100));
    await tester.pump(Duration(milliseconds: 100));

    expect(controller.status, AnimationStatus.reverse);
    expect(statusListener, [
      AnimationStatus.forward,
      AnimationStatus.completed,
      AnimationStatus.reverse
    ]);
    expect(aniXStatus, [
      AnimationControllerXStatus.startTask,
      AnimationControllerXStatus.completeTask,
      AnimationControllerXStatus.startTask,
    ]);
    expect(aniXTask, [taskFw, taskFw, taskRv]);

    await tester.pump(Duration(seconds: 10));
    expect(controller.status, AnimationStatus.dismissed);
    expect(statusListener, [
      AnimationStatus.forward,
      AnimationStatus.completed,
      AnimationStatus.reverse,
      AnimationStatus.dismissed,
    ]);
    expect(aniXStatus, [
      AnimationControllerXStatus.startTask,
      AnimationControllerXStatus.completeTask,
      AnimationControllerXStatus.startTask,
      AnimationControllerXStatus.completeTask,
    ]);
    expect(aniXTask, [taskFw, taskFw, taskRv, taskRv]);
  });
}

class AnimationControllerXTestWidget extends StatefulWidget {
  final Function(AnimationControllerX) upliftController;
  AnimationControllerXTestWidget(this.upliftController);

  @override
  _AnimationControllerXTestWidgetState createState() =>
      _AnimationControllerXTestWidgetState();
}

class _AnimationControllerXTestWidgetState
    extends State<AnimationControllerXTestWidget>
    with SingleTickerProviderStateMixin {
  AnimationControllerX controller;

  @override
  void initState() {
    controller = AnimationControllerX(vsync: this);
    widget.upliftController(controller);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
