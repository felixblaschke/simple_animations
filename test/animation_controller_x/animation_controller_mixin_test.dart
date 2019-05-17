import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:simple_animations/simple_animations/animation_controller_x/animation_controller_x.dart';

main() {
  testWidgets("Mixin test", (WidgetTester tester) async {
    AnimationControllerX controller;
    final widget = MixinTestWidget((c) => controller = c);

    await tester.pumpWidget(widget);
    await tester.pump(Duration(milliseconds: 100));

    expect(controller != null, true);
    expect(controller.tasks.length, 1);
    expect(controller.tasks[0].toString(),
        "FromToAnimationTask(from: null, to: 1.0, duration: 0:00:01.000000, curve: _Linear)(startedTime: 0:00:00.100000, startedValue: 0.0)");
  });
}

class MixinTestWidget extends StatefulWidget {
  final Function(AnimationControllerX) upliftController;

  MixinTestWidget(this.upliftController);

  @override
  _MixinTestWidgetState createState() => _MixinTestWidgetState();
}

class _MixinTestWidgetState extends State<MixinTestWidget>
    with AnimationControllerMixin {
  @override
  void initState() {
    widget.upliftController(controller);
    controller.addTask(FromToTask(duration: Duration(seconds: 1), to: 1.0));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
