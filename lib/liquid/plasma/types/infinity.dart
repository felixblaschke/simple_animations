import 'dart:math';

import 'package:flutter/material.dart';
import '../plasma.dart';

class LiInfinityPlasmaCompute extends LiPlasmaCompute {
  final Size canvasSize;
  final double circleSize;
  final double offset;
  final double value;
  final double variation1;
  final double variation2;
  final double variation3;

  LiInfinityPlasmaCompute({
    required this.canvasSize,
    required this.circleSize,
    required this.offset,
    required this.value,
    required this.variation1,
    required this.variation2,
    required this.variation3,
  });

  @override
  Offset position(int n) {
    var rand = sin(n + variation2).abs();
    var rvalue = (value + rand * 2 * pi) % (2 * pi);

    var x =
        (1 - variation3) * sin(-rand + rvalue + offset) * canvasSize.width / 2;
    var y = sin(rand + -2 * rvalue + offset) * canvasSize.height / 2;

    return Offset(
      canvasSize.width / 2 + x,
      canvasSize.height / 2 + y,
    );
  }

  @override
  double radius(int n) {
    var rand = sin(n / 0.1).abs();
    var rvalue = (rand * 2 * pi) % (2 * pi);
    final scale =
        (1 - variation1) + variation1 * (0.1 + 0.9 * (rvalue / (2 * pi)));

    return scale *
        (circleSize * (canvasSize.width + canvasSize.height) / 2 / 3)
            .roundToDouble();
  }
}
