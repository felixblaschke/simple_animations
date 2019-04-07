# Simple Animations

[![Build status](https://dev.azure.com/felix0418/Simple%20Animations/_apis/build/status/CI%20Testing)](https://dev.azure.com/felix0418/Simple%20Animations/_build/latest?definitionId=1)
[![Pub](https://img.shields.io/pub/v/simple_animations.svg)](https://pub.dartlang.org/packages/simple_animations)

Simple Animations is a package for Flutter to boost your animation
productivity by simplifying the way to create animations.

## Project goal

Flutter has a strong and flexible foundation of animation capabilities.

But even small animations feel **verbose** and **blow up** your code base. 
**Animations** are one of the **most desired aspects** of Flutter, while being 
difficult to master.

**Simple Animation**'s goal is to solve this issue, by

- **simplifying** the way to creates **custom animations**,
- softly dipping developers into the animation topic,
- offering a lot of **documentation** and **examples**.

## Getting started

There are multiple ways to get started:

- [Dive into the documentation](https://github.com/felixblaschke/simple_animations/blob/master/documentation/README.md)
- [Try the Example App of *simple_animations*](https://github.com/felixblaschke/simple_animations_example_app)
- Read articles and tutorials about using *simple_animations* (coming soon)

## Examples

### Typewriter Box


This custom animation seems simple but it's rather complex:

![hello-flutter-example](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/examples/hello-flutter.gif)

It's *combining* a **staggered animation sequence** with an **enduring animation**:

- *At the beginning* it animates the **height** of a box. After that it increases the **width**.
- *While increasing the width* a typewriter-like **animated underscore** appears and persists.
- *Shortly before the width reaches it's final size*, it starts to **type-write a text**.

*With traditional Flutter animation classes this will end in a huge 
StatefulWidget with multiple AnimationController, Tweens and all that 
initState and onDispose overhead.*

With **simple_animation** you can do it **stateless** just by using
some fancy **ControlledAnimation** widgets.

The whole animation just takes about **60 lines of code** while 
maintaining **readability**. *(You can find the [source code here](https://github.com/felixblaschke/simple_animations_example_app/blob/master/lib/examples/typewriter_box.dart). 
I only counted the lines that are responsible for the animation.)*


### Pub Example Tab

This is the example from the [example page (pub.dartlang.org)](https://pub.dartlang.org/packages/simple_animations#-example-tab-):

![pub-example-tab](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/examples/pub-example.gif)
