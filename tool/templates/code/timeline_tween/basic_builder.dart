import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

enum AniProps { width, height, color }

TimelineTween<AniProps> createTween() => TimelineTween<AniProps>()
  ..addScene(begin: Duration.zero, end: const Duration(milliseconds: 700))
      .animate(AniProps.width, tween: Tween<double>(begin: 0.0, end: 100.0))
      .animate(AniProps.height, tween: Tween<double>(begin: 300.0, end: 200.0));
