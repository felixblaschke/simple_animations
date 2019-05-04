import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// Widget to easily create a continuous animation.
///
/// You need to specify a [builder] function that gets the build context passed
/// along with the [timeElapsed] (as a [Duration]) since the rendering started.
/// You can use this time to specify custom animations on it.
///
/// The [builder] rebuilds all sub-widgets every frame.
///
/// You define an [onTick] function that is called before builder to update
/// you rendered scene. It's also utilized during fast-forwarding the animation.
///
/// Specify a [startTime] to fast-forward your animation in the beginning.
/// The widget will interpolate the animation by calling the [onTick] function
/// multiple times. (Default value is `20`. You can tune it by setting the
/// [startTimeSimulationTicks] property.)
class Rendering extends StatefulWidget {
  final Widget Function(BuildContext context, Duration timeElapsed) builder;
  final Function(Duration timeElapsed) onTick;
  final Duration startTime;
  final int startTimeSimulationTicks;

  Rendering(
      {this.builder,
      this.onTick,
      this.startTime = Duration.zero,
      this.startTimeSimulationTicks = 20})
      : assert(builder != null, "Builder needs to defined.");

  @override
  _RenderingState createState() => _RenderingState();
}

class _RenderingState extends State<Rendering>
    with SingleTickerProviderStateMixin {
  Ticker _ticker;
  Duration _timeElapsed = Duration(milliseconds: 0);

  @override
  void initState() {
    if (widget.startTime > Duration.zero) {
      _simulateStartTimeTicks();
    }

    _ticker = createTicker((elapsed) {
      _onRender(elapsed + widget.startTime);
    });
    _ticker.start();
    super.initState();
  }

  void _onRender(Duration effectiveElapsed) {
    if (widget.onTick != null) {
      widget.onTick(effectiveElapsed);
    }
    setState(() {
      _timeElapsed = effectiveElapsed;
    });
  }

  void _simulateStartTimeTicks() {
    if (widget.onTick != null) {
      Iterable.generate(widget.startTimeSimulationTicks + 1).forEach((i) {
        final simulatedTime = Duration(
            milliseconds: (widget.startTime.inMilliseconds *
                    i /
                    widget.startTimeSimulationTicks)
                .round());
        widget.onTick(simulatedTime);
      });
    }
  }

  @override
  void dispose() {
    _ticker.stop(canceled: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _timeElapsed);
  }
}
