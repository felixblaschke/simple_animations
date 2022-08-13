import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';

void main() {
  test('curve on scene', () {
    var movie = MovieTween();
    movie
        .scene(
            begin: const Duration(seconds: 0),
            duration: const Duration(seconds: 1),
            curve: Curves.easeOut)
        .tween('width', Tween(begin: 100.0, end: 200.0));

    expect(movie.duration, const Duration(seconds: 1));
    expect(movie.transform(0.0 / 1.0).get<double>('width').round(), 100);
    expect(movie.transform(0.5 / 1.0).get<double>('width').round(), 168);
    expect(movie.transform(1.0 / 1.0).get<double>('width').round(), 200);
  });

  test('curve on item overrides scene', () {
    var movie = MovieTween();
    movie
        .scene(
            begin: const Duration(seconds: 0),
            duration: const Duration(seconds: 1),
            curve: Curves.easeOut)
        .tween('width', Tween(begin: 100.0, end: 200.0), curve: Curves.linear)
        .tween('height', Tween(begin: 100.0, end: 200.0));

    expect(movie.duration, const Duration(seconds: 1));
    expect(movie.transform(0.0 / 1.0).get<double>('width'), 100.0);
    expect(movie.transform(0.25 / 1.0).get<double>('width'), 125.0);
    expect(movie.transform(0.5 / 1.0).get<double>('width'), 150.0);
    expect(movie.transform(0.75 / 1.0).get<double>('width'), 175.0);
    expect(movie.transform(1.0 / 1.0).get<double>('width'), 200.0);

    expect(movie.transform(0.0 / 1.0).get<double>('height').round(), 100);
    expect(movie.transform(0.25 / 1.0).get<double>('height').round(), 138);
    expect(movie.transform(0.5 / 1.0).get<double>('height').round(), 168);
    expect(movie.transform(0.75 / 1.0).get<double>('height').round(), 191);
    expect(movie.transform(1.0 / 1.0).get<double>('height').round(), 200);
  });

  test('default curve on movie tween', () {
    var movie = MovieTween();
    movie
        .scene(
            begin: const Duration(seconds: 0),
            duration: const Duration(seconds: 1),
            curve: Curves.easeOut)
        .tween('width', Tween(begin: 100.0, end: 200.0));

    expect(movie.duration, const Duration(seconds: 1));
    expect(movie.transform(0.0 / 1.0).get<double>('width').round(), 100);
    expect(movie.transform(0.5 / 1.0).get<double>('width').round(), 168);
    expect(movie.transform(1.0 / 1.0).get<double>('width').round(), 200);
  });
}
