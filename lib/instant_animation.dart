import 'package:flutter/widgets.dart';

/// A widget for performing easy custom animations.
///
/// You need to specify a [duration], a [tween] and a [builder] function.
/// The animation will start instantly. Optionally you can [delay] the start
/// of the animation or refine the shape of the tween's [curve].
///
/// The [duration] specifies the time of the animation excluding any [delay].
///
/// The [tween] defines the values that are passed to the [builder] function.
/// These values will automatically interpolated during the animation process
/// based on the type of the tween. Common tweens types are [Tween],
/// [ColorTween] or [TweenSequence]. You can finde more types of tween in
/// [Flutter's animation library](https://api.flutter.dev//flutter/animation/animation-library.html).
///
/// The [builder] creates your widgets that gets animated. The animation
/// automatically calls the [builder] function every time the animation updates.
/// The [builder] passes the [BuildContext] and the interpolated animation
/// [value], and expects you to return a [Widget].
///
/// You can modify the start of the animation by setting a [delay].
/// This allows you to easily create staggered animation scenes by using
/// multiple [InstantAnimation] widgets.
///
/// Also you can apply easing effect to you [tween] by setting [curve] to one
/// Flutter's [Curves] enum, for example [Curves.easeOut] or [Curves.easeIn].
class InstantAnimation<T> extends StatefulWidget {
  final Duration duration;
  final Duration delay;
  final Animatable<T> tween;
  final Curve curve;
  final Widget Function(BuildContext context, T value) builder;

  InstantAnimation(
      {this.duration,
      this.builder,
      this.tween,
      this.curve = Curves.linear,
      Key key,
      this.delay = const Duration(seconds: 0)})
      : assert(
            duration != null,
            "Specify a duration for your animation.\n"
            "Example:\n"
            "duration: Duration(milliseconds: 500)"),
        assert(
            tween != null,
            "Specify a tween or other animatable for your animation.\n"
            "Example:\n"
            "tween: Tween(begin: 0.0, end: 300.0)"),
        assert(
            builder != null,
            "Specify a builder function that supplies you with the tweened value for your fancy animation.\n"
            "Example:\n"
            "builder: (context, value) {\n"
            "    return Container(\n"
            "               width: value,\n"
            "               height: 200.0,\n"
            "               color: Colors.red\n"
            "           );\n"
            "}"),
        super(key: key);

  @override
  _InstantAnimationState<T> createState() => _InstantAnimationState();
}

class _InstantAnimationState<T> extends State<InstantAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<T> _animation;
  bool _isDisposed = false;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..addListener(() {
        setState(() {});
      });
    _animation = widget.tween
        .chain(CurveTween(curve: widget.curve))
        .animate(_controller);

    executeAnimationPhases();
    super.initState();
  }

  void executeAnimationPhases() async {
    if (widget.delay == null) {
      _controller.forward();
    } else {
      await Future.delayed(widget.delay);
      if (!_isDisposed) {
        _controller.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _animation.value);
  }

  @override
  void dispose() {
    _isDisposed = true;
    _controller.dispose();
    super.dispose();
  }
}
