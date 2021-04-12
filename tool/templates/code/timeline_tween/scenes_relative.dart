import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

TimelineTween<Prop> createTween() {
  var tween = TimelineTween<Prop>();

  var firstScene = tween
      .addScene(
        begin: Duration(seconds: 0),
        duration: Duration(seconds: 2),
      )
      .animate(Prop.x, tween: ConstantTween<int>(0));

  // secondScene references the firstScene
  // ignore: unused_local_variable
  var secondScene = firstScene
      .addSubsequentScene(
        delay: Duration(milliseconds: 200),
        duration: Duration(seconds: 2),
      )
      .animate(Prop.x, tween: ConstantTween<int>(1));

  return tween;
}
