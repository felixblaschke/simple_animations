import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

/// Plays an animation with a given [tween] and [duration] forward, then
/// backwards, then forward again, and so on.
class MirrorAnimationBuilder<T> extends StatelessWidget {
  const MirrorAnimationBuilder({
    required this.builder,
    required this.tween,
    required this.duration,
    this.curve = Curves.linear,
    this.child,
    this.fps,
    this.developerMode = false,
    super.key,
  });

  /// The [tween] to animate.
  final Animatable<T> tween;

  /// The [duration] of the animation.
  final Duration duration;

  /// Builds the animation frame.
  final ValueWidgetBuilder<T> builder;

  /// A child that's passed into the [builder] function.
  final Widget? child;

  /// The [curve] of the animation. By default it's [Curves.linear].
  final Curve curve;

  /// Limits the framerate of the animation if set.
  final int? fps;

  /// Connects to the closest [AnimationDeveloperTools] in the widget tree.
  final bool developerMode;

  @override
  Widget build(BuildContext context) {
    return CustomAnimationBuilder<T>(
      builder: builder,
      control: Control.mirror,
      tween: tween,
      duration: duration,
      curve: curve,
      fps: fps,
      developerMode: developerMode,
      child: child,
    );
  }
}
