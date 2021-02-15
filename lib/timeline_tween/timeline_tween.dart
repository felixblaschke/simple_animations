part of simple_animations;

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

    var itemsDuration = items.isNotEmpty ? items.max() : 0;
    var scenesDuration = _scenes.isNotEmpty
        ? _scenes
            .map((scene) =>
                scene.begin.inMicroseconds + scene.duration.inMicroseconds)
            .max()
        : 0;

    return max(itemsDuration, scenesDuration).microseconds;
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
    Duration begin,
    Duration duration,
    Duration end,
    Curve curve,
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

    assert(duration >= 0.seconds,
        'Scene duration must be or result in a positive value');
    assert(begin >= 0.seconds,
        'Scene begin must be or result in a positive value');

    var scene = TimelineScene<T>(
      begin: begin,
      duration: duration,
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
    var properties = <T>{};
    allItems.forEach((item) => properties.add(item.property));

    var valueMap = <T, dynamic>{};

    properties.forEach((property) {
      _transformProperty(allItems, property, now, valueMap);
    });

    return TimelineValue<T>(map: valueMap);
  }

  void _transformProperty(
      List<_AbsoluteSceneItem> allItems, T property, double now, Map valueMap) {
    var items = allItems
        .filter((item) => item.property == property)
        .sortedByNum((item) => item.begin);
    assert(items.isNotEmpty);

    var matchInScene = items
        .filter((item) => item.begin <= now && now <= item.end)
        .firstOrNull();

    if (matchInScene != null) {
      // inside a scene
      var localT = (now - matchInScene.begin).toDouble() /
          (matchInScene.end - matchInScene.begin).toDouble();
      valueMap[property] =
          matchInScene.tween.curved(matchInScene.curve).transform(localT);
    } else if (now < items.first.begin) {
      // before first scene
      valueMap[property] =
          items.first.tween.curved(items.first.curve).transform(0.0);
    } else if (items.last.end < now) {
      // after last scene
      valueMap[property] =
          items.last.tween.curved(items.last.curve).transform(1.0);
    } else {
      // between two scenes
      1.until(items.length).forEach((i) {
        var left = items[i - 1];
        var right = items[i];
        if (left.end < now && now < right.begin) {
          valueMap[property] = left.tween.curved(left.curve).transform(1.0);
        }
      });
    }
  }

  List<_AbsoluteSceneItem<T>> _generateAbsoluteItems() {
    var absoluteItems = <_AbsoluteSceneItem<T>>[];

    _scenes.forEach((scene) {
      scene.items.forEach((item) {
        absoluteItems.add(_AbsoluteSceneItem<T>(
          begin: scene.begin.inMicroseconds + item.shiftBegin.inMicroseconds,
          end: scene.begin.inMicroseconds +
              scene.duration.inMicroseconds +
              item.shiftEnd.inMicroseconds,
          curve: item.curve ?? scene.curve ?? curve,
          property: item.property,
          tween: item.tween,
        ));
      });
    });

    return absoluteItems;
  }
}

/// Representing a time span of a [TimelineTween]. This class shouldn't be
/// instanced by hand. It should be creating via [TimelineTween.addScene] or
/// [TimelineScene.addSubsequentScene] methods.
class TimelineScene<T> {
  final Duration begin;
  final Duration duration;
  final Curve curve;
  final TimelineTween<T> parent;

  final items = <_SceneItem<T>>[];

  TimelineScene({this.begin, this.duration, this.curve, this.parent});

  /// Specifies a [tween] for certain [property].
  ///
  /// The easing curve is inherited from the current scene unless overridden
  /// by an alternating [curve].
  ///
  /// The begin and end time is also taken from the scene but can be fine-tuned
  /// by defining [shiftBegin] and [shiftEnd].
  TimelineScene<T> animate(
    T property, {
    Animatable tween,
    Curve curve,
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
    Duration duration,
    Duration delay = Duration.zero,
    Curve curve,
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
  final Curve curve;
  final Duration shiftBegin;
  final Duration shiftEnd;

  _SceneItem({
    this.property,
    this.curve,
    this.tween,
    this.shiftBegin,
    this.shiftEnd,
  });
}

/// A snapshot of properties that were animated by a [TimelineTween].
/// This class can obtained by using [TimelineTween.transform].
class TimelineValue<T> {
  Map<T, dynamic> _map;

  TimelineValue({Map<T, dynamic> map}) {
    _map = map;
  }

  /// Returns the value for a given [property].
  V get<V>(T property) {
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
    this.property,
    this.tween,
    this.curve,
    this.begin,
    this.end,
  });
}
