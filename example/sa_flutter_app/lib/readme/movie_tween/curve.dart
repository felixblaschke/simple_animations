import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

MovieTween createTween() {
  // #begin
  final tween = MovieTween(curve: Curves.easeIn);

  // scene1 will use Curves.easeIn defined by the MovieTween
  final scene1 = tween.scene(duration: const Duration(seconds: 1));

  // scene2 will use Curves.easeOut
  final scene2 =
      tween.scene(duration: const Duration(seconds: 1), curve: Curves.easeOut);

  // will use Curves.easeIn defined by the MovieTween
  scene1.tween('value1', Tween(begin: 0.0, end: 100.0));

  // will use Curves.easeOut defined by scene2
  scene2.tween('value2', Tween(begin: 0.0, end: 100.0));

  // will use Curves.easeInOut defined by property tween
  scene2.tween('value3', Tween(begin: 0.0, end: 100.0),
      curve: Curves.easeInOut);
  // #end
  return tween;
}
