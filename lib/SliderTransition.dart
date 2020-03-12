import 'package:flutter/material.dart';

class SliderTransition extends StatefulWidget {
  _SliderTransitionState state;
  final Duration duration;

  SliderTransition({Key key, this.state, this.duration = const Duration(milliseconds: 2000)}) : super(key: key) {
    state = _SliderTransitionState(duration);
  }

  @override
  _SliderTransitionState createState() {
    return state;
  }
}

class _SliderTransitionState extends State<SliderTransition>
    with SingleTickerProviderStateMixin {

  _SliderTransitionState(Duration duration) {
    controller = AnimationController(duration: duration, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }

  AnimationController controller;

  List<Widget> createSlider({@required List<Widget> widgets, bool horizontal =true, bool vertical ,int extent = 50}) {
    
    final int count = widgets.length;

    return List<Widget>.generate(count, (int index) {
      final Animation<double> animation =
          Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Interval(index / count, 1.0, curve: Curves.fastOutSlowIn),
        ),
      );
      controller.forward();

      return AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          return Opacity(
            opacity: animation.value,
            child: Transform(
              transform: Matrix4.translationValues(
                  horizontal == null ? 0 : (1 - animation.value) * extent,
                  vertical == null ? 0 : (1 - animation.value) * extent,
                  0),
              child: widgets[index],
            ),
          );
        },
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
