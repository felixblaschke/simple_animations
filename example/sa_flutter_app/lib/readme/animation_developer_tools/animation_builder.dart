import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() => runApp(const MaterialApp(home: Scaffold(body: MyPage())));

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // put DevTools very high in the widget hierarchy
      child: AnimationDeveloperTools(
        child: Center(
          child: PlayAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 100.0),
            duration: const Duration(seconds: 1),
            developerMode: true, // enable developer mode
            builder: (context, value, child) {
              return Container(
                width: value,
                height: value,
                color: Colors.blue,
              );
            },
          ),
        ),
      ),
    );
  }
}
