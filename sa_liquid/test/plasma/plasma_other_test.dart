import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sa_liquid/plasma/compute/plasma_compute.dart';

void main() {
  test('plasma - offset 1', () {
    final compute = PlasmaCompute(
        canvasSize: Size(100, 100), value: 0, offset: 0, circleSize: 1.0);

    expect(compute.position(0), equals(Offset(50.0, 50.0)));
  });

  test('plasma - offset 2', () {
    final compute = PlasmaCompute(
        canvasSize: Size(100, 100), value: 0, offset: 1.2, circleSize: 1.0);

    expect(compute.position(0).dx, equals(96.6019542983613));
    expect(compute.position(0).dy, equals(96.6019542983613));
  });

  test('plasma - radius 1', () {
    final compute = PlasmaCompute(
        canvasSize: Size(100, 100), value: 0, offset: 1.2, circleSize: 1.0);

    expect(compute.radius(), equals(33.0));
  });

  test('plasma - radius 2', () {
    final compute = PlasmaCompute(
        canvasSize: Size(100, 100), value: 0, offset: 1.2, circleSize: 2.0);

    expect(compute.radius(), equals(67.0));
  });
}
