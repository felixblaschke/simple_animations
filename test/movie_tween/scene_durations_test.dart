import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';

void main() {
  test('scene durations - begin and duration', () {
    var movie = MovieTween();
    movie.scene(
        begin: const Duration(seconds: 1),
        duration: const Duration(seconds: 1));
    expect(movie.duration, const Duration(seconds: 2));
  });

  test('scene durations - begin and end', () {
    var movie = MovieTween();
    movie.scene(
        begin: const Duration(seconds: 1), end: const Duration(seconds: 2));
    expect(movie.duration, const Duration(seconds: 2));
  });

  test('scene durations - duration and end', () {
    var movie = MovieTween();
    movie.scene(
        duration: const Duration(seconds: 2), end: const Duration(seconds: 4));
    expect(movie.duration, const Duration(seconds: 4));
  });

  test('scene durations - only duration', () {
    var movie = MovieTween();
    movie.scene(duration: const Duration(seconds: 2));
    expect(movie.duration, const Duration(seconds: 2));
  });

  test('scene durations - failures', () {
    expect(
        () => MovieTween().scene(
            begin: const Duration(seconds: 2), end: const Duration(seconds: 0)),
        throwsAssertionError);
    expect(
        () => MovieTween().scene(
            begin: const Duration(seconds: 2),
            duration: -const Duration(seconds: 1)),
        throwsAssertionError);
    expect(
        () => MovieTween().scene(
            begin: -const Duration(seconds: 1),
            duration: const Duration(seconds: 2)),
        throwsAssertionError);
  });
}
