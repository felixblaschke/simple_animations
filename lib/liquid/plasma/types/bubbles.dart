import 'dart:math';

import 'package:flutter/material.dart';
import '../plasma.dart';

class LiBubblesPlasmaCompute extends LiPlasmaCompute {
  final Size canvasSize;
  final double circleSize;
  final double offset;
  final double value;
  final double variation1;
  final double variation2;
  final double variation3;

  LiBubblesPlasmaCompute({
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
    var rand = sin(n / pi).abs() % (2 * pi);
    var rvalue = (value + offset + rand * 100) % (2 * pi);

    final progress = (3 * rvalue / (2 * pi)) % 1.0;

    final fromX = 1.2 * sin(n) * (1 - variation3) + variation3 * 1.2 * cos(n);
    final toX = 1.2 * cos(n);

    var fromY = 1 + 2 * circleSize;
    var toY = -1 - 2 * circleSize;

    var x = (fromX * (1 - progress) + toX * progress) * canvasSize.width / 2;
    var y = (fromY * (1 - progress) + toY * progress) * canvasSize.height / 2;

    return Offset(
      canvasSize.width / 2 + x,
      canvasSize.height / 2 + y,
    );
  }

  @override
  double radius(int n) {
    var rand = sin(n / 0.1).abs();
    var rvalue = (rand * 2 * pi) % (2 * pi);
    final scale = ((1 - variation1) * 0.7) +
        (pow(10, variation2)) * 0.6 * (rvalue / (2 * pi));

    return scale *
        (circleSize * max(canvasSize.width, canvasSize.height) / 2 / 3)
            .roundToDouble();
  }
}
