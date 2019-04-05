import 'dart:math';

import 'package:flutter/widgets.dart';

class MultiTrackTween extends Animatable<Map<String, dynamic>> {
  final _tracksToTween = Map<String, _TweenData>();
  var _maxDuration = 0;

  MultiTrackTween(List<Track> tracks)
      : assert(tracks != null && tracks.length > 0,
            "Add a List<Track> to configure the tween."),
        assert(tracks.where((track) => track.items.length == 0).length == 0,
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

  Duration get duration {
    return Duration(milliseconds: _maxDuration);
  }

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

class Track<T> {
  final String name;
  final List<TrackItem> items = [];

  Track(this.name) : assert(name != null, "Track name must not be null.");

  add(Duration duration, Animatable<T> tween, {Curve curve = Curves.linear}) {
    items.add(TrackItem(duration, tween, curve));
    return this;
  }
}

class TrackItem<T> {
  final Duration duration;
  final Animatable<T> tween;
  final Curve curve;

  TrackItem(this.duration, this.tween, this.curve)
      : assert(duration != null, "Please set a duration."),
        assert(tween != null, "Please set a tween.");
}

class _TweenData<T> {
  final Animatable<T> tween;
  final double maxTime;

  _TweenData({this.tween, this.maxTime});
}
