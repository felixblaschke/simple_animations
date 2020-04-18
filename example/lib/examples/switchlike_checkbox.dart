import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:sa_v1_migration/sa_v1_migration.dart';
import 'package:simple_animations_example_app/widgets/example_page.dart';

class ExampleForm extends StatefulWidget {
  @override
  _ExampleFormState createState() => _ExampleFormState();
}

class _ExampleFormState extends State<ExampleForm> {
  bool enableCoolStuff = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      behavior: HitTestBehavior.translucent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SwitchlikeCheckbox(checked: enableCoolStuff),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              "Enable cool stuff",
              textScaleFactor: 1.3,
            ),
          )
        ],
      ),
    );
  }

  void _toggle() {
    setState(() {
      enableCoolStuff = !enableCoolStuff;
    });
  }
}

class SwitchlikeCheckbox extends StatelessWidget {
  final bool checked;

  SwitchlikeCheckbox({this.checked});

  @override
  Widget build(BuildContext context) {
    var tween = MultiTrackTween([
      Track("paddingLeft")
          .add(Duration(milliseconds: 1000), Tween(begin: 0.0, end: 20.0)),
      Track("color").add(Duration(milliseconds: 1000),
          ColorTween(begin: Colors.grey, end: Colors.blue)),
      Track("text")
          .add(Duration(milliseconds: 500), ConstantTween("OFF"))
          .add(Duration(milliseconds: 500), ConstantTween("ON")),
      Track("rotation")
          .add(Duration(milliseconds: 1000), Tween(begin: -2 * pi, end: 0.0))
    ]);

    return ControlledAnimation(
      playback: checked ? Playback.PLAY_FORWARD : Playback.PLAY_REVERSE,
      startPosition: checked ? 1.0 : 0.0,
      duration: tween.duration * 1.2,
      tween: tween,
      curve: Curves.easeInOut,
      builder: _buildCheckbox,
    );
  }

  Widget _buildCheckbox(context, animation) {
    return Container(
      decoration: _outerBoxDecoration(animation["color"]),
      width: 50,
      height: 30,
      padding: const EdgeInsets.all(3.0),
      child: Stack(
        children: [
          Positioned(
              child: Padding(
            padding: EdgeInsets.only(left: animation["paddingLeft"]),
            child: Transform.rotate(
              angle: animation["rotation"],
              child: Container(
                decoration: _innerBoxDecoration(animation["color"]),
                width: 20,
                child:
                    Center(child: Text(animation["text"], style: labelStyle)),
              ),
            ),
          ))
        ],
      ),
    );
  }

  BoxDecoration _innerBoxDecoration(color) => BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(25)), color: color);

  BoxDecoration _outerBoxDecoration(color) => BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        border: Border.all(
          width: 2,
          color: color,
        ),
      );

  static final labelStyle = TextStyle(
      height: 1.2,
      fontWeight: FontWeight.bold,
      fontSize: 9,
      color: Colors.white);
}

class SwitchlikeCheckboxDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: "Switch-like Checkbox",
      pathToFile: "switchlike_checkbox.dart",
      delayStartup: false,
      builder: (context) => Center(child: ExampleForm()),
    );
  }
}
