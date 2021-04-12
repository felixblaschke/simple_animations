import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

// ignore: unused_element
TimelineTween<Prop> _createComplexTween() {
  var tween = TimelineTween<Prop>();

  var fadeIn = tween.addScene(begin: 0.seconds, duration: 300.milliseconds)
      .animate(Prop.x, tween: 0.0.tweenTo(100.0))
      .animate(Prop.y, tween: 0.0.tweenTo(100.0));

  var grow = fadeIn.addSubsequentScene(duration: 700.milliseconds)
      .animate(Prop.x, tween: 100.0.tweenTo(200.0))
      .animate(Prop.y, tween: 100.0.tweenTo(200.0));

  // ignore: unused_local_variable
  var fadeOut = grow.addSubsequentScene(duration: 300.milliseconds)
      .animate(Prop.x, tween: 200.0.tweenTo(0.0))
      .animate(Prop.y, tween: 200.0.tweenTo(0.0));

  return tween;
}

