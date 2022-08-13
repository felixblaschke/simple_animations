// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void _createTween() {
  // #begin
  MovieTween()

      /// fade in
      .scene(
        begin: const Duration(seconds: 0),
        duration: const Duration(milliseconds: 300),
      )
      .tween('x', Tween<double>(begin: 0.0, end: 100.0))
      .tween('y', Tween<double>(begin: 0.0, end: 200.0))

      /// grow
      .thenFor(duration: const Duration(milliseconds: 700))
      .tween('x', Tween<double>(begin: 100.0, end: 200.0))
      .tween('y', Tween<double>(begin: 200.0, end: 400.0))

      /// fade out
      .thenFor(duration: const Duration(milliseconds: 300))
      .tween('x', Tween<double>(begin: 200.0, end: 0.0))
      .tween('y', Tween<double>(begin: 400.0, end: 0.0));
  // #end
}
