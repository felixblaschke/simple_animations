import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void someFunction(AnimationController controller) {
  controller.play(duration: Duration(milliseconds: 1500));
  controller.playReverse(duration: Duration(milliseconds: 1500));
  controller.loop(duration: Duration(milliseconds: 1500));
  controller.mirror(duration: Duration(milliseconds: 1500));
}
