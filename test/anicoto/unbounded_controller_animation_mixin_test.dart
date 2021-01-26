import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

import './widget_tester_extension.dart';

void main() {
  testWidgets('AnimationMixin - Unbounded Controller',
      (WidgetTester tester) async {
    late AnimationController exposedController;
    var animation = MaterialApp(
        home: TestWidget((controller) => exposedController = controller));

    await tester.addAnimationWidget(animation);
    await tester.wait(1.seconds);

    expect(exposedController.upperBound, double.infinity);
    expect(exposedController.lowerBound, -double.infinity);
  });
}

class TestWidget extends StatefulWidget {
  final Function(AnimationController) exposeControllerFn;

  TestWidget(this.exposeControllerFn);

  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> with AnimationMixin {
  @override
  void initState() {
    widget.exposeControllerFn(createController(unbounded: true));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
