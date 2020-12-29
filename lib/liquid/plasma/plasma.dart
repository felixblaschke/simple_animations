part of simple_animations;

/// Plasma creates an animation with moving particles that generates a
/// smooth liquid effect. It can be configured in many styles.
///
/// You can also use a non-animating variant by setting [speed] to `0.0`
/// and find a good looking position with the [offset].
///
/// Example:
/// ```dart
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
class PlasmaRenderer extends StatelessWidget {
  /// Type of plasma animation
  final PlasmaType type;

  /// Number of particles to simulate. Has impact on computation demand.
  final int particles;

  /// Color of the animating particles
  final Color color;

  /// Describes how the color merges.
  final BlendMode blendMode;

  /// Size scale of the animating particles. Has slight impact on computation
  /// demand.
  final double size;

  /// Speed scale of the animation. You can set it to `0.0` that disable the
  /// animation. Disabled animations doesn't require computational demand at all.
  final double speed;

  /// If set, the animation will reduce the framerate (fps) to the specified
  /// value.
  final int fps;

  /// Influences the start position of the particle animation.
  final double offset;

  /// Rotation of the animation in radians
  final double rotation;

  /// Blur scale of the particle.
  final double blur;

  /// Number influencing the rendering of certain Plasma types.
  final double variation1;

  /// Number influencing the rendering of certain Plasma types.
  final double variation2;

  /// Number influencing the rendering of certain Plasma types.
  final double variation3;

  /// Child that's placed inside this [Widget].
  final Widget child;

  PlasmaRenderer({
    Key key,
    this.type = PlasmaType.infinity,
    this.particles = 10,
    this.color = Colors.white,
    this.size = 1.0,
    this.speed = 1.0,
    this.offset = 0.0,
    this.fps,
    this.blendMode = BlendMode.srcOver,
    this.blur = 1.0,
    this.variation1 = 0.0,
    this.variation2 = 0.0,
    this.variation3 = 0.0,
    this.rotation = 0.0,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 0.01),
            // workaround for https://github.com/felixblaschke/simple_animations/issues/45
            child: ClipRect(
              clipBehavior: Clip.hardEdge,
              child: Transform.rotate(
                angle: rotation,
                child: CustomAnimation<double>(
                    key: Key('plasma_$fps'),
                    control: speed > 0
                        ? CustomAnimationControl.LOOP
                        : CustomAnimationControl.STOP,
                    tween: 0.0.tweenTo(2 * pi),
                    fps: fps,
                    duration: speed > 0
                        ? (120000.0 / speed).round().milliseconds
                        : 1.seconds,
                    builder: (context, _, value) {
                      return CustomPaint(
                        painter: _PlasmaPainter(
                          particles: particles,
                          value: value,
                          color: color,
                          circleSize: size,
                          blendMode: blendMode,
                          offset: offset,
                          blur: blur,
                          type: type,
                          rotation: rotation,
                          variation1: variation1,
                          variation2: variation2,
                          variation3: variation3,
                        ),
                      );
                    }),
              ),
            ),
          ),
        ),
        if (child != null)
          Positioned.fill(
            child: child,
          )
      ],
    );
  }
}

class _PlasmaPainter extends CustomPainter {
  final int particles;
  final PlasmaType type;
  final double value;
  final Color color;
  final double circleSize;
  final BlendMode blendMode;
  final double offset;
  final double blur;
  final double rotation;
  final double variation1;
  final double variation2;
  final double variation3;

  _PlasmaPainter({
    this.type,
    this.particles,
    this.value,
    this.color,
    this.circleSize,
    this.blendMode,
    this.offset,
    this.blur,
    this.rotation,
    this.variation1,
    this.variation2,
    this.variation3,
  });

  @override
  void paint(Canvas canvas, Size canvasSize) {
    var size = Size(
      max(canvasSize.width, canvasSize.height),
      max(canvasSize.width, canvasSize.height),
    );

    var correctionX = (size.width - canvasSize.width) / 2;
    var correctionY = (size.height - canvasSize.height) / 2;

    var compute = LiPlasmaComputeFactory.create(
      particles: particles,
      type: type,
      circleSize: circleSize,
      offset: offset,
      canvasSize: size,
      value: value,
      blur: blur,
      variation1: variation1,
      variation2: variation2,
      variation3: variation3,
    );

    0.until(particles).forEach((n) {
      var position = compute.position(n);
      var particleRadius = compute.radius(n);

      final paint = Paint()
        ..color = color
        ..blendMode = blendMode;

      if (blur > 0) {
        var blurRadius = (blur * particleRadius * 0.4).roundToDouble();
        paint.maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius);
      }

      canvas.drawCircle(
          Offset(
            position.dx - correctionX,
            position.dy - correctionY,
          ),
          particleRadius,
          paint);
    });
  }

  @override
  bool shouldRepaint(covariant _PlasmaPainter oldDelegate) {
    if (type != oldDelegate.type ||
        particles != oldDelegate.particles ||
        value != oldDelegate.value ||
        color != oldDelegate.color ||
        circleSize != oldDelegate.circleSize ||
        blendMode != oldDelegate.blendMode ||
        offset != oldDelegate.offset ||
        blur != oldDelegate.blur ||
        rotation != oldDelegate.rotation ||
        variation1 != oldDelegate.variation1 ||
        variation2 != oldDelegate.variation2 ||
        variation3 != oldDelegate.variation3) {
      return true;
    }
    return false;
  }
}

abstract class LiPlasmaCompute {
  Offset position(int n);

  double radius(int n);
}

enum PlasmaType { infinity, bubbles, circle }
