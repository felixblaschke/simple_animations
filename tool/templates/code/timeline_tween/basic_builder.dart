import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

enum AniProps { width, height, color }

TimelineTween<AniProps> createTween() => TimelineTween<AniProps>()
  ..addScene(begin: 0.milliseconds, end: 700.milliseconds)
      .animate(AniProps.width, tween: 0.0.tweenTo(100.0))
      .animate(AniProps.height, tween: 300.0.tweenTo(200.0));
