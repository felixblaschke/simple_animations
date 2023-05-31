import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

/// Instruction for the [CustomAnimationBuilder]
enum Control {
  /// Stops the animation at the current position.
  stop,

  /// Plays the animation from the current position to the end.
  play,

  /// Plays the animation from the current position reverse to the start.
  playReverse,

  /// Resets the animation position to the beginning (`0.0`) and starts playing
  /// to the end.
  playFromStart,

  /// Resets the position of the animation to end (`1.0`) and starts playing
  /// backwards to the start.
  playReverseFromEnd,

  /// Endlessly plays the animation from the start to the end.
  loop,

  /// Endlessly plays the animation from the start to the end, then
  /// it plays reverse to the start, then forward again and so on.
  mirror,
}

/// A builder that plays a custom animation with a given [tween] and [duration].
/// It can be controlled with [control].
class CustomAnimationBuilder<T> extends StatefulWidget {
  const CustomAnimationBuilder({
    required this.builder,
    required this.tween,
    required this.duration,
    this.control = Control.play,
    this.curve = Curves.linear,
    this.delay = Duration.zero,
    this.startPosition = 0.0,
    this.child,
    this.animationStatusListener,
    this.fps,
    this.developerMode = false,
    this.onStarted,
    this.onCompleted,
    Key? key,
  })  : assert(startPosition >= 0 && startPosition <= 1,
            'The property startPosition must have a value between 0.0 and 1.0.'),
        super(key: key);

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

  /// Current execution command of the animation.
  final Control control;

  /// The relative position where the animation starts.
  /// The value must be between 0.0 and 1.0, where 0.0 is the beginning of the
  /// animation and 1.0 is the end of the animation.
  final double startPosition;

  /// Exposed [AnimationStatusListener] from the internal [AnimationController].
  final AnimationStatusListener? animationStatusListener;

  @override
  _CustomAnimationBuilderState<T> createState() =>
      _CustomAnimationBuilderState<T>();
}

class _CustomAnimationBuilderState<T> extends State<CustomAnimationBuilder<T>>
    with AnimationMixin {
  /// The [AnimationController] that controls the animation.
  late AnimationController _controller;

  /// The [Animation] that is driven by the [AnimationController].
  late Animation<T> _animation;

  /// Delay timer that is used to delay the execution of the control instruction.
  Timer? _delayTimer;

  /// Tracks if the mirror command is sent to the controller. This is used to
  /// prevent the animation from being mirror again, if the widget is rebuilt.
  var _isControlSetToMirror = false;

  /// Tracks if the animation is currently playing. This is used to properly
  /// send the [onStarted] and [onCompleted] callbacks.
  var _isPlaying = false;

  @override
  void initState() {
    /// Create the [AnimationController] instance
    _controller = createController(fps: widget.fps);
    _controller.value = widget.startPosition;
    _controller.duration = widget.duration;

    /// Connects tween with the [AnimationController].
    _buildAnimation();

    /// Register the [AnimationStatusListener]
    _controller.addStatusListener(_onAnimationStatus);

    /// Apply control instruction (e.g. play, stop, loop, mirror)
    var hasDelayDefined =
        widget.delay != Duration.zero && !widget.developerMode;
    if (hasDelayDefined) {
      /// If there is a delay defined, wait for the delay to finish and then
      /// apply the control instruction.
      _delayTimer = Timer(widget.delay, _applyControlInstruction);
    } else {
      /// If there is no delay defined, apply the control instruction directly.
      _applyControlInstruction();
    }

    super.initState();
  }

  @override
  void dispose() {
    _delayTimer?.cancel();

    super.dispose();
  }

  void _buildAnimation() {
    /// Chain tween with curve and connect it to the [AnimationController].
    _animation = widget.tween
        .chain(CurveTween(curve: widget.curve))
        .animate(_controller);

    /// If the developer mode is enabled, connect the [AnimationController]
    /// to the [AnimationDeveloperTools].
    if (widget.developerMode) {
      var transfer =
          context.findAncestorWidgetOfExactType<AnimationControllerTransfer>();
      assert(transfer != null,
          'Please place an AnimationDeveloperTools widget inside the widget tree');
      transfer?.controllerProvider(_controller);
    }
  }

  @override
  void didUpdateWidget(CustomAnimationBuilder<T> oldWidget) {
    /// Duration might have changed, so update the [AnimationController]
    _controller.duration = widget.duration;

    /// Rebuild the animation because the [tween] and [curve] might have
    /// changed.
    _buildAnimation();

    /// Apply the control instruction because [control] might have changed.
    _applyControlInstruction();

    super.didUpdateWidget(oldWidget);
  }

  void _applyControlInstruction() async {
    /// States where no instruction is required.
    if (widget.developerMode) {
      return;
    }

    /// Stop
    if (widget.control == Control.stop) {
      _trackPlaybackComplete();
      _controller.stop();
    }

    /// Play
    if (widget.control == Control.play) {
      unawaited(_controller.play());
    }

    /// Play reverse
    if (widget.control == Control.playReverse) {
      unawaited(_controller.playReverse());
    }

    /// Play from start
    if (widget.control == Control.playFromStart) {
      unawaited(_controller.forward(from: 0.0));
    }

    /// Play reverse from end
    if (widget.control == Control.playReverseFromEnd) {
      unawaited(_controller.reverse(from: 1.0));
    }

    /// Loop
    if (widget.control == Control.loop) {
      unawaited(_controller.loop());
    }

    /// Mirror
    if ((widget.control == Control.mirror) && !_isControlSetToMirror) {
      /// Keep track that the control is set to mirror. This is used to prevent
      /// the animation from being mirrored again, if the widget is rebuilt.
      _isControlSetToMirror = true;
      unawaited(_controller.mirror());
    }

    /// Reset mirror tracking if the control instruction is not mirror.
    if (widget.control != Control.mirror) {
      _isControlSetToMirror = false;
    }
  }

  void _onAnimationStatus(AnimationStatus status) {
    /// Expose the [AnimationStatusListener] from the [AnimationController].
    widget.animationStatusListener?.call(status);

    /// Check the animation status and notify the listeners accordingly.
    if (status == AnimationStatus.forward ||
        status == AnimationStatus.reverse) {
      _trackPlaybackStart();
    } else if (status == AnimationStatus.dismissed ||
        status == AnimationStatus.completed) {
      _trackPlaybackComplete();
    }
  }

  /// Notify that the animation started.
  void _trackPlaybackStart() {
    if (!_isPlaying) {
      _isPlaying = true;
      widget.onStarted?.call();
    }
  }

  /// Notify that the animation completed.
  void _trackPlaybackComplete() {
    if (_isPlaying) {
      _isPlaying = false;
      widget.onCompleted?.call();
    }
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, _animation.value, widget.child);
}
