// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

enum AniProps { width, height, color }

TimelineTween<AniProps> createTween() {
  // (2) create TimelineTween using this enum
  var tween = TimelineTween<AniProps>();

  return tween;
}
