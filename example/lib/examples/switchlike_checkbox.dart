import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:simple_animations_example_app/widgets/example_page.dart';
import 'package:supercharged/supercharged.dart';

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

enum _CheckboxProps { paddingLeft, color, text, rotation }

class SwitchlikeCheckbox extends StatelessWidget {
  final bool checked;

  SwitchlikeCheckbox({this.checked});

  @override
  Widget build(BuildContext context) {
    var tween = MultiTween<_CheckboxProps>()
      ..add(_CheckboxProps.paddingLeft, 0.0.tweenTo(20.0), 1.seconds)
      ..add(_CheckboxProps.color, Colors.grey.tweenTo(Colors.blue), 1.seconds)
      ..add(_CheckboxProps.text, ConstantTween("OFF"), 500.milliseconds)
      ..add(_CheckboxProps.text, ConstantTween("ON"), 500.milliseconds)
      ..add(_CheckboxProps.rotation, (-2 * pi).tweenTo(0.0), 1.seconds);

    return CustomAnimation<MultiTweenValues<_CheckboxProps>>(
      control: checked
          ? CustomAnimationControl.PLAY
          : CustomAnimationControl.PLAY_REVERSE,
      startPosition: checked ? 1.0 : 0.0,
      duration: tween.duration * 1.2,
      tween: tween,
      curve: Curves.easeInOut,
      builder: _buildCheckbox,
    );
  }

  Widget _buildCheckbox(
      context, child, MultiTweenValues<_CheckboxProps> value) {
    return Container(
      decoration: _outerBoxDecoration(value.get(_CheckboxProps.color)),
      width: 50,
      height: 30,
      padding: const EdgeInsets.all(3.0),
      child: Stack(
        children: [
          Positioned(
              child: Padding(
            padding:
                EdgeInsets.only(left: value.get(_CheckboxProps.paddingLeft)),
            child: Transform.rotate(
              angle: value.get(_CheckboxProps.rotation),
              child: Container(
                decoration:
                    _innerBoxDecoration(value.get(_CheckboxProps.color)),
                width: 20,
                child: Center(
                    child: Text(value.get(_CheckboxProps.text),
                        style: labelStyle)),
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
