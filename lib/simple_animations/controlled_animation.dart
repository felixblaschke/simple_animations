import 'package:flutter/widgets.dart';

/// Playback tell the controller of the animation what to do.
enum Playback {
  /// Animation stands still.
  PAUSE,

  /// Animation plays forwards and stops at the end.
  PLAY_FORWARD,

  /// Animation plays backwards and stops at the beginning.
  PLAY_REVERSE,

  /// Animation will reset to the beginning and start playing forward.
  START_OVER_FORWARD,

  /// Animation will reset to the end and start play backward.
  START_OVER_REVERSE,

  /// Animation will play forwards and start over at the beginning when it
  /// reaches the end.
  LOOP,

  /// Animation will play forward until the end and will reverse playing until
  /// it reaches the beginning. Then it starts over playing forward. And so on.
  MIRROR
}

/// Widget to create custom, managed, tween-based animations in a very simple way.
///
/// ---
///
/// An internal [AnimationController] will do everything you tell him by
/// dynamically assigning the one [Playback] to [playback] property.
/// By default the animation will start playing forward and stops at the end.
///
/// A minimum set of properties are [duration] (time span of the animation),
/// [tween] (values to interpolate among the animation) and a [builder] function
/// (defines the animated scene).
///
/// Instead of using [builder] as building function you can use for performance
/// critical scenarios [builderWithChild] along with a prebuild [child].
///
/// ---
///
/// The following properties are optional:
///
/// - You can apply a [delay] that forces the animation to pause a
///   specified time before the animation will perform the defined [playback]
///   instruction.
///
/// - You can specify a [curve] that modifies the [tween] by applying a
///   non-linear animation function. You can find curves in [Curves], for
///   example [Curves.easeOut] or [Curves.easeIn].
///
/// - You can track the animation by setting an [AnimationStatusListener] to
///   the property [animationControllerStatusListener]. The internal [AnimationController] then
///   will route out any events that occur. [ControlledAnimation] doesn't filter
///   or modifies these events. These events are currently only reliable for the
///   [playback]-types [Playback.PLAY_FORWARD] and [Playback.PLAY_REVERSE].
///
/// - You can set the start position of animation by specifying [startPosition]
///   with a value between *0.0* and *1.0*. The [startPosition] is only
///   evaluated once during the initialization of the widget.
///
class ControlledAnimation<T> extends StatefulWidget {
  final Playback playback;
  final Animatable<T> tween;
  final Curve curve;
  final Duration duration;
  final Duration delay;
  final Widget Function(BuildContext buildContext, T animatedValue) builder;
  final Widget Function(BuildContext, Widget child, T animatedValue)
      builderWithChild;
  final Widget child;
  final AnimationStatusListener animationControllerStatusListener;
  final double startPosition;

  ControlledAnimation(
      {this.playback = Playback.PLAY_FORWARD,
      this.tween,
      this.curve = Curves.linear,
      this.duration,
      this.delay,
      this.builder,
      this.builderWithChild,
      this.child,
      this.animationControllerStatusListener,
      this.startPosition = 0.0,
      Key key})
      : assert(duration != null,
            "Please set property duration. Example: Duration(milliseconds: 500)"),
        assert(tween != null,
            "Please set property tween. Example: Tween(from: 0.0, to: 100.0)"),
        assert(
            (builderWithChild != null && child != null && builder == null) ||
                (builder != null && builderWithChild == null && child == null),
            "Either use just builder and keep buildWithChild and child null. "
            "Or keep builder null and set a builderWithChild and a child."),
        assert(
            startPosition >= 0 && startPosition <= 1,
            "The property startPosition "
            "must have a value between 0.0 and 1.0."),
        super(key: key);

  @override
  _ControlledAnimationState<T> createState() => _ControlledAnimationState<T>();
}

class _ControlledAnimationState<T> extends State<ControlledAnimation<T>>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<T> _animation;
  bool _isDisposed = false;
  bool _waitForDelay = true;
  bool _isCurrentlyMirroring = false;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..addListener(() {
        setState(() {});
      })
      ..value = widget.startPosition;

    _animation = widget.tween
        .chain(CurveTween(curve: widget.curve))
        .animate(_controller);

    if (widget.animationControllerStatusListener != null) {
      _controller.addStatusListener(widget.animationControllerStatusListener);
    }

    initialize();
    super.initState();
  }

  void initialize() async {
    if (widget.delay != null) {
      await Future.delayed(widget.delay);
    }
    _waitForDelay = false;
    executeInstruction();
  }

  @override
  void didUpdateWidget(ControlledAnimation<T> oldWidget) {
    _controller.duration = widget.duration;

    _animation = widget.tween
        .chain(CurveTween(curve: widget.curve))
        .animate(_controller);

    executeInstruction();
    super.didUpdateWidget(oldWidget);
  }

  void executeInstruction() async {
    if (_isDisposed || _waitForDelay) {
      return;
    }

    if (widget.playback == Playback.PAUSE) {
      _controller.stop();
    }
    if (widget.playback == Playback.PLAY_FORWARD) {
      _controller.forward();
    }
    if (widget.playback == Playback.PLAY_REVERSE) {
      _controller.reverse();
    }
    if (widget.playback == Playback.START_OVER_FORWARD) {
      _controller.forward(from: 0.0);
    }
    if (widget.playback == Playback.START_OVER_REVERSE) {
      _controller.reverse(from: 1.0);
    }
    if (widget.playback == Playback.LOOP) {
      _controller.repeat();
    }
    if (widget.playback == Playback.MIRROR && !_isCurrentlyMirroring) {
      _isCurrentlyMirroring = true;
      _controller.repeat(reverse: true);
    }

    if (widget.playback != Playback.MIRROR) {
      _isCurrentlyMirroring = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.builder != null) {
      return widget.builder(context, _animation.value);
    } else if (widget.builderWithChild != null && widget.child != null) {
      return widget.builderWithChild(context, widget.child, _animation.value);
    }
    return Container();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _controller.dispose();
    super.dispose();
  }
}
