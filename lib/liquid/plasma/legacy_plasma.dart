import 'dart:math';

import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';
import '../../stateless_animation/custom_animation.dart';

/// Plasma creates an animation with moving particles that generates a
/// smooth liquid effect. It can be configured in many styles.
///
/// You can also use a non-animating variant by setting [speed] to `0.0`
/// and find a good looking position with the [offset].
///
/// Example:
/// ```dart
/// import 'dart:math';
/// import 'package:flutter/material.dart';
/// import 'package:simple_animations/simple_animations.dart';
///
/// void main() => runApp(MaterialApp(home: Page()));
///
/// class Page extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: Plasma(
///         particles: 10,
///         foregroundColor: Color(0xd61e0000),
///         backgroundColor: Color(0xffee360d),
///         size: 0.87,
///         speed: 5.92,
///         offset: 0.00,
///         blendMode: BlendMode.darken,
///         child: Center(child: Text("Hot!")), // your UI here
///       ),
///     );
///   }
/// }
///
/// ```
@Deprecated(
    'Migrate to PlasmaRenderer by recreating your scene via Liquid Studio. Create a "Solid Color" layer with the background color. Then add a "Plasma Layer" using the foreground colors. All other properties can be just copied.')
class Plasma extends StatelessWidget {
  /// Number of particles to simulate. Has impact on computation demand.
  final int particles;

  /// Color of the animating particles
  final Color foregroundColor;

  /// Color of the static background
  final Color backgroundColor;

  /// The [BlendMode] that describes how foreground and background merges
  /// together.
  final BlendMode blendMode;

  /// Size scale of the animating particles. Has slight impact on computation
  /// demand.
  final double size;

  /// Speed scale of the animation. You can set it to `0.0` that disable the
  /// animation. Disabled animations doesn't require computational demand at all.
  final double speed;

  /// If set, the animation will reduce the framerate (fps) to the specified
  /// value.
  final int? fps;

  /// Influences the start position of the particle animation.
  final double offset;

  /// Prebuild child that's placed inside the Plasma [Widget].
  final Widget? child;

  const Plasma({
    Key? key,
    this.particles = 10,
    this.foregroundColor = Colors.white,
    this.backgroundColor = Colors.black,
    this.size = 1.0,
    this.speed = 1.0,
    this.offset = 0.0,
    this.fps,
    this.blendMode = BlendMode.srcOver,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.01),
      // workaround for https://github.com/felixblaschke/simple_animations/issues/45
      child: ClipRect(
        clipBehavior: Clip.hardEdge,
        child: CustomAnimation<double>(
          control: speed > 0
              ? CustomAnimationControl.LOOP
              : CustomAnimationControl.STOP,
          tween: 0.0.tweenTo(2 * pi),
          fps: fps,
          duration:
              speed > 0 ? (120000.0 / speed).round().milliseconds : 1.seconds,
          builder: (context, animatedChild, value) {
            return Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    foregroundPainter: _LegacyPlasmaPainter(
                      particles: particles,
                      value: value,
                      color: foregroundColor,
                      circleSize: size,
                      blendMode: blendMode,
                      offset: offset,
                    ),
                    child: Container(
                      color: backgroundColor,
                    ),
                  ),
                ),
                if (animatedChild != null)
                  Positioned.fill(
                    child: animatedChild,
                  )
              ],
            );
          },
          child: child,
        ),
      ),
    );
  }
}

class _LegacyPlasmaPainter extends CustomPainter {
  final int particles;
  final double value;
  final Color color;
  final double circleSize;
  final BlendMode blendMode;
  final double offset;

  _LegacyPlasmaPainter({
    required this.particles,
    required this.value,
    required this.color,
    required this.circleSize,
    required this.blendMode,
    required this.offset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var compute = LegacyInternalPlasmaCompute(
        circleSize: circleSize, offset: offset, canvasSize: size, value: value);

    var paint = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, compute.blurRadius())
      ..blendMode = blendMode;

    0.until(particles).forEach((n) {
      canvas.drawCircle(compute.position(n), compute.radius(), paint);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

/// Class that computes position of the particles based on [canvasSize],
/// [circleSize], [offset] and [value].
class LegacyInternalPlasmaCompute {
  final Size canvasSize;
  final double circleSize;
  final double offset;
  final double value;

  final double _radius;

  LegacyInternalPlasmaCompute({
    required this.canvasSize,
    required this.circleSize,
    required this.offset,
    required this.value,
  }) : _radius = (circleSize * (canvasSize.width + canvasSize.height) / 2 / 3)
            .roundToDouble();

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
