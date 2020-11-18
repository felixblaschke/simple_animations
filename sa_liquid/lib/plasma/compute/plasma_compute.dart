import 'dart:math';

import 'package:flutter/material.dart';

/// Class that computes position of the particles based on [canvasSize],
/// [circleSize], [offset] and [value].
class PlasmaCompute {
  final Size canvasSize;
  final double circleSize;
  final double offset;
  final double value;

  double _radius;

  PlasmaCompute({this.canvasSize, this.circleSize, this.offset, this.value}) {
    _radius = (circleSize * (canvasSize.width + canvasSize.height) / 2 / 3)
        .roundToDouble();
  }

  Offset position(int particleNumber) {
    var rand = sin(particleNumber).abs();
    var rvalue = (value + rand * 2 * pi) % (2 * pi);

    var x = sin(-rand + rvalue + offset) * canvasSize.width / 2;
    var y = sin(rand + -2 * rvalue + offset) * canvasSize.height / 2;

    return Offset(canvasSize.width / 2 + x, canvasSize.height / 2 + y);
  }

  double radius() => _radius;

  double blurRadius() => (_radius * 1.2).roundToDouble();
}
