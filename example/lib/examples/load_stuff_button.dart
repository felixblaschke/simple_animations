import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:sa_v1_migration/sa_v1_migration.dart';
import 'package:simple_animations_example_app/widgets/example_page.dart';

class LoadStuffButton extends StatefulWidget {
  @override
  _LoadStuffButtonState createState() => _LoadStuffButtonState();
}

typedef AniWidgetBuilder = Widget Function(BuildContext context, dynamic ani);

class _LoadStuffButtonState extends State<LoadStuffButton> {
  bool _startedLoading = false;
  bool _firstAnimationFinished = false;
  bool _dataAvailable = false;

  @override
  Widget build(BuildContext context) {
    final durationPart1 = const Duration(milliseconds: 400);
    final durationPart1a = const Duration(milliseconds: 200);
    final durationPart1b = const Duration(milliseconds: 200);
    final durationPart2 = const Duration(milliseconds: 400);

    final tween1 = MultiTrackTween([
      Track("width").add(durationPart1, Tween(begin: 200.0, end: 50.0)),
      Track("backgroundColor").add(
          durationPart1, ColorTween(begin: Colors.green, end: Colors.white)),
      Track("childIndex")
          .add(durationPart1a, ConstantTween(0))
          .add(durationPart1b, ConstantTween(1)),
      Track("opacity")
          .add(durationPart1a, Tween(begin: 1.0, end: 0.0))
          .add(durationPart1b, Tween(begin: 0.0, end: 1.0))
    ]);

    final tween2 = MultiTrackTween([
      Track("width").add(durationPart2, Tween(begin: 50.0, end: 200.0)),
      Track("backgroundColor").add(durationPart2, ConstantTween(Colors.white)),
      Track("childIndex").add(durationPart2, ConstantTween(2))
    ]);

    final playSecondAnimation = _dataAvailable && _firstAnimationFinished;

    return GestureDetector(
      onTap: _clickLoadStuff,
      child: ControlledAnimation(
        playback: !_startedLoading ? Playback.PAUSE : Playback.PLAY_FORWARD,
        tween: tween1,
        duration: tween1.duration,
        animationControllerStatusListener: _listenToAnimationFinished,
        builder: (context, ani1) {
          return ControlledAnimation(
            playback:
                !playSecondAnimation ? Playback.PAUSE : Playback.PLAY_FORWARD,
            tween: tween2,
            duration: tween2.duration,
            builder: (context, ani2) {
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

  Widget buildButton(context, ani) {
    return Container(
      height: 50,
      width: ani["width"],
      decoration: boxDecoration(ani["backgroundColor"]),
      child: contentChildren[ani["childIndex"]](context, ani),
    );
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  final contentChildren = <AniWidgetBuilder>[
    loadButtonLabel,
    progressIndicator,
    showSuccess
  ];

  static final AniWidgetBuilder loadButtonLabel = (context, ani) => Center(
        child: Opacity(
          opacity: ani["opacity"],
          child: Text(
            "Load Stuff",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );

  static final AniWidgetBuilder progressIndicator = (context, ani) => Center(
        child: ControlledAnimation(
          playback: Playback.LOOP,
          duration: Duration(milliseconds: 600),
          tween: Tween(begin: 0.0, end: pi * 2),
          builder: (context, rotation) => Transform.rotate(
            angle: rotation,
            child: Opacity(
              opacity: ani["opacity"],
              child: Icon(
                Icons.sync,
                color: Colors.green,
              ),
            ),
          ),
        ),
      );

  static final AniWidgetBuilder showSuccess = (context, ani) {
    final tween = MultiTrackTween([
      Track("width")
          .add(Duration(milliseconds: 400), Tween(begin: 0.0, end: 100.0)),
      Track("opacity")
          .add(Duration(milliseconds: 300), ConstantTween(0.0))
          .add(Duration(milliseconds: 300), Tween(begin: 0.0, end: 1.0))
    ]);

    return ControlledAnimation(
      duration: tween.duration,
      tween: tween,
      builder: (context, animation) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(
            Icons.check,
            color: Colors.green.shade700,
          ),
          ClipRect(
            child: SizedBox(
              width: animation["width"],
              child: Opacity(
                  opacity: animation["opacity"],
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
