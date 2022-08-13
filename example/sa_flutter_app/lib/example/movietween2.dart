import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Specify your tween
    final tween = MovieTween()
      ..tween('x', Tween(begin: -100.0, end: 100.0),
              duration: const Duration(seconds: 1))
          .thenTween('y', Tween(begin: -100.0, end: 100.0),
              duration: const Duration(seconds: 1))
          .thenTween('x', Tween(begin: 100.0, end: -100.0),
              duration: const Duration(seconds: 1))
          .thenTween('y', Tween(begin: 100.0, end: -100.0),
              duration: const Duration(seconds: 1));

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
                offset: Offset(value.get('x'), value.get('y')),
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.green,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
