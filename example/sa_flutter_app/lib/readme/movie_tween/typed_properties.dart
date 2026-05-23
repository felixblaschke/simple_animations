// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void createTween() {
  // #begin
  final width = MovieTweenProperty<double>();
  final color = MovieTweenProperty<Color?>();

  final tween = MovieTween()
    ..tween<double>(width, Tween(begin: 0.0, end: 100.0))
    ..tween<Color?>(color, ColorTween(begin: Colors.red, end: Colors.blue));

  final movie = tween.transform(0.5);

  final currentWidth = width.from(movie); // type: double
  final currentColor = color.from(movie); // type: Color?
  // #end
}
