/// Enum for use as type of [TimelineTween]. It contains common used property
/// names.
///
/// Example: (using [supercharged](https://pub.dev/packages/supercharged))
/// ```dart
/// final tween = TimelineTween<Prop>()
///   ..addScene(begin: 0.milliseconds, duration: 500.milliseconds)
///       .animate(Prop.width, tween: 0.0.tweenTo(400.0))
///       .animate(Prop.height, tween: 500.0.tweenTo(200.0));
/// ```
enum Prop {
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
  z,
  i,
  j,
  size,
  left,
  top,
  bottom,
  right,
  translate,
  translateX,
  translateY,
  rotate,
  rotateX,
  rotateY,
  rotateZ,
  scale,
  scaleX,
  scaleY,
  radius,
  opacity,
}
