# 🎬 Simple Animations ❷

[![Awesome Flutter](https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square)](https://github.com/Solido/awesome-flutter)
[![Pub](https://img.shields.io/pub/v/simple_animations.svg)](https://pub.dartlang.org/packages/simple_animations)


**Simple Animations** is a powerful framework to create beautiful custom animations in no time.

- 💪 **fully tested**
- 📝 **well documented**
- 💼 **enterprise-ready**


## 🌞 Highlights

- Easily create **custom animations in stateless widgets**
- Animate **multiple properties** at once
- Create **staggered animations** within seconds
- Simplified working with **AnimationController** instances
- Designed with **type-safety** in mind

## ⛏️ Getting started

Add the dependency `simple_animation: ^2.0.0` to your project and start using it:
```dart
import 'package:simple_animations/simple_animations.dart';
```

For more details have a look at the [install tab](https://pub.dev/packages/simple_animations#-installing-tab-).

🛈 *If are upgrading from version `1.x.x` read the [**migration guide**](https://pub.dev/packages/sa_v1_migration).*


## Modules

Simple Animations constists of multiple modules that are provided by this Flutter package. You can also use them separately.

### Overview

| Module | Description |
| --- | ----------- |
| 🚀&nbsp;[Stateless&nbsp;Animation](https://pub.dev/packages/sa_stateless_animation) | Widgets for super simple creating custom animations. |
| 🎭&nbsp;[MultiTween](https://pub.dev/packages/sa_multi_tween) | Animate multiple properties at once or create staggered animations. |
| 🎥&nbsp;[Anicoto](https://pub.dev/packages/sa_anicoto) | Setup managed AnimationControllers instantly. |

Click on a module name to read it's documentation and to see examples.

---

🛈 *Note: These examples uses **[supercharged](https://pub.dev/packages/supercharged)** for syntactic sugar.*

---

### 🚀 Stateful Animation

Stateful Animation provides your app with a powerful set of Flutter widgets that hide the most complex part of creating animations.

*Example: Square with a animated, fading background color.*

```dart
PlayAnimation<Color>( // <-- specify type of animated variable
  tween: Colors.red.tweenTo(Colors.blue), // <-- define tween of colors
  builder: (context, child, value) { // <-- builder function
    return Container(
        color: value, // <-- use animated value
        width: 100, 
        height: 100
    );
});
```

[**Read more about it**](https://pub.dev/packages/sa_stateless_animation) or [**watch examples**](https://pub.dev/packages/sa_stateless_animation#-example-tab-).

---

### 🎭 MultiTween


MultiTween gives is mighty tool thats enables you to tween multiple properties in a single `Animatable` or designing staggered animations.

*Example: Custom tween with multiple properties.*

```dart
enum AniProps { width, height, color } // <-- define properties

class MyWidget extends StatelessWidget {

  final _tween = MultiTween<AniProps>() // <-- design tween
    ..add(AniProps.width, 0.0.tweenTo(400.0), 1000.milliseconds)
    ..add(AniProps.width, 400.0.tweenTo(300.0), 1000.milliseconds)
    ..add(AniProps.height, 500.0.tweenTo(200.0), 2000.milliseconds)
    ..add(AniProps.color, Colors.red.tweenTo(Colors.blue), 2.seconds);

  @override
  Widget build(BuildContext context) {
    return ... // <-- use tween
  }
}
```

[**Read more about it**](https://pub.dev/packages/sa_multi_tween) or [**watch examples**](https://pub.dev/packages/sa_multi_tween#-example-tab-).

---

### 🎥 Anicoto

Anicoto fully manages your AnimationController instances and handles initialization, configuration and disposing. No more boilerplate code.

*Example: Animated stateful widget with full-fledged AnimationController instance.*

```dart
class _MyAnimatedWidgetState extends State<MyAnimatedWidget>
    with AnimationMixin {  // <-- add AnimationMixin to state class

  Animation<double> size; // <-- declare animation variable

  @override
  void initState() {
    size = 0.0.tweenTo(200.0).animatedBy(controller); // <-- connect tween and controller and apply to animation variable
    controller.play(); // <-- start the animation playback
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.value, // <-- use animation variable's value here 
      height: size.value, // <-- use animation variable's value here
      color: Colors.red
    );
  }
}
```

[**Read more about it**](https://pub.dev/packages/sa_anicoto) or [**watch examples**](https://pub.dev/packages/sa_anicoto#-example-tab-).

---


## 👓 Project overview

| Module | Tests | Repository | Pub |
| --- | --- | --- | --- |
| Stateful Animation | [![Tests](https://github.com/felixblaschke/sa_stateless_animation/workflows/Tests/badge.svg)](https://github.com/felixblaschke/sa_stateless_animation/actions?query=workflow%3ATests) | [Github](https://github.com/felixblaschke/sa_stateless_animation) | [![Pub](https://img.shields.io/pub/v/sa_stateless_animation.svg)](https://pub.dartlang.org/packages/sa_stateless_animation) |
| MultiTween | [![Tests](https://github.com/felixblaschke/sa_multi_tween/workflows/Tests/badge.svg)](https://github.com/felixblaschke/sa_multi_tween/actions?query=workflow%3ATests) | [Github](https://github.com/felixblaschke/sa_multi_tween) | [![Pub](https://img.shields.io/pub/v/sa_multi_tween.svg)](https://pub.dartlang.org/packages/sa_multi_tween) |
| Anicoto | [![Tests](https://github.com/felixblaschke/sa_anicoto/workflows/Tests/badge.svg)](https://github.com/felixblaschke/sa_anicoto/actions?query=workflow%3ATests) | [Github](https://github.com/felixblaschke/sa_anicoto) | [![Pub](https://img.shields.io/pub/v/sa_anicoto.svg)](https://pub.dartlang.org/packages/sa_anicoto) |

## 📈 Improve

Simple Animations will **improve** in future updates. Help me by reporting bugs, **submit new ideas** for features or anything else that you want to share.

- Just [write an issue](https://github.com/felixblaschke/simple_animations/issues) on GitHub. ✏️
- And don't forget to hit the **like button** for this package ✌️
