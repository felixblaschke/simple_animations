import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Builder function used by widgets to update your
/// scene when animating.
///
/// It has the pattern context, child and value.
///
/// [context] is your Flutter [BuildContext].
///
/// [child] is any widget that is not effected by the
/// animation. Flutter doesn't need to rebuild that
/// widget when the animation updates. This way you can
/// improve the performance of your animation.
///
/// [value] is current value of your animated property.
typedef AnimatedWidgetBuilder<T> = Widget Function(
    BuildContext context, Widget? child, T value);
