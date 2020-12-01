You can find a complete app [**in this directory**](https://github.com/felixblaschke/simple_animations/tree/master/example) that contains examples of Simple Animations in action. 

Also visit **[Liquid Studio](https://felixblaschke.github.io/liquid-studio)** to explore Liquid animations.






# 🍹 Liquid

The preferred way of creating configured Liquid widgets is by using **[Liquid Studio](https://felixblaschke.github.io/liquid-studio)**.





# 🚀 Stateless Animation

🛈 *Note: These examples uses **[supercharged](https://pub.dev/packages/supercharged)** for syntactic sugar.*

## Simple PlayAnimation widget

Animates the size of a square within a stateless widget.

![example1](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_stateless_animation/v1/stateless-animation-1.gif)

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

void main() => runApp(MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlayAnimation<double>(
      tween: (50.0).tweenTo(200.0), // <-- specify tween (from 50.0 to 200.0)
      duration: 5.seconds, // <-- set a duration
      builder: (context, child, value) { // <-- use builder function
        return Container(
          width: value, // <-- apply animated value obtained from builder function parameter
          height: value, // <-- apply animated value obtained from builder function parameter
          color: Colors.green,
        );
      },
    );
  }
}
```





## PlayAnimation widget with a child

This example demonstrates the usage of a child widget along with `PlayAnimation`.

![example2](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_stateless_animation/v1/stateless-animation-2.gif)

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

void main() => runApp(MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlayAnimation<double>(
      tween: (50.0).tweenTo(200.0),
      duration: 5.seconds,
      child: Center(child: Text("Hello!")), // <-- specify widget called "child"
      builder: (context, child, value) { // <-- obtain child from builder function parameter
        return Container(
          width: value,
          height: value,
          child: child, // <-- place child inside your animation
          color: Colors.green,
        );
      },
    );
  }
}
```



## PlayAnimation with non-linear animation

This example demonstrates a non-linear animation. A pink square increases it's size. The `easeOut` curve applied to the animation makes it slow down at the end.

![example3](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_stateless_animation/v1/stateless-animation-3.gif)

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

void main() => runApp(MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlayAnimation<double>(
      tween: 0.0.tweenTo(200.0),
      duration: 2.seconds,
      curve: Curves.easeOut,
      builder: (context, child, value) {
        return Container(
          width: value,
          height: value,
          color: Colors.pink,
        );
      },
    );
  }
}
```


## PlayAnimation with delay

This example demonstrates an animation that waits for two seconds before it starts it's animation.

![example4](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_stateless_animation/v1/stateless-animation-4.gif)

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

void main() => runApp(MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlayAnimation<double>(
      tween: 100.0.tweenTo(200.0),
      duration: 2.seconds,
      delay: 1.seconds,
      curve: Curves.easeOut,
      builder: (context, child, value) {
        return Container(
          width: value,
          height: 50.0,
          color: Colors.orange,
        );
      },
    );
  }
}
```


## LoopAnimation

Animation that repeatly pops up a text.

![example5](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_stateless_animation/v1/stateless-animation-5.gif)

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

void main() => runApp(MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoopAnimation<double>(
        tween: 0.0.tweenTo(10.0),
        duration: 2.seconds,
        curve: Curves.easeOut,
        builder: (context, child, value) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: Text("Hello!"));
  }
}
```




## MirrorAnimation

This examples endlessly moves a green box from left to right.

![example6](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_stateless_animation/v1/stateless-animation-6.gif)

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

void main() => runApp(MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MirrorAnimation<double>(
      tween: (-100.0).tweenTo(100.0), // <-- value for offset x-coordinate
      duration: 2.seconds,
      curve: Curves.easeInOutSine, // <-- non-linear animation
      builder: (context, child, value) {
        return Transform.translate(
          offset: Offset(value, 0), // <-- use animated value for x-coordinate
          child: child,
        );
      },
      child: Container(
        width: 100,
        height: 100,
        color: Colors.green,
      ),
    );
  }
}
```


## CustomAnimation in stateless environment

Example of a pulsing square created with a fully configured `CustomAnimation` widget.

![example7](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_stateless_animation/v1/stateless-animation-7.gif)

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

void main() => runApp(MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomAnimation<double>(
      control: CustomAnimationControl.MIRROR,
      tween: 100.0.tweenTo(200.0),
      duration: 2.seconds,
      delay: 1.seconds,
      curve: Curves.easeInOut,
      child: Center(
          child: Text(
        "Hello!",
        style: TextStyle(color: Colors.white, fontSize: 24),
      )),
      startPosition: 0.5,
      animationStatusListener: (status) {
        print("status updated: $status");
      },
      builder: (context, child, value) {
        return Container(
            width: value, height: value, color: Colors.blue, child: child);
      },
    );
  }
}
```

## CustomAnimation in a stateful environment

This example demonstrates the usage of `CustomAnimation` in a stateful widget.

![example8](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_stateless_animation/v1/stateless-animation-8.gif)

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

void main() => runApp(MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {
  CustomAnimationControl control = CustomAnimationControl.PLAY; // <-- state variable

  @override
  Widget build(BuildContext context) {
    return CustomAnimation<double>(
      control: control, // <-- bind state variable to parameter
      tween: (-100.0).tweenTo(100.0),
      builder: (context, child, value) {
        return Transform.translate( // <-- animation that moves childs from left to right
          offset: Offset(value, 0),
          child: child,
        );
      },
      child: MaterialButton( // <-- there is a button
        color: Colors.yellow,
        child: Text("Swap"),
        onPressed: toggleDirection, // <-- clicking button changes animation direction
      ),
    );
  }

  void toggleDirection() {
    setState(() { // toggle between control instructions
      control = (control == CustomAnimationControl.PLAY)
          ? CustomAnimationControl.PLAY_REVERSE
          : CustomAnimationControl.PLAY;
    });
  }
}
```









# 🎭 Multi Tween

🛈 *Note: These examples uses **[supercharged](https://pub.dev/packages/supercharged)** for syntactic sugar.*

## Animate multiple properties

This example animates width, height and color of a box.

![example1](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_multi_tween/v1/multitween-example-1.gif)

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

void main() => runApp(MyApp());

// Create enum that defines the animated properties
enum AniProps { width, height, color }

class MyApp extends StatelessWidget {

  // Specify your tween
  final _tween = MultiTween<AniProps>()
    ..add(AniProps.width, 0.0.tweenTo(100.0), 1000.milliseconds)
    ..add(AniProps.width, 100.0.tweenTo(200.0), 500.milliseconds)
    ..add(AniProps.height, 0.0.tweenTo(200.0), 2500.milliseconds)
    ..add(AniProps.color, Colors.red.tweenTo(Colors.blue), 3.seconds);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: PlayAnimation<MultiTweenValues<AniProps>>(
            tween: _tween, // Pass in tween
            duration: _tween.duration, // Obtain duration from MultiTween
            builder: (context, child, value) {
              return Container(
                width: value.get(AniProps.width), // Get animated value for width
                height: value.get(AniProps.height), // Get animated value for height
                color: value.get(AniProps.color), // Get animated value for color
              );
            },
          ),
        ),
      ),
    );
  }
}

```




## Chained tweens in single animation

This example moves a box clockwise in a rectangular pattern.

![example2](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_multi_tween/v1/multitween-example-2.gif)

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

void main() => runApp(MyApp());

// Create enum that defines the animated properties
enum AniProps { offset }

class MyApp extends StatelessWidget {
  // Specify your tween
  final _tween = MultiTween<AniProps>()
    ..add( // top left => top right
        AniProps.offset,
        Tween(begin: Offset(-100, -100), end: Offset(100, -100)),
        1000.milliseconds)
    ..add( // top right => bottom right
        AniProps.offset,
        Tween(begin: Offset(100, -100), end: Offset(100, 100)),
        1000.milliseconds)
    ..add( // bottom right => bottom left
        AniProps.offset,
        Tween(begin: Offset(100, 100), end: Offset(-100, 100)),
        1000.milliseconds)
    ..add( // bottom left => top left
        AniProps.offset,
        Tween(begin: Offset(-100, 100), end: Offset(-100, -100)),
        1000.milliseconds);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: LoopAnimation<MultiTweenValues<AniProps>>(
            tween: _tween, // Pass in tween
            duration: _tween.duration, // Obtain duration from MultiTween
            builder: (context, child, value) {
              return Transform.translate(
                offset: value.get(AniProps.offset), // Get animated offset
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.green,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

```




## Complex example

This example combines aspects of the examples above, including chaining and multiple properties.

![example3](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_multi_tween/v1/multitween-example-3.gif)

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

void main() => runApp(MyApp());

// Create enum that defines the animated properties
enum AniProps { offset, color }

class MyApp extends StatelessWidget {
  // Specify your tween
  final _tween = MultiTween<AniProps>()
    ..add(
      // top left => top right
        AniProps.offset,
        Tween(begin: Offset(-100, -100), end: Offset(100, -100)),
        1000.milliseconds, Curves.easeInOutSine)
    ..add(
      // top right => bottom right
        AniProps.offset,
        Tween(begin: Offset(100, -100), end: Offset(100, 100)),
        1000.milliseconds, Curves.easeInOutSine)
    ..add(
      // bottom right => bottom left
        AniProps.offset,
        Tween(begin: Offset(100, 100), end: Offset(-100, 100)),
        1000.milliseconds, Curves.easeInOutSine)
    ..add(
      // bottom left => top left
        AniProps.offset,
        Tween(begin: Offset(-100, 100), end: Offset(-100, -100)),
        1000.milliseconds, Curves.easeInOutSine)
    ..add(AniProps.color, Colors.red.tweenTo(Colors.yellow), 1.seconds)
    ..add(AniProps.color, Colors.yellow.tweenTo(Colors.blue), 2.seconds)
    ..add(AniProps.color, Colors.blue.tweenTo(Colors.red), 1.seconds);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: LoopAnimation<MultiTweenValues<AniProps>>(
            tween: _tween, // Pass in tween
            duration: _tween.duration, // Obtain duration from MultiTween
            builder: (context, child, value) {
              return Transform.translate(
                offset: value.get(AniProps.offset), // Get animated offset
                child: Container(
                  width: 100,
                  height: 100,
                  color: value.get(AniProps.color), // Get animated color
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

```






# 🎥 Anicoto

🛈 *Note: These examples uses **[supercharged](https://pub.dev/packages/supercharged)** for syntactic sugar.*

## Basic usage pattern

This example shows a complete app that uses `AnimationMixin` in a simple way.

![example1](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_anicoto/v1/anicoto-1.gif)

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

void main() => runApp(MaterialApp(home: Page()));

class Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Center(child: MyAnimatedWidget())),
    );
  }
}

class MyAnimatedWidget extends StatefulWidget {
  @override
  _MyAnimatedWidgetState createState() => _MyAnimatedWidgetState();
}

class _MyAnimatedWidgetState extends State<MyAnimatedWidget>
    with AnimationMixin {  // Add AnimationMixin to state class

  Animation<double> size; // Declare animation variable

  @override
  void initState() {
    size = 0.0.tweenTo(200.0).animatedBy(controller); // Connect tween and controller and apply to animation variable
    controller.play(); // Start the animation playback
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.value, // Use animation variable's value here 
      height: size.value, // Use animation variable's value here
      color: Colors.red
    );
  }
}
```






## Multiple AnimationController instances

This example uses 3 unique `AnimationController` instances to animate width, height and color independently.

![example1](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_anicoto/v1/anicoto-2.gif)

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

void main() => runApp(MaterialApp(home: Page()));

class Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Center(child: MyAnimatedWidget())),
    );
  }
}

class MyAnimatedWidget extends StatefulWidget {
  @override
  _MyAnimatedWidgetState createState() => _MyAnimatedWidgetState();
}

class _MyAnimatedWidgetState extends State<MyAnimatedWidget>
    with AnimationMixin {
  AnimationController widthController; // <-- declare AnimationController
  AnimationController heightController; // <-- declare AnimationController
  AnimationController colorController; // <-- declare AnimationController

  Animation<double> width; // <-- declare Animation variable
  Animation<double> height; // <-- declare Animation variable
  Animation<Color> color; // <-- declare Animation variable

  @override
  void initState() {
    widthController = createController()..mirror(duration: 5.seconds); // <-- create controller instance and let it mirror animate
    heightController = createController()..mirror(duration: 3.seconds); // <-- create controller instance and let it mirror animate
    colorController = createController()..mirror(duration: 1500.milliseconds); // <-- create controller instance and let it mirror animate

    width = 100.0.tweenTo(200.0).animatedBy(widthController); // <-- connect tween with individual controller
    height = 100.0.tweenTo(200.0).animatedBy(heightController); // <-- connect tween with individual controller
    color = Colors.red.tweenTo(Colors.blue).animatedBy(colorController); // <-- connect tween with individual controller

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width.value, height: height.value, color: color.value); // <-- use animated values
  }
}
```





# 📝 More examples


## TypeWriter

Example animates width of the box, text length and cursor.

![example1](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/simple_animations/v1/sa-1.gif)

[View code](https://github.com/felixblaschke/simple_animations/blob/master/example/lib/examples/typewriter_box.dart)


## Checkbox

Example of an animated custom checkbox.

![example2](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/simple_animations/v1/sa-2.gif)

[View code](https://github.com/felixblaschke/simple_animations/blob/master/example/lib/examples/switchlike_checkbox.dart)



## Waves

Example of sine waves in front of an animated background gradient.

![example3](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/simple_animations/v1/sa-3.gif)

[View code](https://github.com/felixblaschke/simple_animations/blob/master/example/lib/examples/fancy_background.dart)




## Widgets fade-in

Example of delayed fade-in of widgets.

![example4](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/simple_animations/v1/sa-4.gif)

[View code](https://github.com/felixblaschke/simple_animations/blob/master/example/lib/examples/fade_in_ui.dart)



## Bubbles

Example of a bubble particle system.

![example5](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/simple_animations/v1/sa-5.gif)

[View code](https://github.com/felixblaschke/simple_animations/blob/master/example/lib/examples/particle_background.dart)




## Bar charts

Example of animated bar charts.

![example6](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/simple_animations/v1/sa-6.gif)

[View code](https://github.com/felixblaschke/simple_animations/blob/master/example/lib/examples/bar_chart.dart)




## Particle explosion

Example of a particle explosion upon user interaction.

![example7](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/simple_animations/v1/sa-7.gif)

[View code](https://github.com/felixblaschke/simple_animations/blob/master/example/lib/examples/hit_a_mole.dart)



## Loading animation

Example of a custom loading animation that waits for a http request.

![example6](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/simple_animations/v1/sa-8.gif)

[View code](https://github.com/felixblaschke/simple_animations/blob/master/example/lib/examples/acx_progress_indicator.dart)


