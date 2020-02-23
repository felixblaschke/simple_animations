import 'dart:math';

import 'package:flutter/widgets.dart';

/// Animatable that tweens multiple parallel properties (called [Track]s).
/// ---
/// The constructor of [MultiTrackTween] expects a list of [Track] objects.
/// You can fetch the specified total duration via [duration] getter.
/// ---
/// Example:
///
/// ```dart
///   final tween = MultiTrackTween([
///     Track("color")
///       .add(Duration(seconds: 1), ColorTween(begin: Colors.red, end: Colors.blue))
///       .add(Duration(seconds: 1), ColorTween(begin: Colors.blue, end: Colors.yellow)),
///     Track("width")
///       .add(Duration(milliseconds: 500), ConstantTween(200.0))
///       .add(Duration(milliseconds: 1500), Tween(begin: 200.0, end: 400.0),
///            curve: Curves.easeIn)
///   ]);
///
///   return ControlledAnimation(
///     duration: tween.duration,
///     tween: tween,
///     builder: (context, values) {
///        ...
///     }
///   );
/// ```
class MultiTrackTween extends Animatable<Map<String, dynamic>> {
  final _tracksToTween = Map<String, _TweenData>();
  var _maxDuration = 0;

  MultiTrackTween(List<Track> tracks)
      : assert(tracks != null && tracks.isNotEmpty,
            "Add a List<Track> to configure the tween."),
        assert(tracks.where((track) => track.items.isEmpty).isEmpty,
            "Each Track needs at least one added Tween by using the add()-method.") {
    _computeMaxDuration(tracks);
    _computeTrackTweens(tracks);
  }

  void _computeMaxDuration(List<Track> tracks) {
    tracks.forEach((track) {
      final trackDuration = track.items
          .map((item) => item.duration.inMilliseconds)
          .reduce((sum, item) => sum + item);
      _maxDuration = max(_maxDuration, trackDuration);
    });
  }

  void _computeTrackTweens(List<Track> tracks) {
    tracks.forEach((track) {
      final trackDuration = track.items
          .map((item) => item.duration.inMilliseconds)
          .reduce((sum, item) => sum + item);

      final sequenceItems = track.items
          .map((item) => TweenSequenceItem(
              tween: item.tween,
              weight: item.duration.inMilliseconds / _maxDuration))
          .toList();

      if (trackDuration < _maxDuration) {
        sequenceItems.add(TweenSequenceItem(
            tween: ConstantTween(null),
            weight: (_maxDuration - trackDuration) / _maxDuration));
      }

      final sequence = TweenSequence(sequenceItems);

      _tracksToTween[track.name] =
          _TweenData(tween: sequence, maxTime: trackDuration / _maxDuration);
    });
  }

  /// Returns the highest duration specified by [Track]s.
  /// ---
  /// Use it to pass it into an [ControlledAnimation].
  ///
  /// You can also scale it by multiplying a double value.
  ///
  /// Example:
  /// ```dart
  ///   final tween = MultiTrackTween(listOfTracks);
  ///
  ///   return ControlledAnimation(
  ///     duration: tween.duration * 1.25, // stretch animation by 25%
  ///     tween: tween,
  ///     builder: (context, values) {
  ///        ...
  ///     }
  ///   );
  /// ```
  Duration get duration {
    return Duration(milliseconds: _maxDuration);
  }

  /// Computes the map of specific values for the animation.
  /// You don't need to call it yourself. It's been implicitly used by
  /// [Tween]-consuming classes.
  ///
  /// See [Animatable.transform].
  @override
  Map<String, dynamic> transform(double t) {
    final Map<String, dynamic> result = Map();
    _tracksToTween.forEach((name, tweenData) {
      final double tTween = max(0, min(t, tweenData.maxTime - 0.0001));
      result[name] = tweenData.tween.transform(tTween);
    });
    return result;
  }
}

/// Single property to tween. Used by [MultiTrackTween].
class Track<T> {
  final String name;
  final List<_TrackItem> items = [];

  Track(this.name) : assert(name != null, "Track name must not be null.");

  /// Adds a "piece of animation" to a [Track].
  ///
  /// You need to pass a [duration] and a [tween]. It will return the track, so
  /// you can specify a track in a builder's style.
  ///
  /// Optionally you can set a named parameter [curve] that applies an easing
  /// curve to the tween.
  Track<T> add(Duration duration, Animatable<T> tween, {Curve curve}) {
    items.add(_TrackItem(duration, tween, curve: curve));
    return this;
  }
}

class _TrackItem<T> {
  final Duration duration;
  Animatable<T> tween;

  _TrackItem(this.duration, Animatable<T> _tween, {Curve curve})
      : assert(duration != null, "Please set a duration."),
        assert(_tween != null, "Please set a tween.") {
    if (curve != null) {
      tween = _tween.chain(CurveTween(curve: curve));
    } else {
      tween = _tween;
    }
  }
}

class _TweenData<T> {
  final Animatable<T> tween;
  final double maxTime;

  _TweenData({this.tween, this.maxTime});
}
