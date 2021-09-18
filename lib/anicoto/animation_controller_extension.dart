import 'package:flutter/material.dart';

/// Method extensions on [AnimationController]
extension AnimationControllerExtension on AnimationController {
  /// Starts playing the animation in forward direction.
  ///
  /// If a [duration] named parameter is provided it will be
  /// applied as the [AnimationController.duration] value.
  ///
  /// Returns a [TickerFuture] that completes when the animation ends or
  /// get canceled.
  ///
  /// Example: (using [supercharged](https://pub.dev/packages/supercharged))
  /// ```dart
  /// controller.play(5.seconds);
  /// ```
  TickerFuture play({Duration? duration}) {
    this.duration = duration ?? this.duration;
    return forward();
  }

  /// Starts playing the animation in backward direction.
  ///
  /// If a [duration] named parameter is provided it will be
  /// applied as the [AnimationController.duration] value.
  ///
  /// Returns a [TickerFuture] that completes when the animation ends or
  /// get canceled.
  ///
  /// Example: (using [supercharged](https://pub.dev/packages/supercharged))
  /// ```dart
  /// controller.playReverse(5.seconds);
  /// ```
  TickerFuture playReverse({Duration? duration}) {
    this.duration = duration ?? this.duration;
    return reverse();
  }

  /// Starts playing the animation in an endless loop. After reaching the
  /// end, it starts over from the beginning.
  ///
  /// If a [duration] named parameter is provided it will be
  /// applied as the [AnimationController.duration] value.
  /// The [duration] applies to the length of one loop iteration.
  ///
  /// Returns a [TickerFuture] that only completes when the animation gets
  /// canceled.
  ///
  /// Example: (using [supercharged](https://pub.dev/packages/supercharged))
  /// ```dart
  /// controller.loop(5.seconds);
  /// ```
  TickerFuture loop({Duration? duration}) {
    this.duration = duration ?? this.duration;
    return repeat();
  }

  /// Starts playing the animation in an endless loop. After reaching the
  /// end, it plays it backwards, then forward and so on.
  ///
  /// If a [duration] named parameter is provided it will be
  /// applied as the [AnimationController.duration] value.
  /// The [duration] applies to the length of one loop iteration.
  ///
  /// Returns a [TickerFuture] that only completes when the animation gets
  /// canceled.
  ///
  /// Example: (using [supercharged](https://pub.dev/packages/supercharged))
  /// ```dart
  /// controller.mirror(5.seconds);
  /// ```
  TickerFuture mirror({Duration? duration}) {
    this.duration = duration ?? this.duration;
    return repeat(reverse: true);
  }
}
