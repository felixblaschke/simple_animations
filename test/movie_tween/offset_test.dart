import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';

void main() {
  test('shift', () {
    var movie = MovieTween();
    movie
        .scene(
            begin: const Duration(seconds: 2), end: const Duration(seconds: 4))
        .tween(
          'width',
          Tween(begin: 100.0, end: 200.0),
          shiftBegin: -const Duration(seconds: 1),
          shiftEnd: const Duration(seconds: 2),
        );

    expect(movie.duration, const Duration(seconds: 6));
    expect(movie.transform(0.0 / 6.0).get<double>('width'), 100.0);
    expect(movie.transform(1.0 / 6.0).get<double>('width'), 100.0);
    expect(movie.transform(2.0 / 6.0).get<double>('width'), 120.0);
    expect(movie.transform(3.0 / 6.0).get<double>('width'), 140.0);
    expect(movie.transform(4.0 / 6.0).get<double>('width'), 160.0);
    expect(movie.transform(5.0 / 6.0).get<double>('width'), 180.0);
    expect(movie.transform(6.0 / 6.0).get<double>('width'), 200.0);
  });
}
