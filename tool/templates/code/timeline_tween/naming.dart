import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

// ignore: unused_element
TimelineTween<Prop> _createComplexTween() {
  var tween = TimelineTween<Prop>();

  var fadeIn = tween
      .addScene(
        begin: const Duration(seconds: 0),
        duration: const Duration(milliseconds: 300),
      )
      .animate(Prop.x, tween: Tween<double>(begin: 0.0, end: 100.0))
      .animate(Prop.y, tween: Tween<double>(begin: 0.0, end: 100.0));

  var grow = fadeIn
      .addSubsequentScene(duration: const Duration(milliseconds: 700))
      .animate(Prop.x, tween: Tween<double>(begin: 100.0, end: 200.0))
      .animate(Prop.y, tween: Tween<double>(begin: 100.0, end: 200.0));

  // ignore: unused_local_variable
  var fadeOut = grow
      .addSubsequentScene(duration: const Duration(milliseconds: 300))
      .animate(Prop.x, tween: Tween<double>(begin: 200.0, end: 0.0))
      .animate(Prop.y, tween: Tween<double>(begin: 200.0, end: 0.0));

  return tween;
}
