import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() => runApp(const MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatefulWidget {
  const Page({Key? key}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {
  var control = CustomAnimationControl.play; // state variable

  @override
  Widget build(BuildContext context) {
    return CustomAnimation<double>(
      // bind state variable to parameter
      control: control,
      tween: Tween<double>(begin: -100.0, end: 100.0),
      builder: (context, child, value) {
        // animation that moves child from left to right
        return Transform.translate(
          offset: Offset(value, 0),
          child: child,
        );
      },
      // there is a button
      child: MaterialButton(
        color: Colors.yellow,
        // clicking button changes animation direction
        onPressed: toggleDirection,
        child: const Text('Swap'),
      ),
    );
  }

  void toggleDirection() {
    setState(() {
      // toggle between control instructions
      control = control == CustomAnimationControl.play
          ? CustomAnimationControl.playReverse
          : CustomAnimationControl.play;
    });
  }
}
