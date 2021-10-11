import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class MyAnimatedWidget extends StatefulWidget {
  const MyAnimatedWidget({Key? key}) : super(key: key);

  @override
  _MyAnimatedWidgetState createState() => _MyAnimatedWidgetState();
}

class _MyAnimatedWidgetState extends State<MyAnimatedWidget>
    with AnimationMixin {
  late AnimationController widthController;
  late AnimationController heightController;
  late AnimationController colorController;

  late Animation<double> width;
  late Animation<double> height;
  late Animation<Color?> color;

  @override
  void initState() {
    widthController = createController()
      ..mirror(duration: const Duration(seconds: 5));
    heightController = createController()
      ..mirror(duration: const Duration(seconds: 3));
    colorController = createController()
      ..mirror(duration: const Duration(milliseconds: 1500));

    width = Tween<double>(begin: 100.0, end: 200.0).animate(widthController);
    height = Tween<double>(begin: 100.0, end: 200.0).animate(heightController);
    color = ColorTween(begin: Colors.red, end: Colors.blue)
        .animate(colorController);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width.value, height: height.value, color: color.value);
  }
}
