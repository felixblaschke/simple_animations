import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';

void main() {
  test('plasma - offset 1', () {
    final compute = InternalPlasmaCompute(
        canvasSize: Size(100, 100), value: 0, offset: 0, circleSize: 1.0);

    expect(compute.position(0), equals(Offset(50.0, 50.0)));
  });

  test('plasma - offset 2', () {
    final compute = InternalPlasmaCompute(
        canvasSize: Size(100, 100), value: 0, offset: 1.2, circleSize: 1.0);

    expect(compute.position(0).dx.toStringAsFixed(5), equals('96.60195'));
    expect(compute.position(0).dy.toStringAsFixed(5), equals('96.60195'));
  });

  test('plasma - radius 1', () {
    final compute = InternalPlasmaCompute(
        canvasSize: Size(100, 100), value: 0, offset: 1.2, circleSize: 1.0);

    expect(compute.radius(), equals(33.0));
  });

  test('plasma - radius 2', () {
    final compute = InternalPlasmaCompute(
        canvasSize: Size(100, 100), value: 0, offset: 1.2, circleSize: 2.0);

    expect(compute.radius(), equals(67.0));
  });
}
