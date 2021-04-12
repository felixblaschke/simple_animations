import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

TimelineTween<Prop> createTween() => TimelineTween<Prop>()
  ..addScene(begin: Duration(seconds: 1), duration: Duration(seconds: 1))
      .animate(Prop.width, tween: Tween<double>(begin: 100.0, end: 200.0))
  ..addScene(begin: Duration(seconds: 3), end: Duration(seconds: 4))
      .animate(Prop.height, tween: Tween<double>(begin: 400.0, end: 500.0));
