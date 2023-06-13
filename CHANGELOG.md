## 5.0.2

- Added compatibility with Flutter `3.12.0`

## 5.0.1

- More robust implementation for `CustomAnimationBuilder` with `delay`.

## 5.0.0+3

- Added funding section

## 5.0.0+2

- Readme path fixes

## 5.0.0

If you come from 4.x, please look at [migration kit package for 4.x to 5.x upgrade](https://pub.dev/packages/sa4_migration_kit) for detailed description of breaking changes. That package also contain all original classes from 4.x to simplify the upgrade.

- **New:** MovieTween (replaces MultiTween and TimelineTween)
- **Update:** Reworked the documentation
- **Breaking changes:** Builder classes got API changes to be closer to Flutter conventions. Old classes and behavior are still available via [migration kit package](https://pub.dev/packages/sa4_migration_kit).
- **Breaking changes:** Dropped TimelineTween. TimelineTween is still available via [migration kit package](https://pub.dev/packages/sa4_migration_kit).
- **Breaking changes:** Dropped MultiTween. MultiTween is still available via [migration kit package](https://pub.dev/packages/sa4_migration_kit).

---

## 4.1.0

- **Update:** Code base is now compliant to Flutter `3.0.0`
- **Update:** Dependencies

## 4.0.2

- **Update:** `flutter_lints` is now listed as `dev_dependencies` within `pubspec.yaml`.

## 4.0.1

- **Fix:** Increase Dart minimum SDK version to `2.14.0` because of used `unawaited` method.

## 4.0.0

- **New:** Added lifecycle callbacks `onStart` and `onComplete` for `PlayAnimation` and `CustomAnimation` widgets.
- **Breaking change:** The liquid feature has been separated into an own package [sa3_liquid](https://pub.dev/packages/sa3_liquid).
- **Breaking change:** Removed deprecated uppercase variants of `CustomAnimationControl` enum. Use the lower case ones.
- **Update:** Removed supercharged dependency
- **Update:** Removed supercharged usage from documentation
- **Update:** Restructured documentation

---

## 3.2.0

- **Update**: Adapt code and examples to modern Dart style guide.
- **Update**: Use `flutter_lints` instead of `pedantic`

## 3.1.1

- **Fix:** README file issue

## 3.1.0

- **Update:** Reworked and improved documentation
- **Update:** Adapted `CustomAnimationControl` enum style guide. The values in "SCREAMING_CAPS" are deprecated now.

## 3.0.3

- **Fix:** Analyzer issue

## 3.0.2

- **Fix:** Exception in SKIA web if effective blur radius is `0` (`PlasmaRenderer`)

## 3.0.1

- **Fix:** Rendering size / position of atlas-based particle rendering

## 3.0.0

- **New:** Simple Animations is sound null-safe (Flutter 2.0)
- **New:** Atlas-based particle rendering mode for `PlasmaRenderer`
- **Update:** Optimization of `TimelineTween` computations
- **Breaking:** Remove widgets that got deprecated with version `2.x.x`

---

## 2.5.1

- **Fix:** Added missing type annotations to `TimelineTween`

## 2.5.0

- **New:** PlasmaRenderer
- **New:** Timeline Tween
- **New:** Animation Developer Tools
- **Update:** Reorganized documentation
- **Deprecation:** Plasma (replaced by PlasmaRenderer)

## 2.4.2

- **Fix:** Link in `README.md`

## 2.4.1

- **Update:** Dependencies
- **Fix:** Homepage url in `pubspec.yaml`

## 2.4.0

- **Update:** Merged module packages into a single `simple_animations` package

## 2.3.1

- **Fix:** Liquid - Plasma: added fix for render issue in web builds (#45)

## 2.3.0

- **New:** Added new module **Liquid** along with **[Liquid Studio](https://felixblaschke.github.io/liquid-studio)**
- **New:** FPS-Limiter for **Anicoto** and **Stateless Animation**

## 2.2.3

- **New:** Added accessor `getOrElse()` for the `MultiTweenValues` class

## 2.2.2

- **Update:** Migrated to new pub.dev page structure
- **Update:** Upgraded dependencies
- **Fix:** removed directory with old / outdated documentation

## 2.2.1

- **Update:** dependencies
- **Update:** enforce stricter type rules
- **Update:** upgraded to pedantic rule set 1.9.0

## 2.2.0

- **New:** MultiTween `add` method now uses `Animatable` instead of `Tween`.

## 2.1.1

- **Fix:** critical typo in readme (dependency name)

## 2.1.0

- **New:** integrated all classes from version 1. They are all marked as deprecated.

## 2.0.2

- **Fix:** typo in README documentation

## 2.0.1

- **Fix:** pub.dev dart analyzer issues

## 2.0.0

- **New:** Simple Animation has been reworked with version `2.0.0`.

- **New:** Added module [Stateless Animation](https://pub.dev/packages/sa_animation_builder)
- **New:** Added module [Multi Tween](https://pub.dev/packages/sa_multi_tween)
- **New:** Added module [Anicoto](https://pub.dev/packages/sa_anicoto)
- **Breaking changes:** See [migration guide](https://pub.dev/packages/sa_v1_migration)

---

## 1.3.12

- Fixed bug when updating `curve` parameter in `ControlledAnimation`

## 1.3.11

- Integrated example from pub example page into example_app

## 1.3.10

- App example is now fully integrated into package example
- Updated all documentation references to the app example

## 1.3.9

- Fixed Flutter health suggestions
- Updated links to example app

## 1.3.8

- Integrated app example into main repository:
  - `example/example_app`

## 1.3.7

- This release contains fixes requested by the Flutter Ecosystem Committee:
  - Added API documentation and improved test coverage
  - Accidentally public method `LoopTask.finishIteration(Duration)` is now private.
    Instead you can use public APIs of `AnimationControllerX` to control the tasks.
  - Accidentally public method `AnimationControllerX.completeCurrentTask()` is now private.
    Instead you can use `AnimationControllerX.forceCompleteCurrentTask()`.

## 1.3.6

- Fixed bug in type generics

## 1.3.5

- Preparations for avoiding implicit casting

## 1.3.4

- Fixed documentation: missing line about manual creation of AnimationControllerX

## 1.3.1 - 1.3.3

- Upgraded to Flutter 1.7 and Dart 2.4

## 1.3.0

- Upgraded to Flutter 1.5 and Dart 2.3

### New features

- `AnimationControllerX` a new, powerful AnimationController
- `AnimationControllerMixin` to easily setup AnimationControllerX
- 5 types of `AnimationTask`s to use for AnimationControllerX

## 1.2.0

### New features

- `Rendering` a widget for building of continuous animations
- `AnimationProgress` a utility class that helps you with `Duration`-based
  Animations

## 1.1.1

- Fixed strange effect when rebuilding a `ControlledAnimation` with `playback` set to
  `Playback.MIRROR`

## 1.1.0

### New features

- New property `startPosition` for `ControlledAnimation` widget:
  you can now specify the initial start position (time) of the animation.
  This is useful for designing interactive UI elements.

## 1.0.0

- Initial release

### New features

- `ControlledAnimation`: Widget for simple tween-based custom animations
- `MultiTrackTween`: Animatable for tweening multiple properties at once

## 0.x

- Setting up the project
