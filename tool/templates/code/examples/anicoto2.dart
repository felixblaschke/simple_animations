import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

void main() => runApp(const MaterialApp(home: Page()));

class Page extends StatelessWidget {
  const Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: Center(child: MyAnimatedWidget())),
    );
  }
}

class MyAnimatedWidget extends StatefulWidget {
  const MyAnimatedWidget({Key? key}) : super(key: key);

  @override
  _MyAnimatedWidgetState createState() => _MyAnimatedWidgetState();
}

class _MyAnimatedWidgetState extends State<MyAnimatedWidget>
    with AnimationMixin {
  // declare AnimationControllers
  late AnimationController widthController;
  late AnimationController heightController;
  late AnimationController colorController;

  // declare Animation variables
  late Animation<double> width;
  late Animation<double> height;
  late Animation<Color?> color;

  @override
  void initState() {
    // create controller instance and let it mirror animate
    widthController = createController()..mirror(duration: 5.seconds);
    heightController = createController()..mirror(duration: 3.seconds);
    colorController = createController()..mirror(duration: 1500.milliseconds);

    // connect tween with individual controller
    width = 100.0.tweenTo(200.0).animatedBy(widthController);
    height = 100.0.tweenTo(200.0).animatedBy(heightController);
    color = Colors.red.tweenTo(Colors.blue).animatedBy(colorController);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.value, //  use animated values
      height: height.value,
      color: color.value,
    );
  }
}
