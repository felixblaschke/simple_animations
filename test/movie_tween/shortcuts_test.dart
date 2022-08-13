import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';

void main() {
  test('shortcut tween() on movie tween', () {
    var movie = MovieTween();
    movie.tween('width', Tween(begin: 100.0, end: 200.0),
        duration: const Duration(seconds: 1));

    expect(movie.duration, const Duration(seconds: 1));
    expect(movie.transform(0.0 / 1.0).get<double>('width'), 100.0);
    expect(movie.transform(0.5 / 1.0).get<double>('width'), 150.0);
    expect(movie.transform(1.0 / 1.0).get<double>('width'), 200.0);
  });

  test('shortcut thenTween() on movie scene', () {
    var movie = MovieTween();
    movie
        .tween('width', Tween(begin: 100.0, end: 200.0),
            duration: const Duration(seconds: 1))
        .thenTween('width', Tween(begin: 200.0, end: 300.0),
            duration: const Duration(seconds: 1));

    expect(movie.duration, const Duration(seconds: 2));
    expect(movie.transform(0.0 / 2.0).get<double>('width'), 100.0);
    expect(movie.transform(0.5 / 2.0).get<double>('width'), 150.0);
    expect(movie.transform(1.0 / 2.0).get<double>('width'), 200.0);
    expect(movie.transform(1.5 / 2.0).get<double>('width'), 250.0);
    expect(movie.transform(2.0 / 2.0).get<double>('width'), 300.0);
  });
}
