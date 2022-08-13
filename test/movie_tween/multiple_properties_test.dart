import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';

void main() {
  test('multi props - simple', () {
    var movie = MovieTween();
    movie
        .scene(
            begin: const Duration(seconds: 0),
            duration: const Duration(seconds: 1))
        .tween('width', Tween(begin: 100.0, end: 200.0))
        .tween('height', Tween(begin: 200.0, end: 100.0))
        .tween(
            'color',
            ColorTween(
                begin: const Color(0xFF000000), end: const Color(0xFFFF0000)));

    expect(movie.duration, const Duration(seconds: 1));

    expect(movie.transform(0.0 / 1.0).get<double>('width'), 100.0);
    expect(movie.transform(0.5 / 1.0).get<double>('width'), 150.0);
    expect(movie.transform(1.0 / 1.0).get<double>('width'), 200.0);

    expect(movie.transform(0.0 / 1.0).get<double>('height'), 200.0);
    expect(movie.transform(0.5 / 1.0).get<double>('height'), 150.0);
    expect(movie.transform(1.0 / 1.0).get<double>('height'), 100.0);

    expect(movie.transform(0.0 / 1.0).get<Color>('color'),
        const Color(0xFF000000));
    expect(movie.transform(0.5 / 1.0).get<Color>('color'),
        const Color(0xFF7f0000));
    expect(movie.transform(1.0 / 1.0).get<Color>('color'),
        const Color(0xFFFF0000));
  });

  test('multi props - cascaded', () {
    var movie = MovieTween();
    movie
        .scene(
            begin: const Duration(seconds: 0),
            duration: const Duration(seconds: 2))
        .tween('width', Tween(begin: 100.0, end: 200.0));

    movie
        .scene(
            begin: const Duration(seconds: 1), end: const Duration(seconds: 3))
        .tween('height', Tween(begin: 200.0, end: 100.0));

    movie
        .scene(
            end: const Duration(seconds: 4),
            duration: const Duration(seconds: 2))
        .tween(
            'color',
            ColorTween(
                begin: const Color(0xFF000000), end: const Color(0xFFFF0000)));

    expect(movie.duration, const Duration(seconds: 4));

    expect(movie.transform(0.0 / 4.0).get<double>('width'), 100.0);
    expect(movie.transform(1.0 / 4.0).get<double>('width'), 150.0);
    expect(movie.transform(2.0 / 4.0).get<double>('width'), 200.0);
    expect(movie.transform(2.5 / 4.0).get<double>('width'), 200.0);
    expect(movie.transform(4.0 / 4.0).get<double>('width'), 200.0);

    expect(movie.transform(0.0 / 4.0).get<double>('height'), 200.0);
    expect(movie.transform(1.0 / 4.0).get<double>('height'), 200.0);
    expect(movie.transform(2.0 / 4.0).get<double>('height'), 150.0);
    expect(movie.transform(3.0 / 4.0).get<double>('height'), 100.0);
    expect(movie.transform(4.0 / 4.0).get<double>('height'), 100.0);

    expect(movie.transform(0.0 / 4.0).get<Color>('color'),
        const Color(0xFF000000));
    expect(movie.transform(1.0 / 4.0).get<Color>('color'),
        const Color(0xFF000000));
    expect(movie.transform(2.0 / 4.0).get<Color>('color'),
        const Color(0xFF000000));
    expect(movie.transform(3.0 / 4.0).get<Color>('color'),
        const Color(0xFF7f0000));
    expect(movie.transform(4.0 / 4.0).get<Color>('color'),
        const Color(0xFFFF0000));
  });
}
