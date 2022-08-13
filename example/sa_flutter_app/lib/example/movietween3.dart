import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Variant with typed properties
    final x = MovieTweenProperty<double>();
    final y = MovieTweenProperty<double>();
    final color = MovieTweenProperty<Color?>();

    // Specify your tween
    final tween = MovieTween()
      ..scene(
              begin: const Duration(seconds: 0),
              duration: const Duration(seconds: 1))
          .tween(x, Tween(begin: -100.0, end: 100.0),
              curve: Curves.easeInOutSine)
          .tween(color, ColorTween(begin: Colors.red, end: Colors.yellow))
      ..scene(
              begin: const Duration(seconds: 1),
              duration: const Duration(seconds: 1))
          .tween(y, Tween(begin: -100.0, end: 100.0),
              curve: Curves.easeInOutSine)
      ..scene(
              begin: const Duration(seconds: 2),
              duration: const Duration(seconds: 1))
          .tween(x, Tween(begin: 100.0, end: -100.0),
              curve: Curves.easeInOutSine)
      ..scene(
              begin: const Duration(seconds: 1),
              end: const Duration(seconds: 3))
          .tween(color, ColorTween(begin: Colors.yellow, end: Colors.blue))
      ..scene(
              begin: const Duration(seconds: 3),
              duration: const Duration(seconds: 1))
          .tween(y, Tween(begin: 100.0, end: -100.0),
              curve: Curves.easeInOutSine)
          .tween(color, ColorTween(begin: Colors.blue, end: Colors.red));

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: LoopAnimationBuilder<Movie>(
            tween: tween, // Pass in tween
            duration: tween.duration, // Obtain duration
            builder: (context, value, child) {
              return Transform.translate(
                // Get animated offset
                offset: Offset(x.from(value), y.from(value)),
                child: Container(
                  width: 100,
                  height: 100,
                  color: color.from(value), // Get animated color
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
