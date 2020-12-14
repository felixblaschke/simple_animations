# 🎬 Simple Animations

[![Awesome Flutter](https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square)](https://github.com/Solido/awesome-flutter)
[![Pub](https://img.shields.io/pub/v/simple_animations.svg)](https://pub.dartlang.org/packages/simple_animations)


**Simple Animations** is a powerful package to create beautiful custom animations in no time.

- 💪 **fully tested**
- 📝 **well documented**
- 💼 **enterprise-ready**


## 🌞 Highlights

- Easily create **custom animations in stateless widgets**
- Animate **multiple properties** at once
- Create **staggered animations** within seconds
- Simplified working with **AnimationController** instances

## ⛏️ Getting started

Add **Simple Animations** to your project by following the instructions on the 
**[install page](https://pub.dev/packages/simple_animations/install)**.

It contains multiple features. Each covers a different aspect of making animation very simple.

| Feature | Description |
| --- | ----------- |
| 🍹&nbsp;[Liquid](#-liquid-documentation) | Beautiful visual animations that increases the visual quality of your app. |
| 🚀&nbsp;[Stateless&nbsp;Animation](#-stateless-animation-documentation) | Widgets for super simple creation of custom animations. |
| 🎭&nbsp;[MultiTween](#-multitween-documentation) | Animate multiple properties at once or create staggered animations. |
| 🎥&nbsp;[Anicoto](#-anicoto-documentation) | Setup managed AnimationControllers instantly. |

---

💡 *Note: These examples uses **[supercharged](https://pub.dev/packages/supercharged)** for syntactic sugar.*

---

### 🍹 Liquid

Liquid provides ready-to-use, stunning visual animations that can be explored and configured with **[Liquid Studio](https://felixblaschke.github.io/liquid-studio)**.

![plasma](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_liquid/plasma-example.gif)

---

### 🚀 Stateless Animation

Stateless Animation provides a powerful set of Flutter widgets that hide the most complex part of creating animations.

*Example: Square with a animated, fading background color.*

```dart
PlayAnimation<Color>( // <-- specify type of animated variable
  tween: Colors.red.tweenTo(Colors.blue), // <-- define tween
  builder: (context, child, value) { // <-- builder function
    return Container(
        color: value, // <-- use animated value
        width: 100, 
        height: 100
    );
});
```

[**Read more about it**](docs/stateless_animation.md) or [**watch examples**](example/stateless_animation.md).

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

[**Read more about it**](docs/multi_tween.md) or [**watch examples**](example/multi_tween.md)

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

[**Read more about it**](docs/anicoto.md) or [**watch examples**](example/anicoto.md).

---

## 📈 Improve

Simple Animations will **improve** in future updates. Help me by reporting bugs, **submit new ideas** for features or anything else that you want to share.

- Just [write an issue](https://github.com/felixblaschke/simple_animations/issues) on GitHub. ✏️
- And don't forget to hit the **like button** for this package ✌️

