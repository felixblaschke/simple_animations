import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Specify your tween
    final MovieTween tween = MovieTween()
      ..scene(
              begin: const Duration(milliseconds: 0),
              end: const Duration(milliseconds: 1000))
          .tween('width', Tween(begin: 0.0, end: 100.0))
      ..scene(
              begin: const Duration(milliseconds: 1000),
              end: const Duration(milliseconds: 1500))
          .tween('width', Tween(begin: 100.0, end: 200.0))
      ..scene(
              begin: const Duration(milliseconds: 0),
              duration: const Duration(milliseconds: 2500))
          .tween('height', Tween(begin: 0.0, end: 200.0))
      ..scene(
              begin: const Duration(milliseconds: 0),
              duration: const Duration(milliseconds: 3000))
          .tween('color', ColorTween(begin: Colors.red, end: Colors.blue));

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: PlayAnimationBuilder<Movie>(
            tween: tween, // Pass in tween
            duration: tween.duration, // Obtain duration
            builder: (context, value, child) {
              return Container(
                width: value.get('width'), // Get animated values
                height: value.get('height'),
                color: value.get('color'),
              );
            },
          ),
        ),
      ),
    );
  }
}
