import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);

  // #begin
  @override
  Widget build(BuildContext context) {
    // create tween
    var tween = MovieTween()
      ..scene(duration: const Duration(milliseconds: 700))
          .tween('width', Tween<double>(begin: 0.0, end: 100.0))
          .tween('height', Tween<double>(begin: 300.0, end: 200.0));

    return PlayAnimationBuilder<Movie>(
      tween: tween, // provide tween
      duration: tween.duration, // total duration obtained from MovieTween
      builder: (context, value, _) {
        return Container(
          width: value.get('width'), // get animated width value
          height: value.get('height'), // get animated height value
          color: Colors.yellow,
        );
      },
    );
  }
  // #end
}
