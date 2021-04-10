import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

// define animated properties
enum AniProps { width, height, color }

// design tween by composing scenes
final tween = TimelineTween<AniProps>()
  ..addScene(begin: 0.milliseconds, duration: 500.milliseconds)
      .animate(AniProps.width, tween: 0.0.tweenTo(400.0))
      .animate(AniProps.height, tween: 500.0.tweenTo(200.0))
      .animate(AniProps.color, tween: Colors.red.tweenTo(Colors.yellow))
  ..addScene(begin: 700.milliseconds, end: 1200.milliseconds)
      .animate(AniProps.width, tween: 400.0.tweenTo(500.0));
