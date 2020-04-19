import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:simple_animations_example_app/widgets/example_page.dart';
import 'package:supercharged/supercharged.dart';

class LoadStuffButton extends StatefulWidget {
  @override
  _LoadStuffButtonState createState() => _LoadStuffButtonState();
}

enum _AniProps { width, backgroundColor, childIndex, opacity }

class _LoadStuffButtonState extends State<LoadStuffButton> {
  bool _startedLoading = false;
  bool _firstAnimationFinished = false;
  bool _dataAvailable = false;

  @override
  Widget build(BuildContext context) {
    final tween1 = MultiTween<_AniProps>()
      ..add(_AniProps.width, 200.0.tweenTo(50.0), 400.milliseconds)
      ..add(_AniProps.backgroundColor, Colors.green.tweenTo(Colors.white),
          400.milliseconds)
      ..add(_AniProps.childIndex, ConstantTween(0), 200.milliseconds)
      ..add(_AniProps.childIndex, ConstantTween(1), 200.milliseconds)
      ..add(_AniProps.opacity, 1.0.tweenTo(0.0), 200.milliseconds)
      ..add(_AniProps.opacity, 0.0.tweenTo(1.0), 200.milliseconds);

    final tween2 = MultiTween<_AniProps>()
      ..add(_AniProps.width, 50.0.tweenTo(200.0), 400.milliseconds)
      ..add(_AniProps.backgroundColor, ConstantTween(Colors.white),
          400.milliseconds)
      ..add(_AniProps.childIndex, ConstantTween(2), 400.milliseconds);

    final playSecondAnimation = _dataAvailable && _firstAnimationFinished;

    return GestureDetector(
      onTap: _clickLoadStuff,
      child: CustomAnimation<MultiTweenValues<_AniProps>>(
        control: !_startedLoading
            ? CustomAnimationControl.STOP
            : CustomAnimationControl.PLAY,
        tween: tween1,
        duration: tween1.duration,
        animationStatusListener: _listenToAnimationFinished,
        builder: (context, child, ani1) {
          return CustomAnimation<MultiTweenValues<_AniProps>>(
            control: !playSecondAnimation
                ? CustomAnimationControl.STOP
                : CustomAnimationControl.PLAY,
            tween: tween2,
            duration: tween2.duration,
            builder: (context, child, ani2) {
              final ani = !playSecondAnimation ? ani1 : ani2;
              return buildButton(context, ani);
            },
          );
        },
      ),
    );
  }

  void _listenToAnimationFinished(status) {
    if (status == AnimationStatus.completed) {
      setState(() {
        _firstAnimationFinished = true;
      });
    }
  }

  void _clickLoadStuff() {
    setState(() {
      _startedLoading = true;
    });
    Future.delayed(Duration(milliseconds: 150 + Random().nextInt(2500)))
        .then((_) {
      setState(() {
        _dataAvailable = true;
      });
    });
  }

  Widget buildButton(BuildContext context, MultiTweenValues<_AniProps> ani) {
    return Container(
      height: 50,
      width: ani.get(_AniProps.width),
      decoration: boxDecoration(ani.get(_AniProps.backgroundColor)),
      child: contentChildren[ani.get(_AniProps.childIndex)](context, null, ani),
    );
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  final contentChildren = <AnimatedWidgetBuilder<MultiTweenValues<_AniProps>>>[
    loadButtonLabel,
    progressIndicator,
    showSuccess
  ];

  static final AnimatedWidgetBuilder<MultiTweenValues<_AniProps>>
      loadButtonLabel = (context, child, ani) => Center(
            child: Opacity(
              opacity: ani.get(_AniProps.opacity),
              child: Text(
                "Load Stuff",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          );

  static final AnimatedWidgetBuilder<MultiTweenValues<_AniProps>>
      progressIndicator = (context, child, ani) => Center(
            child: LoopAnimation<double>(
              duration: 600.milliseconds,
              tween: 0.0.tweenTo(pi * 2),
              builder: (context, child, rotation) => Transform.rotate(
                angle: rotation,
                child: Opacity(
                  opacity: ani.get(_AniProps.opacity),
                  child: Icon(
                    Icons.sync,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
          );

  static final AnimatedWidgetBuilder<MultiTweenValues<_AniProps>> showSuccess =
      (context, child, ani) {
    final tween = MultiTween<_AniProps>()
      ..add(_AniProps.width, 0.0.tweenTo(100.0), 400.milliseconds)
      ..add(_AniProps.opacity, ConstantTween(0.0), 300.milliseconds)
      ..add(_AniProps.opacity, 0.0.tweenTo(1.0), 300.milliseconds);

    return PlayAnimation<MultiTweenValues<_AniProps>>(
      duration: tween.duration,
      tween: tween,
      builder: (context, child, value) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(
            Icons.check,
            color: Colors.green.shade700,
          ),
          ClipRect(
            child: SizedBox(
              width: value.get(_AniProps.width),
              child: Opacity(
                  opacity: value.get(_AniProps.opacity),
                  child: Text(
                    "Success",
                    style:
                        TextStyle(color: Colors.green.shade800, fontSize: 16),
                  )),
            ),
          )
        ],
      ),
    );
  };

  BoxDecoration boxDecoration(Color backgroundColor) {
    return BoxDecoration(
        border: Border.all(color: Colors.green, width: 2),
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(40),
              blurRadius: 10,
              offset: Offset(0, 5))
        ]);
  }
}

class LoadStuffButtonDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: "Load Stuff Button",
      pathToFile: "load_stuff_button.dart",
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Center(
              child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "When clicking the button a simulated HTTP request takes randomly between 50ms and 2500ms.",
              textAlign: TextAlign.center,
            ),
          )),
          Center(child: LoadStuffButton())
        ],
      ),
    );
  }
}
