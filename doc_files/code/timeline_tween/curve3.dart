import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

TimelineTween<Prop> createTween() {
  var tween = TimelineTween<Prop>(
    curve: Curves.easeInOut, // apply tween-level curve
  );

  return tween;
}
