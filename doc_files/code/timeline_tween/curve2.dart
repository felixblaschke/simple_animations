// ignore_for_file: unused_local_variable
// #begin
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

TimelineTween<Prop> createTween() {
  var tween = TimelineTween<Prop>();

  var scene = tween.addScene(
    begin: Duration.zero,
    end: const Duration(seconds: 1),
    curve: Curves.easeInOut, // apply scene-level curve
  );

  return tween;
}
// #end