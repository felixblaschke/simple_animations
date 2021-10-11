import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

TimelineTween<Prop> createTween() => TimelineTween<Prop>()
  ..addScene(
    begin: const Duration(seconds: 1),
    duration: const Duration(seconds: 1),
  ).animate(Prop.width, tween: Tween<double>(begin: 100.0, end: 200.0))
  ..addScene(begin: const Duration(seconds: 3), end: const Duration(seconds: 4))
      .animate(Prop.height, tween: Tween<double>(begin: 400.0, end: 500.0));
