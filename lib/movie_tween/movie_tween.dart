import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Tween / Animatable that animates multiple properties sequentially or in
/// parallel.
class MovieTween extends Animatable<Movie> {
  final _scenes = <MovieScene>[];

  MovieTween({this.curve = Curves.linear});

  /// The curve used to interpolate between values.
  /// Can be overridden if further specified at scene level or tween level.
  final Curve curve;

  /// Returns the total [Duration] of the specified animation.
  Duration get duration {
    var items = _generateAbsoluteItems().map((item) => item.end);

    int itemsDuration = items.sorted((a, b) => a.compareTo(b)).lastOrNull ?? 0;
    int scenesDuration = _scenes
            .map((scene) =>
                scene.begin.inMicroseconds + scene.duration.inMicroseconds)
            .sorted((a, b) => a.compareTo(b))
            .lastOrNull ??
        0;

    return Duration(microseconds: max(itemsDuration, scenesDuration));
  }

  /// Adds a new scene to the movie. A scene is specified with a time span.
  /// The time span can be set by providing either
  /// - [begin] and [end]
  /// - [begin] and [duration]
  /// - [duration] and [end].
  /// - only [duration] assuming begin is [Duration.zero].
  MovieScene scene({
    /// Time in duration at which the scene starts.
    Duration? begin,

    /// Duration of the scene.
    Duration? duration,

    /// Time in duration at which the scene ends.
    Duration? end,

    /// Custom curve for the scene.
    Curve? curve,
  }) {
    assert(
        (begin != null && duration != null && end == null) ||
            (begin != null && duration == null && end != null) ||
            (begin == null && duration != null && end != null) ||
            (begin == null && duration != null && end == null),
        'Please specify two of these properties: begin, duration, end');

    /// Only duration is specified.
    if (duration != null && begin == null && end == null) {
      /// Assume begin is [Duration.zero].
      begin = Duration.zero;
    }

    /// Start and end is specified.
    if (begin != null && end != null) {
      /// Compute duration.
      duration = end - begin;
    }

    /// End and duration is specified.
    if (end != null && duration != null) {
      /// Computing beginning.
      begin = end - duration;
    }

    assert(duration! >= Duration.zero,
        'Scene duration must be or result in a positive value');
    assert(begin! >= Duration.zero,
        'Scene begin must be or result in a positive value');

    /// Create scene object.
    var scene = MovieScene(
      begin: begin!,
      duration: duration!,
      curve: curve,
      parent: this,
    );
    _scenes.add(scene);
    return scene;
  }

  /// Animates a property and returns the implicitly created scene.
  /// The scene can be used to add further properties to the scene or to
  /// add further scenes to the movie.
  MovieScene tween<T>(
    /// Property to animate
    MovieTweenPropertyType property,

    //// Tween that describes the property animation
    Animatable<T> tween, {

    /// Time in duration at which the scene starts.
    Duration? begin,

    /// Duration of the scene.
    Duration? duration,

    /// Time in duration at which the scene ends.
    Duration? end,

    /// Custom curve for this property animation.
    Curve? curve,
  }) =>
      scene(begin: begin, duration: duration, end: end)
          .tween(property, tween, curve: curve);

  /// Computes the tween
  @override
  Movie transform(double t) {
    final propertyItems = <MovieTweenPropertyType, List<_AbsoluteSceneItem>>{};
    final now = t * duration.inMicroseconds;
    final valueMap = <MovieTweenPropertyType, dynamic>{};

    final allItems = _generateAbsoluteItems();

    /// Presort all items by begin.
    allItems.sort((a, b) => a.begin - b.begin);

    /// Group items by property.
    for (var item in allItems) {
      propertyItems.putIfAbsent(item.property, () => []);
      propertyItems[item.property]!.add(item);
    }

    /// Transform each property for current time [t].
    for (var property in propertyItems.keys) {
      _transformProperty(propertyItems[property]!, property, now, valueMap);
    }

    return Movie(map: valueMap);
  }

  /// Computes the animated value for the given property and time [t].
  void _transformProperty(
    List<_AbsoluteSceneItem> items,
    MovieTweenPropertyType property,
    double t,
    Map valueMap,
  ) {
    assert(items.every((item) => item.property == property),
        'Items must already be filtered for $property');
    assert(() {
      // Pre-sorting items makes the look-up of first, last, and matching items
      // all doable in a single O(n) pass of the list.
      for (var i = 1; i < items.length; i++) {
        var previous = items[i - 1];
        var current = items[i];
        assert(current.begin >= previous.begin);
      }
      return true;
    }(), 'Items must already be sorted by "begin" field');

    _AbsoluteSceneItem? earliestItem;
    _AbsoluteSceneItem? latestItem;
    _AbsoluteSceneItem? matchInScene;

    /// To compute the value, we need to find out the current location in the
    /// movie. For that we need to find the earliest, latest, and maybe a
    /// directly matching item.
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      if (item.property == property) {
        if (earliestItem == null || item.begin < earliestItem.begin) {
          earliestItem = item;
        }
        if (latestItem == null || item.begin > latestItem.begin) {
          latestItem = item;
        }
        if (item.begin <= t && t <= item.end) {
          if (matchInScene == null || item.begin < matchInScene.begin) {
            matchInScene = item;
          }
        }
      }
    }
    assert(earliestItem != null);
    assert(latestItem != null);

    if (matchInScene != null) {
      /// The current time [t] matches directly a scene object.
      /// The tween can be queried for the value.
      final localT = (t - matchInScene.begin).toDouble() /
          (matchInScene.end - matchInScene.begin).toDouble();
      valueMap[property] = matchInScene.tween
          .chain(CurveTween(curve: matchInScene.curve))
          .transform(localT);
    } else if (t < earliestItem!.begin) {
      /// The current time [t] is before the earliest item.
      /// The first-ever value is used.
      valueMap[property] = earliestItem.tween
          .chain(CurveTween(curve: earliestItem.curve))
          .transform(0.0);
    } else if (latestItem!.end < t) {
      /// The current time [t] is after the latest item.
      /// The very last value is used.
      valueMap[property] = latestItem.tween
          .chain(CurveTween(curve: latestItem.curve))
          .transform(1.0);
    } else {
      /// The current time [t] is between the two scenes. Iterate over all
      /// items and find the one that matches the current time.
      for (var i = 1; i < items.length; i++) {
        final left = items[i - 1];
        final right = items[i];
        if (left.end < t && t < right.begin) {
          valueMap[property] =
              left.tween.chain(CurveTween(curve: left.curve)).transform(1.0);
          break;
        }
      }
    }
  }

  /// Generates a list of all scene items with duration values resolved to
  /// absolute values. A scene item represents any tween declaration within the
  /// movie.
  List<_AbsoluteSceneItem> _generateAbsoluteItems() {
    var absoluteItems = <_AbsoluteSceneItem>[];

    for (final scene in _scenes) {
      for (final item in scene.items) {
        absoluteItems.add(_AbsoluteSceneItem(
          begin: scene.begin.inMicroseconds + item.shiftBegin.inMicroseconds,
          end: scene.begin.inMicroseconds +
              scene.duration.inMicroseconds +
              item.shiftEnd.inMicroseconds,
          curve: item.curve ?? scene.curve ?? curve,
          property: item.property,
          tween: item.tween,
        ));
      }
    }

    return absoluteItems;
  }
}

/// Representing a time span of a [MovieTween]. This class shouldn't be
/// instanced by hand. It should be creating via [MovieTween.scene] or
/// [MovieScene.thenFor] methods.
class MovieScene {
  final Duration begin;
  final Duration duration;
  final Curve? curve;
  final MovieTween parent;

  final items = <_SceneItem>[];

  MovieScene({
    required this.begin,
    required this.duration,
    required this.parent,
    this.curve,
  });

  /// Animates a property and returns the implicitly created scene.
  /// The scene can be used to add further properties to the scene or to
  /// add further scenes to the movie.
  MovieScene tween<T>(
    /// Property to animate
    MovieTweenPropertyType property,

    //// Tween that describes the property animation
    Animatable<T> tween, {

    /// Custom curve for this property.
    Curve? curve,

    /// Shift the begin time by this amount.
    Duration shiftBegin = Duration.zero,

    /// Shift the end time by this amount.
    Duration shiftEnd = Duration.zero,
  }) {
    assert(begin + shiftBegin >= Duration.zero, 'Effective begin must be > 0');

    items.add(_SceneItem(
      property: property,
      tween: tween,
      curve: curve,
      shiftBegin: shiftBegin,
      shiftEnd: shiftEnd,
    ));
    return this;
  }

  /// Animates a property and returns the implicitly created scene.
  /// The scene can be used to add further properties to the scene or to
  /// add further scenes to the movie.
  MovieScene thenTween<T>(
    /// Property to animate
    MovieTweenPropertyType property,

    //// Tween that describes the property animation.
    Animatable<T> tween, {

    /// Duration of the scene
    required Duration duration,

    /// Fine-tune the begin time of the next scene by adding a delay.
    /// The value can also be negative.
    Duration delay = Duration.zero,

    /// Custom curve for this property.
    Curve? curve,
    Curve? sceneCurve,
  }) {
    return thenFor(duration: duration, delay: delay, curve: sceneCurve)
        .tween(property, tween, curve: curve);
  }

  /// Adds an additional scene that begins immediately after this scene.
  MovieScene thenFor({
    /// Duration of the scene
    required Duration duration,

    /// Fine-tune the begin time of the next scene by adding a delay.
    /// The value can also be negative.
    Duration delay = Duration.zero,

    /// Custom curve for this scene.
    Curve? curve,
  }) {
    return parent.scene(
      begin: begin + this.duration + delay,
      duration: duration,
      curve: curve,
    );
  }
}

class _SceneItem {
  final MovieTweenPropertyType property;
  final Animatable tween;
  final Curve? curve;
  final Duration shiftBegin;
  final Duration shiftEnd;

  _SceneItem({
    required this.property,
    required this.tween,
    required this.shiftBegin,
    required this.shiftEnd,
    this.curve,
  });
}

/// A snapshot of properties that are animated by a [MovieTween].
/// This class can obtained by using [MovieTween.transform].
class Movie {
  final Map<MovieTweenPropertyType, dynamic> _map;

  Movie({required Map<MovieTweenPropertyType, dynamic> map}) : _map = map;

  /// Returns the value for a given [property].
  V get<V>(MovieTweenPropertyType property) {
    assert(_map.containsKey(property), 'Property $property was not found.');
    return _map[property] as V;
  }
}

class _AbsoluteSceneItem {
  final MovieTweenPropertyType property;
  final Animatable<dynamic> tween;
  final Curve curve;
  final int begin;
  final int end;

  _AbsoluteSceneItem({
    required this.property,
    required this.tween,
    required this.curve,
    required this.begin,
    required this.end,
  });
}

/// Any [Object] can act as a tween property.
typedef MovieTweenPropertyType = Object;

/// Type-safe tween property that can be used as a `const`.
class MovieTweenProperty<T> {
  MovieTweenProperty();

  /// Returns the current value of this property.
  T from(Movie movie) => movie.get(this);
}
