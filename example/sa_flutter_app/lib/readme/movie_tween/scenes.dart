// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

MovieTween createTween() {
  // #begin
  final tween = MovieTween();

  // implicit scenes
  final sceneA1 = tween.tween('x', Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 700));

  final sceneA2 = sceneA1.thenTween('x', Tween(begin: 1.0, end: 2.0),
      duration: const Duration(milliseconds: 500));

  // explicit scenes
  final sceneB1 = tween
      .scene(duration: const Duration(milliseconds: 700))
      .tween('x', Tween(begin: 0.0, end: 1.0));

  final sceneB2 = sceneA1
      .thenFor(duration: const Duration(milliseconds: 500))
      .tween('x', Tween(begin: 1.0, end: 2.0));
  // #end

  return tween;
}
