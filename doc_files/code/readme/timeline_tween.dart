import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

// define animated properties
enum AniProps { width, height, color }

// design tween by composing scenes
final tween = TimelineTween<AniProps>()
  ..addScene(
          begin: const Duration(milliseconds: 0),
          duration: const Duration(milliseconds: 500))
      .animate(AniProps.width, tween: Tween<double>(begin: 0.0, end: 400.0))
      .animate(AniProps.height, tween: Tween<double>(begin: 500.0, end: 200.0))
      .animate(AniProps.color,
          tween: ColorTween(begin: Colors.red, end: Colors.yellow))
  ..addScene(
          begin: const Duration(milliseconds: 700),
          end: const Duration(milliseconds: 1200))
      .animate(AniProps.width, tween: Tween<double>(begin: 400.0, end: 500.0));
