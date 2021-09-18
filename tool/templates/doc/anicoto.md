## Anicoto guide

Anicoto (**Ani**mation**Con**troller **to**olkit) enriches your developing expierience with Flutter's AnimationController.

### Basic usage pattern

With Anicoto you can simply add an `AnimationController` just by adding `AnimationMixin` to your stateful widget.

@code tool/templates/code/anicoto/basic.dart

💪 The `AnimationMixin` generates a preconfigured AnimationController as `controller`. You can just use it. No need to worry about initialization or disposing.

### Shortcuts for AnimationController

Anicoto enriches the `AnimationController` with four convenience functions:

- `controller.play()` plays animation and stops at the end.

- `controller.playReverse()` plays animation reversed and stops at the start.

- `controller.loop()` repeatly plays the animation from start to the end.

- `controller.mirror()` repeatly plays the animation forward, then backwards, then forward and so on.

Each of these methods take an optional `duration` named parameter to configure your animation action within one line of code.

@code tool/templates/code/anicoto/shortcuts.dart

You can use these methods nicely along the already existing `controller.stop()` and `controller.reset()` methods.

### Create multiple AnimationController

With multiple AnimationController you can have many parallel animations at the same time.

Anicoto's `AnimationMixin` enhances your **state class** with a method `createController()` to create multiple **managed\*** AnimationController. _("Managed" means that you don't need to care about initialization and disposing.)_

#### Create a managed AnimationController

First create a class variable of type `AnimationController`. Then inside the `initState() {...}` method call `createController()`. That's all.

@code tool/templates/code/anicoto/managed1.dart

#### Create many managed AnimationController

Anicoto allows you to have as many AnimationController you want. Behind the scenes it keeps track of them.

@code tool/templates/code/anicoto/managed2.dart
