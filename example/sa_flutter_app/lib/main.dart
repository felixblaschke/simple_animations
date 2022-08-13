import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() {
  runApp(const MaterialApp(home: Scaffold(body: MyPage())));
}

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MovieTweenProperty<double>();

    final movieTween = MovieTween()
      ..tween<double>(width, Tween(begin: 100.0, end: 200.0),
              duration: const Duration(seconds: 2))
          .thenTween(width, Tween(begin: 200.0, end: 500.0),
              duration: const Duration(seconds: 1));

    return Center(
        child: PlayAnimationBuilder<Movie>(
            tween: movieTween,
            duration: movieTween.duration,
            builder: (context, movie, _) {
              return Container(
                width: width.from(movie),
                height: 200.0,
                color: Colors.red,
              );
            }));
  }
}
