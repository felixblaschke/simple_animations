# stateless_animation.dart without ⚡ Supercharged

Here is the example without using any syntactic sugar, provided by the [⚡️ Supercharged](https://pub.dev/packages/supercharged) package:

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // create animation widget with type of animated variable
    return PlayAnimation<Color?>(
        tween: ColorTween(begin: Colors.red, end: Colors.blue), // define tween
        duration: Duration(seconds: 2), // define duration
        builder: (context, child, value) {
          return Container(
            color: value, // use animated value
            width: 100,
            height: 100,
          );
        });
  }
}

```
## About Supercharged


⚡️ **Supercharged** is created and maintained by the 🎬 **Simple Animations** developers.

It contains many useful **extension methods** that **increase readability** of your `Widget` code:

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

persons.groupBy(
    (p) => p.age < 40 ? "young" : "old",
    valueTransform: (p) => p.name
); // {"young": ["John", "Carl"], "old": ["Peter", "Sarah"]}
```

If you are curious of ⚡ Supercharged [take a look at more examples](https://pub.dev/packages/supercharged).

