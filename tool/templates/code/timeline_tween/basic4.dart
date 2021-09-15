import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

enum AniProps { width, height, color }

TimelineTween<AniProps> createTween() {
  var tween = TimelineTween<AniProps>();

  var scene = tween.addScene(
    begin: Duration.zero,
    end: const Duration(milliseconds: 700),
  );

  // (4) apply tweens to properties, referenced in enum
  scene.animate(
    AniProps.width,
    tween: Tween<double>(begin: 0.0, end: 100.0),
  );

  scene.animate(
    AniProps.height,
    tween: Tween<double>(begin: 300.0, end: 200.0),
  );

  return tween;
}
