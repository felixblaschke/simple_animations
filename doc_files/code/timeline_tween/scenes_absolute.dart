// ignore_for_file: unused_local_variable
// #begin
import 'package:simple_animations/simple_animations.dart';

TimelineTween<Prop> createTween() {
  var tween = TimelineTween<Prop>();

  // begin + duration
  var scene1 = tween.addScene(
    begin: const Duration(milliseconds: 0),
    duration: const Duration(milliseconds: 700),
  );

  // begin + end
  var scene2 = tween.addScene(
    begin: const Duration(milliseconds: 700),
    end: const Duration(milliseconds: 1400),
  );

  // duration + end
  var scene3 = tween.addScene(
    duration: const Duration(milliseconds: 600),
    end: const Duration(milliseconds: 300),
  );

  return tween;
}
// #end