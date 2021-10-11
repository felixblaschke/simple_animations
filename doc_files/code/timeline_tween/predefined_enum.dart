import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

TimelineTween<Prop> createTween() => TimelineTween<Prop>()
  ..addScene(begin: Duration.zero, end: const Duration(milliseconds: 700))
      .animate(Prop.x, tween: ConstantTween<double>(0.0))
      .animate(Prop.y, tween: ConstantTween<double>(0.0))
      .animate(Prop.width, tween: ConstantTween<double>(0.0))
      .animate(Prop.height, tween: ConstantTween<double>(0.0))
      .animate(Prop.color, tween: ConstantTween<Color?>(Colors.red))
      .animate(Prop.translateX, tween: ConstantTween<double>(0.0))
      .animate(Prop.translateY, tween: ConstantTween<double>(0.0))
      .animate(Prop.rotateZ,
          tween: ConstantTween<double>(0.0)); // and many more...
