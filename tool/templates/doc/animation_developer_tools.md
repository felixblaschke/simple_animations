## Animation Developer Tools guide

The Animation Developer Tools allow you to create or review your animation step by step.

### Basic usage pattern

Wrap your UI with the `AnimationDeveloperTools` widget.

@code tool/templates/code/animation_developer_tools/intro.dart

Enable developer mode on the animation you want to debug.

#### Using stateless animation widgets

Stateless animation widgets like

- `PlayAnimation`
- `LoopAnimation`
- `MirrorAnimation`
- `CustomAnimation`

have a constructor parameter `developerMode` that can be set to `true`. It will connect to the closest `AnimationDeveloperTools` widget.

**Example**
@code tool/templates/code/animation_developer_tools/stateless_animation.dart

![devtools](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/v2/devtools.gif)

#### Using Anicoto AnimationMixin

If your stateful widget uses `AnimationMixin` to manage your instances of `AnimationController` you can call `enableDeveloperMode()` to connect to the clostest `AnimationDeveloperMode` widget.

**Example**
@code tool/templates/code/animation_developer_tools/anicoto.dart

### Features and tricks

The Animation Developer Tools come with several features that simplify your developer life:

- Regardless of the real animation, with developer mode activated the animation will always loop.
- You can use Flutter hot reloading for editing and debugging if your tween is created stateless.
- Use the slider to edit the animated scene while pausing.
- You can slow down the animation to look out for certain details.
- Use the interval buttons to focus on a time span of the animation.
