import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// Animatable that animates multiple properties at once.
/// It can also chain multiples [Tween]s for a property.
///
/// Example: (using [supercharged](https://pub.dev/packages/supercharged))
/// ```dart
/// // Define your animation properties somewhere
/// enum AniProps { width, height, color }
///
/// // Create MultiTween based on your enum
/// final tween = MultiTween<AniProps>()
///   ..add(AniProps.width, 0.0.tweenTo(100.0), 1000.milliseconds)
///   ..add(AniProps.width, 100.0.tweenTo(200.0), 500.milliseconds)
///   ..add(AniProps.height, 0.0.tweenTo(200.0), 2500.milliseconds)
///   ..add(AniProps.color, Colors.red.tweenTo(Colors.blue), 3.seconds);
/// ```
/// For details on the `add` method: [MultiTween.add].
///
/// If you don't want to define your own enum, you can use
/// [DefaultAnimationProperties] that comes with MultiTween.
class MultiTween<P> extends Animatable<MultiTweenValues<P>> {
  final _tracks = <P, _TweenTrack>{};

  /// Returns the maximum duration of all properties.
  ///
  /// Example: (using [supercharged](https://pub.dev/packages/supercharged))
  /// ```dart
  /// final tween = MultiTween<DefaultAnimationProperties>()
  ///   ..add(DefaultAnimationProperties.width, 0.0.tweenTo(100.0), 1.seconds)
  ///   ..add(DefaultAnimationProperties.width, 100.0.tweenTo(200.0), 2.seconds)
  ///   ..add(DefaultAnimationProperties.height, 0.0.tweenTo(200.0), 5.seconds);
  ///
  /// tween.duration; // 5.seconds
  /// ```
  Duration get duration =>
      _tracks.values
          .map((track) => track.duration)
          .sorted((a, b) => a.compareTo(b))
          .lastOrNull ??
      Duration.zero;

  /// Adds a new tweening task for a specified [property].
  ///
  /// The [property] must relate to an `enum` value specified when creating the
  /// [MultiTween].
  ///
  /// Example: (using [supercharged](https://pub.dev/packages/supercharged))
  /// ```dart
  /// enum MyAniPropsEnum { width, height }
  ///
  /// final tween = MultiTween<MyAniPropsEnum>()
  ///   ..add(MyAniPropsEnum.width, 0.0.tweenTo(100.0), 1.seconds)
  ///   ..add(MyAniPropsEnum.height, 0.0.tweenTo(200.0), 1.seconds);
  /// ```
  ///
  /// This method also takes a [Tween] as the second parameter [tween].
  /// Examples for tweens are `Tween<double>`, `IntTween` or `ColorTween`.
  ///
  /// The third parameter is an optional [duration] which is by default 1 second.
  /// It's useful to arrange to animation of multiple properties.
  /// You can also get the total duration of specified duration via
  /// [MultiTween.duration].
  ///
  /// The fourth parameter is an also optional [curve] which is by default
  /// a linear curve. Flutter offers predefined curves inside
  /// the [Curves] class. Curves make your animation more interesting.
  ///
  /// Example with curve: (using [supercharged](https://pub.dev/packages/supercharged))
  /// ```dart
  /// final tween = MultiTween<DefaultAnimationProperties>()
  ///  ..add(DefaultAnimationProperties.width, 0.0.tweenTo(100.0), 1000.milliseconds)
  ///  ..add(
  ///      DefaultAnimationProperties.width, 100.0.tweenTo(200.0), 500.milliseconds, Curves.easeOut)
  ///  ..add(DefaultAnimationProperties.height, 0.0.tweenTo(200.0), 2500.milliseconds)
  ///  ..add(DefaultAnimationProperties.color, Colors.red.tweenTo(Colors.blue), 3.seconds,
  ///      Curves.easeInOutSine);
  /// ```
  void add(P property, Animatable tween,
      [Duration duration = const Duration(seconds: 1),
      Curve curve = Curves.linear]) {
    if (!_tracks.containsKey(property)) {
      _tracks[property] = _TweenTrack();
    }

    _tracks[property]!.add(tween.chain(CurveTween(curve: curve)), duration);
  }

  /// Returns a [MultiTweenValues] that is used to get the animated values.
  @override
  MultiTweenValues<P> transform(double t) =>
      MultiTweenValues<P>(duration, _tracks, t);
}

/// Represents the result of a MultiTween processed by an animation.
///
/// You don't need to create it yourself. It gets created by
/// [MultiTween.transform] according to Flutter's animation process.
///
/// See [MultiTweenValues.get] to get the animated values.
class MultiTweenValues<P> {
  final Duration _maxDuration;
  final Map<P, _TweenTrack> _tracks;
  final double time;

  /// You don't need to construct this class yourself.
  /// It's the result of animating a [MultiTween].
  MultiTweenValues(this._maxDuration, this._tracks, this.time);

  /// Returns the animated value for a specified [property] regarding the
  /// current position (in time) of the animation.
  ///
  /// The property needs to align with the enum type you defined when creating
  /// the [MultiTween].
  ///
  /// Example: (using [supercharged](https://pub.dev/packages/supercharged))
  /// ```dart
  /// // Tween created somewhere in your code
  /// final tween = MultiTween<DefaultAnimationProperties>()
  ///  ..add(DefaultAnimationProperties.width, 0.0.tweenTo(100.0), 2.seconds);
  ///
  /// /* ... */
  ///
  /// // Access the values in your animation
  /// var width = values.get(DefaultAnimationProperties.width);
  /// ```
  ///
  /// You can also add the value type to increase type soundness by applying
  /// a type hint:
  /// ```dart
  /// values.get<double>(DefaultAnimationProperties.width);
  /// ```
  ///
  /// If the property doesn't exist it will throw an assertion exception.
  T get<T>(P property) {
    assert(_tracks.containsKey(property),
        "Property '${property.toString()}' does not exists.");

    return _computeValue(property)!;
  }

  /// Returns the animated value for a specified [property] regarding the
  /// current position (in time) of the animation, similar to [get].
  ///
  /// If the property is not defined inside the [MultiTween] it will return
  /// the specified [defaultValue].
  T getOrElse<T>(P property, T defaultValue) {
    // ignore: omit_local_variable_types
    T? value =
        _tracks.containsKey(property) ? _computeValue(property) : defaultValue;

    if (value == null) {
      return defaultValue;
    }

    return value;
  }

  T? _computeValue<T>(P property) {
    var timeWhenTweenStarts = 0.0;
    final track = _tracks[property];

    if (track == null) {
      return null;
    }

    for (var tweenWithDuration in track.tweensWithDuration) {
      final tweenDurationInTimeDecimals =
          tweenWithDuration.duration.inMicroseconds.toDouble() /
              _maxDuration.inMicroseconds.toDouble();

      // We need to figure out which tween-slice of track applied to the requested time (t)
      if (time < timeWhenTweenStarts + tweenDurationInTimeDecimals) {
        final normalizedTime =
            (time - timeWhenTweenStarts) / tweenDurationInTimeDecimals;
        return tweenWithDuration.tween.transform(normalizedTime) as T;
      }
      timeWhenTweenStarts += tweenDurationInTimeDecimals;
    }

    // the for-loop above doesn't catches t=1.0, that's why we handle this case manually
    return track.tweensWithDuration.last.tween.transform(1.0) as T;
  }
}

class _TweenTrack {
  final tweensWithDuration = <_TweenWithDuration>[];

  void add(Animatable tween, Duration duration) {
    tweensWithDuration.add(_TweenWithDuration(tween, duration));
  }

  Duration get duration {
    if (tweensWithDuration.isEmpty) {
      return Duration.zero;
    }

    return tweensWithDuration
        .map((tweenWithDuration) => tweenWithDuration.duration)
        .reduce((value, duration) => value + duration);
  }
}

class _TweenWithDuration {
  final Animatable tween;
  final Duration duration;

  _TweenWithDuration(this.tween, this.duration);
}
