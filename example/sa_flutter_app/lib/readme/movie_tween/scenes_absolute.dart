// ignore_for_file: unused_local_variable
import 'package:simple_animations/simple_animations.dart';

MovieTween createTween() {
  // #begin
  final tween = MovieTween();

  // start at 0ms and end at 1500ms
  final scene1 = tween.scene(
    duration: const Duration(milliseconds: 1500),
  );

  // start at 200ms and end at 900ms
  final scene2 = tween.scene(
    begin: const Duration(milliseconds: 200),
    duration: const Duration(milliseconds: 700),
  );

  // start at 700ms and end at 1400ms
  final scene3 = tween.scene(
    begin: const Duration(milliseconds: 700),
    end: const Duration(milliseconds: 1400),
  );

  // start at 1000ms and end at 1600ms
  final scene4 = tween.scene(
    duration: const Duration(milliseconds: 600),
    end: const Duration(milliseconds: 1600),
  );
  // #end
  return tween;
}
