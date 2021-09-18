import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';

import '../../stateless_animation/custom_animation.dart';

import 'factory.dart';

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
class PlasmaRenderer extends StatelessWidget {
  /// Type of plasma animation
  final PlasmaType type;

  /// Method used to render each particle.
  ///
  /// By default renders using [ParticleType.circle].
  ///
  /// See [ParticleType] for details.
  final ParticleType particleType;

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
  final int? fps;

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
  final Widget? child;

  const PlasmaRenderer({
    Key? key,
    this.type = PlasmaType.infinity,
    this.particleType = ParticleType.circle,
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
                        ? CustomAnimationControl.loop
                        : CustomAnimationControl.stop,
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
                          particleType: particleType,
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
            child: child!,
          )
      ],
    );
  }
}

class _PlasmaPainter extends CustomPainter {
  final int particles;
  final PlasmaType type;
  final ParticleType particleType;
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
    required this.type,
    required this.particleType,
    required this.particles,
    required this.value,
    required this.color,
    required this.circleSize,
    required this.blendMode,
    required this.offset,
    required this.blur,
    required this.rotation,
    required this.variation1,
    required this.variation2,
    required this.variation3,
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

    switch (particleType) {
      case ParticleType.circle:
        _drawCircleParticles(canvas, compute, correctionX, correctionY);
        break;
      case ParticleType.atlas:
        _drawAtlasParticles(canvas, compute, correctionX, correctionY);
        break;
    }
  }

  void _drawCircleParticles(Canvas canvas, LiPlasmaCompute compute,
      double correctionX, double correctionY) {
    final paint = Paint()
      ..color = color
      ..blendMode = blendMode;

    for (var n = 0; n < particles; n++) {
      var position = compute.position(n);
      var particleRadius = compute.radius(n);

      if (blur > 0) {
        var blurRadius = (blur * particleRadius * 0.4).roundToDouble();
        if (blurRadius > 0) {
          paint.maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius);
        }
      }

      canvas.drawCircle(
          Offset(
            position.dx - correctionX,
            position.dy - correctionY,
          ),
          particleRadius,
          paint);
    }
  }

  // The resolution of the atlas.
  //
  // The number 100 was picked empirically. It can be adjusted if found to be
  // insufficient, or it can be made customizable. If this number is too big
  // it may impact memory usage and/or performance. It should be as small as
  // possible while still producing reasonably looking results.
  static const double _atlasResolution = 100;

  // If not null, indicates that we started generating an atlas.
  Future<void>? atlasFuture;

  // If not null, the atlas used to render particles.
  //
  // If null, we fallback to drawCircle.
  ui.Image? atlas;

  // Produces an image containing one blurred circle. The image is then used to
  // render all particles using `Canvas.drawAtlas`, which is very fast.
  void _createAtlas() {
    var atlasSize = _atlasResolution;
    var particleRadius = _atlasResolution / 2;
    final paint = Paint()..color = const Color(0xFFFFFFFF);
    if (blur > 0) {
      var blurRadius = (blur * particleRadius * 0.4).roundToDouble();

      // Increase the atlas size to fit the effect of the blur. 2.5x blur on
      // each side seems enough.
      atlasSize = atlasSize + 5 * blurRadius;
      paint.maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius);
    }

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTRB(0, 0, atlasSize, atlasSize));
    canvas.drawCircle(
      Offset(atlasSize / 2, atlasSize / 2),
      particleRadius,
      paint,
    );
    final picture = recorder.endRecording();
    atlasFuture =
        picture.toImage(atlasSize.toInt(), atlasSize.toInt()).then((image) {
      atlas = image;
    });
  }

  void _drawAtlasParticles(Canvas canvas, LiPlasmaCompute compute,
      double correctionX, double correctionY) {
    // If the atlas is not available yet, fallback on drawCircle
    // See: https://github.com/flutter/flutter/issues/77289
    if (atlas == null) {
      // Create an atlas if we're not already creating one.
      if (atlasFuture == null) {
        _createAtlas();
      }
      _drawCircleParticles(canvas, compute, correctionX, correctionY);
      return;
    }

    final paint = Paint()
      ..filterQuality = FilterQuality.medium
      ..blendMode = blendMode;
    final rstTransforms = Float32List(4 * particles);
    final rects = Float32List(4 * particles);
    final colors = Int32List(particles);
    final colorValue = color.value;
    final atlasSize = atlas!.width.toDouble();

    for (var n = 0; n < particles; n++) {
      colors[n] = colorValue;
      final offset = 4 * n;
      rects[offset + 2] = atlasSize;
      rects[offset + 3] = atlasSize;

      final position = compute.position(n);
      final particleRadius = compute.radius(n);
      final scale = 2 * particleRadius / _atlasResolution;
      final center = atlasSize / 2;
      final scos = scale;
      const ssin = 0.0;
      final tx = (position.dx - correctionX) + -scos * center + ssin * center;
      final ty = (position.dy - correctionY) + -ssin * center - scos * center;

      rstTransforms[offset] = scos;
      rstTransforms[offset + 1] = ssin;
      rstTransforms[offset + 2] = tx;
      rstTransforms[offset + 3] = ty;
    }

    canvas.drawRawAtlas(
      atlas!,
      rstTransforms,
      rects,
      colors,
      BlendMode.dstIn,
      null,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _PlasmaPainter oldDelegate) {
    // If the blur hasn't changed we can reuse the atlas from the old painter.
    if (blur == oldDelegate.blur) {
      atlas = oldDelegate.atlas;
      atlasFuture = oldDelegate.atlasFuture;
    }
    if (type != oldDelegate.type ||
        particleType != oldDelegate.particleType ||
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

/// The shape and rendering method used for drawing particles.
enum ParticleType {
  /// Renders particles by calling [Canvas.drawCircle] for each particle.
  ///
  /// This rendering method is visually accurate but computationally more
  /// expensive than [atlas].
  circle,

  /// Renders particles from a prerasterized atlas scaled to the particle size.
  ///
  /// This rendering method is faster than [circle] but it's not visually
  /// accurate. At low blur levels, large particle sizes, and certain
  /// [BlendMode]s it may look different from [circle]. It is therefore not a
  /// drop-in replacement for [circle]. The plasma effect should be
  /// intentionally tuned for the atlas mode.
  ///
  /// The atlas image is regenerated every time the value of
  /// [PlasmaRenderer.blur] changes. If the blur level is being animated, this
  /// method will fallback to [circle] on every frame and therefore not have
  /// any performance benefit.
  ///
  /// Choose this method if:
  ///
  /// * [PlasmaRenderer.blendMode] produces the desired effect with atlases.
  /// * Blur is high enough or particle size is small enough to hide atlas
  ///   pixelation, or if pixelation is not a concern.
  /// * Blur value does not change during the animation.
  atlas,
}
