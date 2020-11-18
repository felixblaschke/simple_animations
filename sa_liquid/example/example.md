
# 📝 Examples

The preferred way of creating configured Liquid widgets is by using **[Liquid Studio](https://felixblaschke.github.io/liquid-studio)**.

## Plasma Example

![example1](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_liquid/plasma-example.gif)

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() => runApp(MaterialApp(home: Page()));

class Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Plasma(
        particles: 10,
        foregroundColor: Color(0xd61e0000),
        backgroundColor: Color(0xffee360d),
        size: 0.87,
        speed: 5.92,
        offset: 0.00,
        blendMode: BlendMode.darken,
        child: Center(child: Text("Hot!")), // your UI here
      ),
    );
  }
}

```