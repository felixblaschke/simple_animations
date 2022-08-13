// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

MovieTween createTween() {
  // #begin
  final tween = MovieTween();

  final firstScene = tween
      .scene(
        begin: const Duration(seconds: 0),
        duration: const Duration(seconds: 2),
      )
      .tween('x', ConstantTween<int>(0));

  // secondScene references the firstScene
  final secondScene = firstScene
      .thenFor(
        delay: const Duration(milliseconds: 200),
        duration: const Duration(seconds: 2),
      )
      .tween('x', ConstantTween<int>(1));
  // #end
  return tween;
}
