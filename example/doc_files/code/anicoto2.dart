import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

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
    // create controller instances and use mirror animation behavior
    widthController = createController()
      ..mirror(duration: const Duration(seconds: 5));
    heightController = createController()
      ..mirror(duration: const Duration(seconds: 3));
    colorController = createController()
      ..mirror(duration: const Duration(milliseconds: 1500));

    // connect tween with individual controllers
    width = Tween(begin: 100.0, end: 200.0).animate(widthController);
    height = Tween(begin: 100.0, end: 200.0).animate(heightController);
    color = ColorTween(begin: Colors.red, end: Colors.blue)
        .animate(colorController);

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
