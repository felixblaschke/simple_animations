import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

MovieTween createTween() {
  // #begin
  final tween = MovieTween()

    // implicitly use 100.0 for width values from 0.0s - 1.0s

    // 1.0s - 2.0s
    ..scene(
      begin: const Duration(seconds: 1),
      duration: const Duration(seconds: 1),
    ).tween('width', Tween<double>(begin: 100.0, end: 200.0))

    // implicitly use 200.0 for width values from 2.0s - 3.0s

    // 3.0s - 4.0s
    ..scene(
      begin: const Duration(seconds: 3),
      end: const Duration(seconds: 4),
    ).tween('height', Tween<double>(begin: 400.0, end: 500.0));
  // #end
  return tween;
}
