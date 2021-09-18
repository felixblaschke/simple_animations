# 🎬 Simple Animations

[![Awesome Flutter](https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square)](https://github.com/Solido/awesome-flutter)
[![Pub](https://img.shields.io/pub/v/simple_animations.svg)](https://pub.dartlang.org/packages/simple_animations)

**Simple Animations** is a powerful package to create beautiful custom animations in no time.

- 💪 **fully tested**
- 📝 **well documented**
- 💼 **enterprise-ready**

**Highlights**

- Easily create **custom animations in stateless widgets**
- Animate **multiple properties** at once
- Create **staggered animations** within seconds
- Simplified working with **AnimationController** instances
- Debug animations

@index

## Overview

Simple Animation consists of severals feature, that work alone or in synergy.

### Stateless Animation

Stateless Animation provides a powerful set of Flutter widgets that hide the most complex part of creating animations.

**Example**: Square with an animated background color.

@code tool/templates/code/readme/stateless_animation.dart

[**Read guide**](#stateless-animation-guide) or [**watch examples**](example/example.md#stateless-animation).

---

### Timeline Tween

Timeline Tween is a mighty tool that enables you to tween multiple
properties _or_ designing staggered animations in a single `Animatable`.

**Example**: Custom tween with multiple properties.

@code tool/templates/code/readme/timeline_tween.dart

[**Read guide**](#timeline-tween-guide) or [**watch examples**](example/example.md#timeline-tween).

---

### Anicoto

Anicoto fully manages your AnimationController instances and handles initialization, configuration and disposing. No
more boilerplate code.

**Example**: Animated stateful widget with full-fledged AnimationController instance.

@code tool/templates/code/readme/anicoto.dart

[**Read guide**](#anicoto-guide) or [**watch examples**](example/example.md#anicoto).

---

### Animation Developer Tools

Tired of watching the same animation over and over again, in order to fine tune it?

![devtools](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/v2/devtools.gif)

The Animation Developer Tools allows you pause anywhere, scroll around, speed up, slow down or focus on a certain
interval of the animation.

[**Read guide**](#animation-developer-tools-guide)

---

@include tool/templates/doc/stateless_animation.md
@include tool/templates/doc/timeline_tween.md
@include tool/templates/doc/anicoto.md
@include tool/templates/doc/animation_developer_tools.md
