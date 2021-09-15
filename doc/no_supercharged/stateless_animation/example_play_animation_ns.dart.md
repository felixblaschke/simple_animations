# example_play_animation.dart

Here is the example **without** using Supercharged: 

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() => runApp(const MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  const Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlayAnimation<double>(
      // specify tween (from 50.0 to 200.0)
      tween: Tween<double>(begin: 50.0, end: 200.0),

      // set a duration
      duration: const Duration(seconds: 5),

      // set a curve
      curve: Curves.easeInOut,

      // use builder function
      builder: (context, child, value) {
        // apply animated value obtained from builder function parameter
        return Container(
          width: value,
          height: value,
          color: Colors.green,
          child: child,
        );
      },
      child: const Text('Hello World'),
    );
  }
}

```

&nbsp;

&nbsp;

&nbsp;

## What is Supercharged?

It provides **extension methods** to simplify certain scenarios even further. Have a look:

```dart
// Tweens
0.0.tweenTo(100.0); // Tween<double>(begin: 0.0, end: 100.0);
Colors.red.tweenTo(Colors.blue); // ColorTween(begin: Colors.red, end: Colors.blue);

// Durations
100.milliseconds; // Duration(milliseconds: 100);
2.seconds; // Duration(seconds: 2);

// Colors
'#ff0000'.toColor(); // Color(0xFFFF0000);
'red'.toColor(); // Color(0xFFFF0000);
```

But it also helps you with data processing:

```dart
var persons = [
    Person(name: "John", age: 21),
    Person(name: "Carl", age: 18),
    Person(name: "Peter", age: 56),
    Person(name: "Sarah", age: 61)
];

var randomPerson = persons.pickOne();

persons.groupBy(
    (p) => p.age < 40 ? "young" : "old",
    valueTransform: (p) => p.name
); // {"young": ["John", "Carl"], "old": ["Peter", "Sarah"]}
```

So if you are curious take a look at [**more Supercharged examples**](https://pub.dev/packages/supercharged).

