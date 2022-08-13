import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';

import '../util/widget_tester_extension.dart';

void main() {
  testWidgets('AnimationMixin - FPS Limited Controller',
      (WidgetTester tester) async {
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
  final Function(int) exposeValue;

  const TestWidget(this.exposeValue, {Key? key}) : super(key: key);

  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> with AnimationMixin {
  late Animation<int> a;

  @override
  void initState() {
    a = IntTween(begin: 1000, end: 1100).animate(
        createController(fps: 1)..play(duration: const Duration(days: 100)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.exposeValue(a.value);
    return Container();
  }
}

// because of the frame limiting the test wont compute much
const expectedValues = [1000, 1000];
