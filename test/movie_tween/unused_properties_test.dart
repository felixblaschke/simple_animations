import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';

void main() {
  test('unused properties', () {
    var movie = MovieTween();
    movie.scene(
        begin: const Duration(seconds: 0),
        duration: const Duration(seconds: 1));

    expect(
        () => movie.transform(0.0).get<double>('width'), throwsAssertionError);
  });
}
