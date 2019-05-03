import 'dart:math';

class AnimationProgress {
  Duration duration;
  Duration startTime;

  AnimationProgress({this.duration, this.startTime})
      : assert(duration != null, "Please specify an animation duration."),
        assert(
            startTime != null, "Please specify a start time of the animation.");

  restart(Duration time) {
    startTime = time;
  }

  double progress(Duration time) => max(0.0,
      min((time - startTime).inMilliseconds / duration.inMilliseconds, 1.0));
}
