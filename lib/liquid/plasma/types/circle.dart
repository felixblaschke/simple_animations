import 'dart:math';

import 'package:flutter/material.dart';
import '../plasma.dart';

class LiCirclePlasmaCompute extends LiPlasmaCompute {
  final Size canvasSize;
  final double circleSize;
  final double offset;
  final double value;
  final int particles;
  final double variation1;
  final double variation2;
  final double variation3;

  LiCirclePlasmaCompute({
    required this.canvasSize,
    required this.circleSize,
    required this.offset,
    required this.value,
    required this.particles,
    required this.variation1,
    required this.variation2,
    required this.variation3,
  });

  @override
  Offset position(int n) {
    var nProgress = n / particles * pi * 2;

    var px = (1 - variation1) *
        sin(nProgress +
            value +
            offset +
            nProgress * sin(variation3 * nProgress));
    var py = (1 - variation2) *
        cos(nProgress +
            value +
            offset +
            nProgress * sin(variation3 * nProgress));

    var x = px * canvasSize.width / 2;
    var y = py * canvasSize.height / 2;

    return Offset(
      canvasSize.width / 2 + x,
      canvasSize.height / 2 + y,
    );
  }

  @override
  double radius(int n) {
    var rand = sin(n / 0.1).abs();
    var rvalue = (rand * 2 * pi) % (2 * pi);
    final scale = 0.7 + 0.6 * (rvalue / (2 * pi));

    return scale *
        (circleSize * max(canvasSize.width, canvasSize.height) / 2 / 3)
            .roundToDouble();
  }
}
