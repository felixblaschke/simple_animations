import 'package:simple_animations/simple_animations.dart';

TimelineTween<Prop> createTween() {
  var tween = TimelineTween<Prop>();

  // begin + duration
  // ignore: unused_local_variable
  var scene1 = tween.addScene(
    begin: const Duration(milliseconds: 0),
    duration: const Duration(milliseconds: 700),
  );

  // begin + end
  // ignore: unused_local_variable
  var scene2 = tween.addScene(
    begin: const Duration(milliseconds: 700),
    end: const Duration(milliseconds: 1400),
  );

  // duration + end
  // ignore: unused_local_variable
  var scene3 = tween.addScene(
    duration: const Duration(milliseconds: 600),
    end: const Duration(milliseconds: 300),
  );

  return tween;
}
