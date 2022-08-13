import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

/// Plays an animation with a given [tween] and [duration] once.
class PlayAnimationBuilder<T> extends StatelessWidget {
  const PlayAnimationBuilder({
    required this.tween,
    required this.duration,
    required this.builder,
    this.delay = Duration.zero,
    this.curve = Curves.linear,
    this.child,
    this.fps,
    this.developerMode = false,
    this.onStarted,
    this.onCompleted,
    Key? key,
  }) : super(key: key);

  /// The [tween] to animate.
  final Animatable<T> tween;

  /// The [duration] of the animation.
  final Duration duration;

  /// Builds the animation frame.
  final ValueWidgetBuilder<T> builder;

  /// The delay before the animation starts.
  final Duration delay;

  /// A child that's passed into the [builder] function.
  final Widget? child;

  /// The [curve] of the animation. By default it's [Curves.linear].
  final Curve curve;

  /// Limits the framerate of the animation if set.
  final int? fps;

  /// Connects to the closest [AnimationDeveloperTools] in the widget tree.
  final bool developerMode;

  /// Called when the animation starts.
  final VoidCallback? onStarted;

  /// Called when the animation completes.
  final VoidCallback? onCompleted;

  @override
  Widget build(BuildContext context) {
    return CustomAnimationBuilder<T>(
      builder: builder,
      tween: tween,
      duration: duration,
      delay: delay,
      curve: curve,
      fps: fps,
      developerMode: developerMode,
      onStarted: onStarted,
      onCompleted: onCompleted,
      child: child,
    );
  }
}
