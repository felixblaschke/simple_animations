## Timeline Tween guide

Timeline Tween is a **powerful** `Animateable` that animates multiple properties at once.

### Basic usage pattern

Create an `enum` outside your widget class. It contains all properties you want to animate. _(For example: width, height or color)_

@code tool/templates/code/timeline_tween/basic1.dart

Then you create a `TimelineTween` by instancing it with the `enum` you created in the first step.

@code tool/templates/code/timeline_tween/basic2.dart

Use `addScene()` to add a new scene to the tween. A scene represents a span of time when certain properties will tween.

@code tool/templates/code/timeline_tween/basic3.dart

On the `scene` object you can use `animate()` to specify your tweens.

@code tool/templates/code/timeline_tween/basic4.dart

The `animate()` method returns its parent `scene` object. You can use this to specify a scene in a builder style. Here is the same scene:

@code tool/templates/code/timeline_tween/basic_builder.dart

Use the created tween with your favorite animation technique. Here we use the `PlayAnimation`:

@code tool/templates/code/timeline_tween/play_animation_example.dart

`TimelineTween<PropType>` animates to `TimelineValue<PropType>` that offers you a `get()` method that can be used to obtain the single animated values.

### Scenes

A Timeline Tween can consist of multiple scenes with each scene having multiple tweened properties.

#### Absolute scenes

The most simple way to add a scene is to call `tween.addScene()`. It requires you to define two of these three parameters:

- begin (start time of the scene)
- duration (relative duration of the scene)
- end (end time of the scene)

You can freely combine begin/duration, begin/end or duration/end.

@code tool/templates/code/timeline_tween/scenes_absolute.dart

#### Relative scenes

While absolute scenes are easy to understand, they have one drawback. Each tuning in timings requires you to touch all `begin` durations.

To avoid this you can work with relative scenes by calling `addSubsequentScene()` on a created scene.

@code tool/templates/code/timeline_tween/scenes_relative.dart

Subsequent scenes start right after their predecessor.
The relative nature of subsequent scenes require you to pass in a `duration`. Optionally you can add some `delay`.

#### Scene naming and code style

More complex animations will quickly blow up your code and get confusing. I recommend using variables with an expressive name for each scene. Use an extra function that will create your tween.

Here is my best practise:

@code tool/templates/code/timeline_tween/naming.dart

### Animate properties

Use the scene's `animate()` method to specify tweens for each property.

@code tool/templates/code/timeline_tween/animate1.dart

Optionally you can specify `shiftBegin` or `shiftEnd` to further tune each property's timing.

@code tool/templates/code/timeline_tween/animate2.dart

### Curves

Timeline Tween offers you to customize the easing curve on three levels. By default, it uses a linear timing function.

#### Property-level curves

The scene's `animate()` method allows you to specify a custom curve by setting the `curve` parameter.

@code tool/templates/code/timeline_tween/curve1.dart

If there is no `curve` specified, it will take the curve defined by the scene.

#### Scene-level curves

The `addScene()` and `addSubsequentScene()` methods allow you to specify a custom `curve` parameter, that will be used for all properties, unless they have own property-level curve defined.

@code tool/templates/code/timeline_tween/curve2.dart

If there is no `curve` specified, it will take the curve defined by the tween.

#### Tween-level curves

The constructor `TimelineTween<Prop>(...)` takes an optional parameter `curve`, that will be used for all scenes, unless they have own scene-level curves defined.

@code tool/templates/code/timeline_tween/curve3.dart

If there is no `curve` specified, it will use `Curves.linear`.

### Extrapolation

Timeline Tween extrapolates all values that are defined in scenes but get used outside those time spans.

Look at this example:

@code tool/templates/code/timeline_tween/extrapolation.dart

This tween specifies two scenes tweening `width` from 1 - 2 seconds and `height` from 3 - 4 seconds. The tween ends after 4 seconds.

If we use this tween inside an animation, starting with 0 seconds, both `width` and `height` gets extrapolated to the values `100.0` for `width` and `400.0` for `height`. At 1.5 seconds the `width` is in the middle of the tweening, while `height` stays at `400.0`.

This behavior feels natural and will help you to define complex custom animations.

### Use developer tools

Defining complex tweens can be time-consuming when watching the same animation over and over again.

Simple Animations offers the [Animation Developer Tools](animation_developer_tools.md) to simplify that process.

### Using the predefined enum for animation properties

It's always good to create your own `enum` that contain the precise animation properties the animation uses.
But we developers are sometimes lazy.

If you feel lazy can also use the `Prop` enum that contains a variety of common used animation properties:

@code tool/templates/code/timeline_tween/predefined_enum.dart

### Animation duration

#### Duration tracking

The `TimelineTween` is technically an `Animateable`. `Animateable`s only contain changes over a relative time span ranging from `0.0` to `1.0`.

In addition to that `TimelineTween` tracks the absolute time specified via scenes. Use the `duration` property to access the absolute duration.

@code tool/templates/code/timeline_tween/duration1.dart

_Hint: You can also multiply the tracked duration with a numeric factor in order to speed up or slow down an animation._

#### Use own durations

You also use your own `Duration`. Timeline Tween will automatically lengthen or shorten the tween animation.

@code tool/templates/code/timeline_tween/duration2.dart
