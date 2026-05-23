import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';

void main() {
  testWidgets('AnimationMixin - respects TickerMode enabled changes',
      (WidgetTester tester) async {
    late AnimationController controller;

    Widget animation({required bool enabled}) {
      return MaterialApp(
        home: TickerMode(
          enabled: enabled,
          child: TestWidget((value) => controller = value),
        ),
      );
    }

    await tester.pumpWidget(animation(enabled: true));
    await tester.pump(const Duration(milliseconds: 100));

    expect(controller.toStringDetails(), isNot(contains('silenced')));
    final activeValue = controller.value;

    await tester.pumpWidget(animation(enabled: false));
    await tester.pump(const Duration(milliseconds: 100));

    expect(controller.toStringDetails(), contains('silenced'));
    expect(controller.value, activeValue);

    await tester.pumpWidget(animation(enabled: true));
    await tester.pump(const Duration(milliseconds: 100));

    expect(controller.toStringDetails(), isNot(contains('silenced')));
    expect(controller.value, greaterThan(activeValue));
  });
}

class TestWidget extends StatefulWidget {
  final ValueChanged<AnimationController> exposeController;

  const TestWidget(this.exposeController, {super.key});

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> with AnimationMixin {
  @override
  void initState() {
    widget.exposeController(
      controller..forward(from: 0.0),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
