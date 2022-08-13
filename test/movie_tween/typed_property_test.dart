import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';

final _width = MovieTweenProperty<double>();
final _height = MovieTweenProperty<double>();
final _color = MovieTweenProperty<Color?>();

void main() {
  test('typed properties', () {
    var movie = MovieTween();
    movie
        .scene(
            begin: const Duration(seconds: 0),
            duration: const Duration(seconds: 2))
        .tween<double>(_width, Tween(begin: 100.0, end: 200.0));

    movie
        .scene(
            begin: const Duration(seconds: 1), end: const Duration(seconds: 3))
        .tween(_height, Tween(begin: 200.0, end: 100.0));

    movie
        .scene(
            end: const Duration(seconds: 4),
            duration: const Duration(seconds: 2))
        .tween(
            _color,
            ColorTween(
                begin: const Color(0xFF000000), end: const Color(0xFFFF0000)));

    expect(movie.duration, const Duration(seconds: 4));

    expect(_width.from(movie.transform(0.0 / 4.0)), 100.0);
    expect(_width.from(movie.transform(1.0 / 4.0)), 150.0);
    expect(_width.from(movie.transform(2.0 / 4.0)), 200.0);
    expect(_width.from(movie.transform(2.5 / 4.0)), 200.0);
    expect(_width.from(movie.transform(4.0 / 4.0)), 200.0);

    expect(_height.from(movie.transform(0.0 / 4.0)), 200.0);
    expect(_height.from(movie.transform(1.0 / 4.0)), 200.0);
    expect(_height.from(movie.transform(2.0 / 4.0)), 150.0);
    expect(_height.from(movie.transform(3.0 / 4.0)), 100.0);
    expect(_height.from(movie.transform(4.0 / 4.0)), 100.0);

    expect(_color.from(movie.transform(0.0 / 4.0)), const Color(0xFF000000));
    expect(_color.from(movie.transform(1.0 / 4.0)), const Color(0xFF000000));
    expect(_color.from(movie.transform(2.0 / 4.0)), const Color(0xFF000000));
    expect(_color.from(movie.transform(3.0 / 4.0)), const Color(0xFF7f0000));
    expect(_color.from(movie.transform(4.0 / 4.0)), const Color(0xFFFF0000));
  });
}
