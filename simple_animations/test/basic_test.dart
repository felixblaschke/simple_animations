import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sa_liquid/plasma/compute/plasma_compute.dart';
import 'package:simple_animations/simple_animations.dart';

void main() {
  testWidgets('Simple Animations quick test', (WidgetTester tester) async {
    var widget = MaterialApp(home: TestWidget());

    await tester.pumpWidget(widget);
    await tester.pump(Duration(milliseconds: 100));
    await tester.pump(Duration(minutes: 1));
    await tester.pump(Duration(milliseconds: 100));

    expect(find.text('100 200'), findsOneWidget);

    expect(
        PlasmaCompute(
                circleSize: 100,
                canvasSize: Size(100, 100),
                offset: 0.0,
                value: 0.0)
            .radius(),
        equals(3333.0));
  });
}

class TestWidget extends StatefulWidget {
  @override
  _TestWidgetState createState() => _TestWidgetState();
}

enum _AniProps { example }

class _TestWidgetState extends State<TestWidget> with AnimationMixin {
  Animation<MultiTweenValues<_AniProps>> animation;

  @override
  void initState() {
    var tween = MultiTween<_AniProps>()
      ..add(_AniProps.example, IntTween(begin: 0, end: 100));
    animation = tween.animate(controller);
    controller.play();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlayAnimation<int>(
      tween: IntTween(begin: 100, end: 200),
      builder: (context, child, value) {
        return Text('${animation.value.get<int>(_AniProps.example)} ${value}');
      },
    );
  }
}
