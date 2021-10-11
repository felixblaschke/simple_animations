// ignore_for_file: unused_local_variable
// #begin
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

TimelineTween<Prop> createTween() {
  var tween = TimelineTween<Prop>();

  var firstScene = tween
      .addScene(
        begin: const Duration(seconds: 0),
        duration: const Duration(seconds: 2),
      )
      .animate(Prop.x, tween: ConstantTween<int>(0));

  // secondScene references the firstScene
  var secondScene = firstScene
      .addSubsequentScene(
        delay: const Duration(milliseconds: 200),
        duration: const Duration(seconds: 2),
      )
      .animate(Prop.x, tween: ConstantTween<int>(1));

  return tween;
}
// #end