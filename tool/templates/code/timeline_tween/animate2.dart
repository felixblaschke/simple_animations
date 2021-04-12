import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

TimelineTween<Prop> createTween() {
  var tween = TimelineTween<Prop>();

  var scene = tween.addScene(begin: Duration.zero, end: Duration(seconds: 1));

  scene.animate(
    Prop.width,
    tween: Tween<double>(begin: 0.0, end: 100.0),
    shiftBegin: Duration(milliseconds: 200), // tune begin or
    shiftEnd: Duration(milliseconds: -200), // end timings by shifting them
  );

  return tween;
}
