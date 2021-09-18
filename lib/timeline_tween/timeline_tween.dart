import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Animatable that handles complex animations which handles
/// multiple properties or scenes.
///
/// You can specify a default curve for the tween by setting [curve].
///
/// Example: (using [supercharged](https://pub.dev/packages/supercharged))
/// ```dart
/// enum Prop { width, height, color }
///
/// var timeline = TimelineTween<Prop>();
///
/// timeline
///     .addScene(begin: 0.seconds, duration: 1.seconds)
///     .animate(Prop.width, tween: 100.0.tweenTo(200.0))
///     .animate(Prop.height, tween: 50.0.tweenTo(100.0));
///
/// timeline
///     .addScene(begin: 1.2.seconds, end: 2.seconds)
///     .animate(Prop.color, tween: Colors.black.tweenTo(Colors.black));
/// ```
class TimelineTween<T> extends Animatable<TimelineValue<T>> {
  final _scenes = <TimelineScene<T>>[];

  final Curve curve;

  TimelineTween({this.curve = Curves.linear});

  /// Returns the total [Duration] based on the specified scenes.
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

  /// Adds a new scene to the timeline. A scene is specified with a time span.
  /// The time span can be set by providing either
  /// - [begin] and [end]
  /// - [begin] and [duration]
  /// - [duration] and [end].
  ///
  /// By default the scene uses a linear easing curve for all it's animated
  /// properties. This can be change by specifying a [curve].
  TimelineScene<T> addScene({
    Duration? begin,
    Duration? duration,
    Duration? end,
    Curve? curve,
  }) {
    assert(
        (begin != null && duration != null && end == null) ||
            (begin != null && duration == null && end != null) ||
            (begin == null && duration != null && end != null),
        'When using addScene() specify exactly two of these properties: begin, duration, end');

    if (begin != null && end != null) {
      duration = end - begin;
    }

    if (end != null && duration != null) {
      begin = end - duration;
    }

    assert(duration! >= Duration.zero,
        'Scene duration must be or result in a positive value');
    assert(begin! >= Duration.zero,
        'Scene begin must be or result in a positive value');

    var scene = TimelineScene<T>(
      begin: begin!,
      duration: duration!,
      curve: curve,
      parent: this,
    );
    _scenes.add(scene);
    return scene;
  }

  /// Computes the tween
  @override
  TimelineValue<T> transform(double t) {
    var now = t * duration.inMicroseconds;
    var allItems = _generateAbsoluteItems();

    // It's faster to sort the entire array once than chop it up then sort each
    // property-specific sub-array. The sorting is done because
    // _transformProperty wants to process the scene items in `begin` order.
    allItems.sort((a, b) => a.begin - b.begin);

    // Each list in this map is automatically sorted because allItems
    // is already pre-sorted by `begin` property. No extra sorting is
    // necessary.
    var propertyItems = <T, List<_AbsoluteSceneItem>>{};
    for (var item in allItems) {
      var items = propertyItems[item.property];
      if (items == null) {
        propertyItems[item.property] = items = <_AbsoluteSceneItem>[];
      }
      items.add(item);
    }

    var valueMap = <T, dynamic>{};

    for (var property in propertyItems.keys) {
      _transformProperty(propertyItems[property]!, property, now, valueMap);
    }

    return TimelineValue<T>(map: valueMap);
  }

  void _transformProperty(
      List<_AbsoluteSceneItem> items, T property, double now, Map valueMap) {
    // Pre-sorting items makes the look-up of first, last, and matching items
    // all doable in a single O(n) pass of the list.
    assert(items.every((item) => item.property == property),
        'Items must already be filtered for $property');
    assert(() {
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

    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      if (item.property == property) {
        if (earliestItem == null || item.begin < earliestItem.begin) {
          earliestItem = item;
        }
        if (latestItem == null || item.begin > latestItem.begin) {
          latestItem = item;
        }
        if (item.begin <= now && now <= item.end) {
          if (matchInScene == null || item.begin < matchInScene.begin) {
            matchInScene = item;
          }
        }
      }
    }
    assert(earliestItem != null);
    assert(latestItem != null);

    if (matchInScene != null) {
      // inside a scene
      var localT = (now - matchInScene.begin).toDouble() /
          (matchInScene.end - matchInScene.begin).toDouble();
      valueMap[property] = matchInScene.tween
          .chain(CurveTween(curve: matchInScene.curve))
          .transform(localT);
    } else if (now < earliestItem!.begin) {
      // before first scene
      valueMap[property] = earliestItem.tween
          .chain(CurveTween(curve: earliestItem.curve))
          .transform(0.0);
    } else if (latestItem!.end < now) {
      // after last scene
      valueMap[property] = latestItem.tween
          .chain(CurveTween(curve: latestItem.curve))
          .transform(1.0);
    } else {
      // between two scenes
      for (var i = 1; i < items.length; i++) {
        var left = items[i - 1];
        var right = items[i];
        if (left.end < now && now < right.begin) {
          valueMap[property] =
              left.tween.chain(CurveTween(curve: left.curve)).transform(1.0);
        }
      }
    }
  }

  List<_AbsoluteSceneItem<T>> _generateAbsoluteItems() {
    var absoluteItems = <_AbsoluteSceneItem<T>>[];

    for (final scene in _scenes) {
      for (final item in scene.items) {
        absoluteItems.add(_AbsoluteSceneItem<T>(
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

/// Representing a time span of a [TimelineTween]. This class shouldn't be
/// instanced by hand. It should be creating via [TimelineTween.addScene] or
/// [TimelineScene.addSubsequentScene] methods.
class TimelineScene<T> {
  final Duration begin;
  final Duration duration;
  final Curve? curve;
  final TimelineTween<T> parent;

  final items = <_SceneItem<T>>[];

  TimelineScene({
    required this.begin,
    required this.duration,
    required this.parent,
    this.curve,
  });

  /// Specifies a [tween] for certain [property].
  ///
  /// The easing curve is inherited from the current scene unless overridden
  /// by an alternating [curve].
  ///
  /// The begin and end time is also taken from the scene but can be fine-tuned
  /// by defining [shiftBegin] and [shiftEnd].
  TimelineScene<T> animate(
    T property, {
    required Animatable tween,
    Curve? curve,
    Duration shiftBegin = Duration.zero,
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

  /// Adds an additional scene that begins immediately after this scene for a
  /// given [duration].
  ///
  /// The chronological position can be fine-tuned by specifying a [delay].
  ///
  /// By default the scene uses a linear easing curve for all it's animated
  /// properties. This can be change by specifying a [curve].
  TimelineScene<T> addSubsequentScene({
    required Duration duration,
    Duration delay = Duration.zero,
    Curve? curve,
  }) {
    return parent.addScene(
      begin: begin + this.duration + delay,
      duration: duration,
      curve: curve,
    );
  }
}

class _SceneItem<T> {
  final T property;
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

/// A snapshot of properties that were animated by a [TimelineTween].
/// This class can obtained by using [TimelineTween.transform].
class TimelineValue<T> {
  final Map<T, dynamic> _map;

  TimelineValue({required Map<T, dynamic> map}) : _map = map;

  /// Returns the value for a given [property].
  V get<V>(T property) {
    assert(_map.containsKey(property), 'Property $property was not found.');
    return _map[property] as V;
  }
}

class _AbsoluteSceneItem<T> {
  final T property;
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
