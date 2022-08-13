import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

MovieTween createTween() {
  // #begin
  final tween = MovieTween();
  final scene = tween.scene(end: const Duration(seconds: 1));

  scene.tween('width', Tween(begin: 0.0, end: 100.0));
  scene.tween('color', ColorTween(begin: Colors.red, end: Colors.blue));
  // #end

  return tween;
}
