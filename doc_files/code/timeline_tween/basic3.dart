// ignore_for_file: unused_import, unused_local_variable
// #begin
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

enum AniProps { width, height, color }

TimelineTween<AniProps> createTween() {
  var tween = TimelineTween<AniProps>();

  // (3) add a scene to the tween
  var scene = tween.addScene(
    begin: Duration.zero,
    end: const Duration(milliseconds: 700),
  );

  return tween;
}
// #end