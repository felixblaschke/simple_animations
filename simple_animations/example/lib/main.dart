import 'package:flutter/material.dart';
import 'package:simple_animations_example_app/widgets/homescreen.dart';

void main() => runApp(SimpleAnimationsExampleApp());

class SimpleAnimationsExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Simple Animations Example App",
      home: Homescreen(),
      theme: _theme(),
    );
  }

  ThemeData _theme() {
    var lightTheme = ThemeData.light();

    return lightTheme.copyWith(
        textTheme: lightTheme.textTheme.copyWith(
            body1: lightTheme.textTheme.body1.copyWith(height: 1.25),
            body2: lightTheme.textTheme.body2
                .copyWith(height: 1.25, fontWeight: FontWeight.w800)),
        appBarTheme: AppBarTheme(color: Color.fromARGB(255, 30, 30, 30)));
  }
}
