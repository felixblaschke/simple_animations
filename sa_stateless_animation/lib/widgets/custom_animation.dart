part of sa_stateless_animation;

/// Set of instruction you can pass into a [CustomAnimation.control].
enum CustomAnimationControl {
  /// Stops the animation at the current position.
  STOP,

  /// Plays the animation from the current position to the end.
  PLAY,

  /// Plays the animation from the current position reverse to the start.
  PLAY_REVERSE,

  /// Reset the position of the animation to `0.0` and starts playing
  /// to the end.
  PLAY_FROM_START,

  /// Reset the position of the animation to `1.0` and starts playing
  /// reverse to the start.
  PLAY_REVERSE_FROM_END,

  /// Endlessly plays the animation from the start to the end.
  /// Make sure to utilize [CustomAnimation.child] since a permanent
  /// animation eats up performance.
  LOOP,

  /// Endlessly plays the animation from the start to the end, then
  /// it plays reverse to the start, then forward again and so on.
  /// Make sure to utilize [CustomAnimation.child] since a permanent
  /// animation eats up performance.
  MIRROR
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
/// If you want to start your animation at alternative position, you
/// can set a [startPosition] that takes values between `0.0` (start)
/// and `1.0` (end).
///
/// You can provide an [animationStatusListener] that gets called by
/// the internal `AnimationController`. It's receives events of the
/// type [AnimationStatus].
///
/// If you work with multiple animation widgets that are conditionally
/// rendered, you might want to set a [key]. Otherwise Flutter will
/// recycled your "old animation" which results in strange behavior.
class CustomAnimation<T> extends StatefulWidget {
  final Animatable<T> tween;
  final AnimatedWidgetBuilder<T> builder;
  final CustomAnimationControl control;
  final Curve curve;
  final Duration duration;
  final Duration delay;
  final Widget child;
  final AnimationStatusListener animationStatusListener;
  final double startPosition;

  /// Creates a new CustomAnimation widget.
  /// See class documentation for more information.
  CustomAnimation(
      {@required this.builder,
      @required this.tween,
      this.control = CustomAnimationControl.PLAY,
      this.curve = Curves.linear,
      this.duration = const Duration(seconds: 1),
      this.delay = Duration.zero,
      this.startPosition = 0.0,
      this.child,
      this.animationStatusListener,
      Key key})
      : assert(tween != null,
            "Please set property tween. Example:\ntween: Tween(from: 0.0, to: 100.0)"),
        assert(builder != null,
            "Please set property builder. Example:\nbuilder: (context, child, value) => Container(width: value))"),
        assert(startPosition >= 0 && startPosition <= 1,
            "The property startPosition must have a value between 0.0 and 1.0."),
        super(key: key);

  @override
  _CustomAnimationState<T> createState() => _CustomAnimationState<T>();
}

class _CustomAnimationState<T> extends State<CustomAnimation<T>>
    with AnimationMixin {
  Animation<T> _animation;
  bool _isDisposed = false;
  bool _waitForDelay = true;
  bool _isControlSetToMirror = false;

  @override
  void initState() {
    controller.value = widget.startPosition;
    controller.duration = widget.duration;

    _buildAnimation();

    if (widget.animationStatusListener != null) {
      controller.addStatusListener(widget.animationStatusListener);
    }

    asyncInitState();
    super.initState();
  }

  void _buildAnimation() {
    _animation = widget.tween.curved(widget.curve).animatedBy(controller);
  }

  void asyncInitState() async {
    if (widget.delay != null) {
      await Future.delayed(widget.delay);
    }
    _waitForDelay = false;
    _applyControlInstruction();
  }

  @override
  void didUpdateWidget(CustomAnimation<T> oldWidget) {
    controller.duration = widget.duration;
    _buildAnimation();
    _applyControlInstruction();
    super.didUpdateWidget(oldWidget);
  }

  void _applyControlInstruction() async {
    if (_isDisposed || _waitForDelay) {
      return;
    }

    if (widget.control == CustomAnimationControl.STOP) {
      controller.stop();
    }
    if (widget.control == CustomAnimationControl.PLAY) {
      controller.play();
    }
    if (widget.control == CustomAnimationControl.PLAY_REVERSE) {
      controller.playReverse();
    }
    if (widget.control == CustomAnimationControl.PLAY_FROM_START) {
      controller.forward(from: 0.0);
    }
    if (widget.control == CustomAnimationControl.PLAY_REVERSE_FROM_END) {
      controller.reverse(from: 1.0);
    }
    if (widget.control == CustomAnimationControl.LOOP) {
      controller.loop();
    }
    if (widget.control == CustomAnimationControl.MIRROR &&
        !_isControlSetToMirror) {
      _isControlSetToMirror = true;
      controller.mirror();
    }

    if (widget.control != CustomAnimationControl.MIRROR) {
      _isControlSetToMirror = false;
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
