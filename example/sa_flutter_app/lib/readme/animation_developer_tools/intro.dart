import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // put DevTools very high in the widget hierarchy
      body: AnimationDeveloperTools(
        child: Container(), // your UI
      ),
    );
  }
}
