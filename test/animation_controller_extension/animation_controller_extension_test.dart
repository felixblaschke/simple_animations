import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';

import '../util/widget_tester_extension.dart';

void main() {
  testWidgets('AnimationControllerExtension', (WidgetTester tester) async {
    var values = <int>[];
    var animation = MaterialApp(home: TestWidget(values.add));

    await tester.addAnimationWidget(animation);

    for (var i = 0; i < 200; i++) {
      await tester.wait(const Duration(days: 1));
    }

    expect(values, expectedValues);
  });
}

class TestWidget extends StatefulWidget {
  final Function(int value) exposeValue;

  const TestWidget(this.exposeValue, {Key? key}) : super(key: key);

  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> with AnimationMixin {
  late Animation<int> a;

  @override
  void initState() {
    a = IntTween(begin: 0, end: 10).animate(controller);
    play();
    super.initState();
  }

  void play() async {
    await controller.play(duration: const Duration(days: 10));
    await controller.playReverse(duration: const Duration(days: 10));

    unawaited(controller.loop(duration: const Duration(days: 10)));
    await Future<void>.delayed(const Duration(days: 20));

    unawaited(controller.mirror(duration: const Duration(days: 10)));
    await Future<void>.delayed(const Duration(days: 20));

    controller.stop();
  }

  @override
  Widget build(BuildContext context) {
    widget.exposeValue(a.value);
    return Container();
  }
}

const expectedValues = <int>[
  0,
  0,
  1,
  1,
  2,
  2,
  3,
  3,
  4,
  4,
  5,
  5,
  6,
  6,
  7,
  7,
  8,
  8,
  9,
  9,
  10,
  10,
  9,
  9,
  8,
  8,
  7,
  7,
  6,
  6,
  5,
  5,
  4,
  4,
  3,
  3,
  2,
  2,
  1,
  1,
  0,
  0,
  1,
  1,
  2,
  2,
  3,
  3,
  4,
  4,
  5,
  5,
  6,
  6,
  7,
  7,
  8,
  8,
  9,
  9,
  0,
  0,
  1,
  1,
  2,
  2,
  3,
  3,
  4,
  4,
  5,
  5,
  6,
  6,
  7,
  7,
  8,
  8,
  9,
  9,
  9,
  9,
  10,
  10,
  9,
  9,
  8,
  8,
  7,
  7,
  6,
  6,
  5,
  5,
  4,
  4,
  3,
  3,
  2,
  2,
  1,
  1,
  0,
  0,
  1,
  1,
  2,
  2,
  3,
  3,
  4,
  4,
  5,
  5,
  6,
  6,
  7,
  7,
  8,
  8
];
