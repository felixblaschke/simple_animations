import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';

void main() {
  test('basic timeline', () {
    var movie = MovieTween();
    movie
        .scene(
            begin: const Duration(seconds: 0),
            duration: const Duration(seconds: 1))
        .tween('width', Tween(begin: 100.0, end: 200.0));

    expect(movie.duration, const Duration(seconds: 1));
    expect(movie.transform(0.0 / 1.0).get<double>('width'), 100.0);
    expect(movie.transform(0.5 / 1.0).get<double>('width'), 150.0);
    expect(movie.transform(1.0 / 1.0).get<double>('width'), 200.0);
  });

  test('delayed timeline', () {
    var movie = MovieTween();
    movie
        .scene(
            begin: const Duration(seconds: 1),
            duration: const Duration(seconds: 1))
        .tween('width', Tween(begin: 100.0, end: 200.0));

    expect(movie.duration, const Duration(seconds: 2));
    expect(movie.transform(0.0 / 2.0).get<double>('width'), 100.0);
    expect(movie.transform(0.5 / 2.0).get<double>('width'), 100.0);
    expect(movie.transform(1.0 / 2.0).get<double>('width'), 100.0);
    expect(movie.transform(1.5 / 2.0).get<double>('width'), 150.0);
    expect(movie.transform(2.0 / 2.0).get<double>('width'), 200.0);
  });

  test('extrapolating after scene', () {
    var movie = MovieTween();
    movie
        .scene(
            begin: const Duration(seconds: 1),
            duration: const Duration(seconds: 1))
        .tween('width', Tween(begin: 100.0, end: 200.0))
        .thenFor(duration: const Duration(seconds: 1));

    expect(movie.duration, const Duration(seconds: 3));
    expect(movie.transform(1.5 / 3.0).get<double>('width'), 150.0);
    expect(movie.transform(2.0 / 3.0).get<double>('width'), 200.0);
    expect(movie.transform(2.5 / 3.0).get<double>('width'), 200.0);
    expect(movie.transform(3.0 / 3.0).get<double>('width'), 200.0);
  });

  test('multiple scenes', () {
    var movie = MovieTween();
    movie
        .scene(
            begin: const Duration(seconds: 1), end: const Duration(seconds: 2))
        .tween('width', Tween(begin: 100.0, end: 200.0));

    movie
        .scene(
            begin: const Duration(seconds: 3), end: const Duration(seconds: 4))
        .tween('width', Tween(begin: 300.0, end: 400.0));

    movie.scene(
        end: const Duration(seconds: 5), duration: const Duration(seconds: 0));

    expect(movie.duration, const Duration(seconds: 5));
    expect(movie.transform(0.0 / 5.0).get<double>('width'), 100.0);
    expect(movie.transform(1.0 / 5.0).get<double>('width'), 100.0);
    expect(movie.transform(1.5 / 5.0).get<double>('width'), 150.0);
    expect(movie.transform(2.0 / 5.0).get<double>('width'), 200.0);
    expect(movie.transform(2.5 / 5.0).get<double>('width'), 200.0);
    expect(movie.transform(2.95 / 5.0).get<double>('width'), 200.0);
    expect(movie.transform(3.0 / 5.0).get<double>('width'), 300.0);
    expect(movie.transform(3.5 / 5.0).get<double>('width'), 350.0);
    expect(movie.transform(4.0 / 5.0).get<double>('width'), 400.0);
    expect(movie.transform(4.5 / 5.0).get<double>('width'), 400.0);
    expect(movie.transform(5.0 / 5.0).get<double>('width'), 400.0);
  });

  test('multiple scenes with addSubsequentScene', () {
    var movie = MovieTween();
    var first = movie
        .scene(
            begin: const Duration(seconds: 1), end: const Duration(seconds: 2))
        .tween('width', Tween(begin: 100.0, end: 200.0));

    first
        .thenFor(
            delay: const Duration(seconds: 1),
            duration: const Duration(seconds: 1))
        .tween('width', Tween(begin: 300.0, end: 400.0));

    movie.scene(
        end: const Duration(seconds: 5), duration: const Duration(seconds: 0));

    expect(movie.duration, const Duration(seconds: 5));
    expect(movie.transform(0.0 / 5.0).get<double>('width'), 100.0);
    expect(movie.transform(1.0 / 5.0).get<double>('width'), 100.0);
    expect(movie.transform(1.5 / 5.0).get<double>('width'), 150.0);
    expect(movie.transform(2.0 / 5.0).get<double>('width'), 200.0);
    expect(movie.transform(2.5 / 5.0).get<double>('width'), 200.0);
    expect(movie.transform(2.95 / 5.0).get<double>('width'), 200.0);
    expect(movie.transform(3.0 / 5.0).get<double>('width'), 300.0);
    expect(movie.transform(3.5 / 5.0).get<double>('width'), 350.0);
    expect(movie.transform(4.0 / 5.0).get<double>('width'), 400.0);
    expect(movie.transform(4.5 / 5.0).get<double>('width'), 400.0);
    expect(movie.transform(5.0 / 5.0).get<double>('width'), 400.0);
  });
}
