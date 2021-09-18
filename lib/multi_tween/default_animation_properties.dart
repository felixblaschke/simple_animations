/// Enum for use as type of [MultiTween]. It contains common used property
/// names.
/// Example: (using [supercharged](https://pub.dev/packages/supercharged))
/// ```dart
/// final tween = MultiTween<DefaultAnimationProperties>()
///   ..add(DefaultAnimationProperties.width, 0.0.tweenTo(100.0), 1.seconds)
///   ..add(DefaultAnimationProperties.height, 0.0.tweenTo(200.0), 1.seconds);
/// ```
enum DefaultAnimationProperties {
  width,
  height,
  offset,
  color,
  color1,
  color2,
  color3,
  color4,
  x,
  y,
  size,
  left,
  top,
  bottom,
  right,
  rotation,
  scale
}
