import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() =>
    runApp(const MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatefulWidget {
  const Page({Key? key}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {
  Control control = Control.play; // state variable

  @override
  Widget build(BuildContext context) {
    return CustomAnimationBuilder<double>(
      duration: const Duration(seconds: 1),
      control: control, // bind state variable to parameter
      tween: Tween(begin: -100.0, end: 100.0),
      builder: (context, value, child) {
        return Transform.translate(
          // animation that moves childs from left to right
          offset: Offset(value, 0),
          child: child,
        );
      },
      child: MaterialButton(
        // there is a button
        color: Colors.yellow,
        onPressed:
            toggleDirection, // clicking button changes animation direction
        child: const Text('Swap'),
      ),
    );
  }

  void toggleDirection() {
    // toggle between control instructions
    setState(() {
      control = (control == Control.play) ? Control.playReverse : Control.play;
    });
  }
}
