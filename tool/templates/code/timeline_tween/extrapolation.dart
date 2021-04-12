import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

TimelineTween<Prop> createTween() => TimelineTween<Prop>()
  ..addScene(begin: 1.seconds, duration: 1.seconds)
      .animate(Prop.width, tween: 100.0.tweenTo(200.0))
  ..addScene(begin: 3.seconds, end: 4.seconds)
      .animate(Prop.height, tween: 400.0.tweenTo(500.0));
