import 'dart:async';

import 'package:flutter/material.dart';

import 'animated_widget_builder.dart';
import '../developer_tools/animation_developer_tools.dart';
import '../anicoto/animation_controller_extension.dart';
import '../anicoto/animation_mixin.dart';

/// Set of instruction you can pass into a [CustomAnimation.control].
enum CustomAnimationControl {
  /// Stops the animation at the current position.
  stop,

  /// Plays the animation from the current position to the end.
  play,

  /// Plays the animation from the current position reverse to the start.
  playReverse,

  /// Reset the position of the animation to `0.0` and starts playing
  /// to the end.
  playFromStart,

  /// Reset the position of the animation to `1.0` and starts playing
  /// reverse to the start.
  playReverseFromEnd,

  /// Endlessly plays the animation from the start to the end.
  /// Make sure to utilize [CustomAnimation.child] since a permanent
  /// animation eats up performance.
  loop,

  /// Endlessly plays the animation from the start to the end, then
  /// it plays reverse to the start, then forward again and so on.
  /// Make sure to utilize [CustomAnimation.child] since a permanent
  /// animation eats up performance.
  mirror,
}

/// Widget that creates a customized animation.
///
/// You need to specify a [tween] that describes your animation
/// and [builder] function that is called each frame you are
/// animating. This function has signature of [AnimatedWidgetBuilder].
///
/// It's also useful to specify a [duration] (default is 1 second).
///
/// You can modify the internal `AnimationController` by setting the
/// [control] property to any value of [CustomAnimationControl).
/// By default it starts playing the animation.
///
/// Nice to know: both [duration] and [control] can be modified at any
/// time while using it inside a stateful widget.
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
/// If you want to start your animation at alternative position, you
/// can set a [startPosition] that takes values between `0.0` (start)
/// and `1.0` (end).
///
/// You can optionally limit the framerate (fps) of the animation by
/// setting the [fps] value.
///
/// You can provide an [animationStatusListener] that gets called by
/// the internal `AnimationController`. It's receives events of the
/// type [AnimationStatus].
///
/// If you work with multiple animation widgets that are conditionally
/// rendered, you might want to set a [key]. Otherwise Flutter will
/// recycled your "old animation" which results in strange behavior.
///
/// You can connect this widget to the closest [AnimationDeveloperTools]
/// by setting [developerMode] to `true`.
class CustomAnimation<T> extends StatefulWidget {
  final Animatable<T> tween;
  final AnimatedWidgetBuilder<T> builder;
  final CustomAnimationControl control;
  final Curve curve;
  final Duration duration;
  final Duration delay;
  final Widget? child;
  final AnimationStatusListener? animationStatusListener;
  final double startPosition;
  final int? fps;
  final bool developerMode;
  final VoidCallback? onStart;
  final VoidCallback? onComplete;

  /// Creates a new CustomAnimation widget.
  /// See class documentation for more information.
  const CustomAnimation({
    required this.builder,
    required this.tween,
    this.control = CustomAnimationControl.play,
    this.curve = Curves.linear,
    this.duration = const Duration(seconds: 1),
    this.delay = Duration.zero,
    this.startPosition = 0.0,
    this.child,
    this.animationStatusListener,
    this.fps,
    this.developerMode = false,
    this.onStart,
    this.onComplete,
    Key? key,
  })  : assert(startPosition >= 0 && startPosition <= 1,
            'The property startPosition must have a value between 0.0 and 1.0.'),
        super(key: key);

  @override
  _CustomAnimationState<T> createState() => _CustomAnimationState<T>();
}

class _CustomAnimationState<T> extends State<CustomAnimation<T>>
    with AnimationMixin {
  late AnimationController aniController;
  late Animation<T> _animation;
  var _isDisposed = false;
  var _waitForDelay = true;
  var _isControlSetToMirror = false;
  var _isPlaying = false;

  @override
  void initState() {
    aniController = createController(fps: widget.fps);
    aniController.value = widget.startPosition;
    aniController.duration = widget.duration;

    _buildAnimation();

    aniController.addStatusListener(_onAnimationStatus);

    asyncInitState();
    super.initState();
  }

  void _buildAnimation() {
    _animation = widget.tween
        .chain(CurveTween(curve: widget.curve))
        .animate(aniController);

    if (widget.developerMode) {
      var transfer =
          context.findAncestorWidgetOfExactType<AnimationControllerTransfer>();
      assert(transfer != null,
          'Please place an AnimationDeveloperTools widget inside the widget tree');
      transfer?.controllerProvider(aniController);
    }
  }

  void asyncInitState() async {
    if (widget.delay != Duration.zero && !widget.developerMode) {
      await Future<void>.delayed(widget.delay);
    }
    _waitForDelay = false;
    _applyControlInstruction();
  }

  @override
  void didUpdateWidget(CustomAnimation<T> oldWidget) {
    aniController.duration = widget.duration;
    _buildAnimation();
    _applyControlInstruction();
    super.didUpdateWidget(oldWidget);
  }

  void _applyControlInstruction() async {
    if (_isDisposed || _waitForDelay || widget.developerMode) {
      return;
    }

    if (widget.control == CustomAnimationControl.stop) {
      _trackPlaybackComplete();
      aniController.stop();
    }
    if (widget.control == CustomAnimationControl.play) {
      unawaited(aniController.play());
    }
    if (widget.control == CustomAnimationControl.playReverse) {
      unawaited(aniController.playReverse());
    }
    if (widget.control == CustomAnimationControl.playFromStart) {
      unawaited(aniController.forward(from: 0.0));
    }
    if (widget.control == CustomAnimationControl.playReverseFromEnd) {
      unawaited(aniController.reverse(from: 1.0));
    }
    if (widget.control == CustomAnimationControl.loop) {
      unawaited(aniController.loop());
    }
    if ((widget.control == CustomAnimationControl.mirror) &&
        !_isControlSetToMirror) {
      _isControlSetToMirror = true;
      unawaited(aniController.mirror());
    }

    if (widget.control != CustomAnimationControl.mirror) {
      _isControlSetToMirror = false;
    }
  }

  void _onAnimationStatus(AnimationStatus status) {
    widget.animationStatusListener?.call(status);

    if (status == AnimationStatus.forward ||
        status == AnimationStatus.reverse) {
      _trackPlaybackStart();
    } else if (status == AnimationStatus.dismissed ||
        status == AnimationStatus.completed) {
      _trackPlaybackComplete();
    }
  }

  void _trackPlaybackStart() {
    if (!_isPlaying) {
      _isPlaying = true;
      widget.onStart?.call();
    }
  }

  void _trackPlaybackComplete() {
    if (_isPlaying) {
      _isPlaying = false;
      widget.onComplete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.child, _animation.value);
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
