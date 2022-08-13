import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() => runApp(
    const MaterialApp(home: Scaffold(body: Center(child: SwappingButton()))));

class SwappingButton extends StatefulWidget {
  const SwappingButton({Key? key}) : super(key: key);

  @override
  _SwappingButtonState createState() => _SwappingButtonState();
}

class _SwappingButtonState extends State<SwappingButton> {
  var control = Control.play; // define variable

  void _toggleDirection() {
    setState(() {
      // let the animation play to the opposite direction
      control = control == Control.play ? Control.playReverse : Control.play;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomAnimationBuilder<double>(
      control: control, // bind variable with control instruction
      tween: Tween<double>(begin: -100.0, end: 100.0),
      duration: const Duration(seconds: 1),
      builder: (context, value, child) {
        // moves child from left to right
        return Transform.translate(
          offset: Offset(value, 0),
          child: child,
        );
      },
      child: OutlinedButton(
        // clicking button changes animation direction
        onPressed: _toggleDirection,
        child: const Text('Swap'),
      ),
    );
  }
}
