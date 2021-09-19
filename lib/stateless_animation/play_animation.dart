import 'package:flutter/material.dart';
import '../developer_tools/animation_developer_tools.dart';
import 'animated_widget_builder.dart';
import 'custom_animation.dart';

/// Widget that creates and plays an animation until the end.
///
/// You need to specify a [tween] that describes your animation
/// and [builder] function that is called each frame you are
/// animating. This function has signature of [AnimatedWidgetBuilder].
///
/// It's also useful to specify a [duration] (default is 1 second).
///
/// To improve the performance of your animation you should put
/// all widgets that are not effected by the animation into the [child]
/// property. You get that child widget passed into the [builder]
/// function. See also [AnimatedWidgetBuilder].
///
/// If you specify a [delay] the animation will wait for the given
/// duration until it will started animating.
///
/// The [curve] parameter can be used to apply a non-linear animation
/// to your tween.
///
/// The callbacks [onStart] and [onComplete] can be used to track the
/// start and end of an animation.
///
/// You can optionally limit the framerate (fps) of the animation by
/// setting the [fps] value.
///
/// If you work with multiple animation widgets that are conditionally
/// rendered, you might want to set a [key]. Otherwise Flutter will
/// recycled your "old animation" which results in strange behavior.
///
/// You can connect this widget to the closest [AnimationDeveloperTools]
/// by setting [developerMode] to `true`.
class PlayAnimation<T> extends StatelessWidget {
  final AnimatedWidgetBuilder<T> builder;
  final Widget? child;
  final Duration duration;
  final Duration delay;
  final Animatable<T> tween;
  final Curve curve;
  final int? fps;
  final bool developerMode;
  final VoidCallback? onStart;
  final VoidCallback? onComplete;

  /// Creates a new PlayAnimation widget.
  /// See class documentation for more information.
  const PlayAnimation({
    required this.builder,
    required this.tween,
    this.duration = const Duration(seconds: 1),
    this.delay = Duration.zero,
    this.curve = Curves.linear,
    this.child,
    this.fps,
    this.developerMode = false,
    this.onStart,
    this.onComplete,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomAnimation<T>(
      builder: builder,
      tween: tween,
      duration: duration,
      delay: delay,
      curve: curve,
      fps: fps,
      developerMode: developerMode,
      child: child,
      onStart: onStart,
      onComplete: onComplete,
    );
  }
}
