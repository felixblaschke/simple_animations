import 'package:flutter/material.dart';

/// Wrapper widget for displaying developer tooling that will
/// assist your while creating custom animation.
///
/// If you are using stateless animation widget like [PlayAnimation],
/// [CustomAnimation], [LoopAnimation] or [MirrorAnimation] set it's
/// constructor parameter `developerMode` to `true`.
class AnimationDeveloperTools extends StatefulWidget {
  final Widget child;
  final AnimationDeveloperToolsPosition position;

  const AnimationDeveloperTools({
    Key? key,
    required this.child,
    this.position = AnimationDeveloperToolsPosition.top,
  }) : super(key: key);

  @override
  _AnimationDeveloperToolsState createState() =>
      _AnimationDeveloperToolsState();
}

/// Possible values for the position of the [AnimationDeveloperTools].
enum AnimationDeveloperToolsPosition {
  /// Toolbar is placed at top
  top,

  /// Toolbar is placed at the bottom
  bottom,

  /// Toolbar is not visible
  hidden,
}

class _AnimationDeveloperToolsState extends State<AnimationDeveloperTools> {
  AnimationController? controller;
  Duration? baseDuration;
  Duration? currentDuration;
  var play = true;
  var lowerBounds = 0.0;
  var upperBounds = 1.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var smallScreen = constraints.maxWidth < 700;

      return Stack(
        children: [
          Positioned.fill(
              child: AnimationControllerTransfer(
            controllerProvider: _obtainController,
            child: widget.child,
          )),
          if (widget.position != AnimationDeveloperToolsPosition.hidden)
            Positioned.fill(
                child: Align(
              alignment: widget.position == AnimationDeveloperToolsPosition.top
                  ? Alignment.topCenter
                  : Alignment.bottomCenter,
              child: Container(
                color: Colors.black.withOpacity(0.8),
                child: controller == null
                    ? Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        height: 50,
                        child: const Text(
                            'Waiting for widget to enable Developer Mode...',
                            style: TextStyle(color: Colors.white)),
                      )
                    : Flex(
                        direction:
                            smallScreen ? Axis.vertical : Axis.horizontal,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          smallScreen
                              ? _buildSlider()
                              : Expanded(
                                  flex: 1,
                                  child: _buildSlider(),
                                ),
                          SizedBox(
                            height: 50,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _ToolbarButton(
                                    onTap: _play,
                                    icon: Icons.play_arrow,
                                    active: play),
                                _ToolbarButton(
                                    onTap: () => _speed(2),
                                    icon: Icons.fast_rewind,
                                    active: currentDuration! > baseDuration!),
                                Container(
                                    alignment: Alignment.center,
                                    width: 50,
                                    child: Text('${_currentSpeedFactor()}x',
                                        style: TextStyle(
                                            color: Colors.white
                                                .withOpacity(0.7)))),
                                _ToolbarButton(
                                    onTap: () => _speed(0.5),
                                    icon: Icons.fast_forward,
                                    active: currentDuration! < baseDuration!),
                                Container(width: 32),
                                Transform.scale(
                                  scale: -1,
                                  child: _ToolbarButton(
                                      onTap: () => _lowerBounds(),
                                      icon: Icons.keyboard_tab,
                                      active: lowerBounds != 0.0),
                                ),
                                _ToolbarButton(
                                    onTap: () => _upperBounds(),
                                    icon: Icons.keyboard_tab,
                                    active: upperBounds != 1.0),
                                Container(width: 16),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ))
        ],
      );
    });
  }

  Widget _buildSlider() {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        height: 50,
        child: Stack(
          children: [
            if (lowerBounds > 0 || upperBounds < 1)
              Positioned.fill(
                  child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 24 + lowerBounds * (constraints.maxWidth - 48)),
                  child: Container(
                    width: (constraints.maxWidth - 48) *
                        (upperBounds - lowerBounds),
                    height: 30,
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                        border: Border.all(color: Colors.white, width: 2)),
                  ),
                ),
              )),
            Positioned.fill(
              child: Slider(
                min: 0.0,
                max: 1.0,
                value: controller!.value,
                onChanged: _scroll,
                activeColor: Colors.white,
                inactiveColor: Colors.grey,
              ),
            ),
            Positioned(
              bottom: 2,
              right: 24,
              child: Text(_currentTime(),
                  style: const TextStyle(color: Colors.grey)),
            )
          ],
        ),
      );
    });
  }

  String _currentTime() {
    var now = (controller!.value * baseDuration!.inMilliseconds).round();
    return '$now ms';
  }

  void _obtainController(AnimationController animationController) {
    controller = animationController;
    controller!.addListener(() => setState(() {}));
    baseDuration = controller!.duration ?? const Duration(seconds: 1);
    currentDuration = baseDuration;
    Future<void>.delayed(const Duration(milliseconds: 100))
        .then((_) => _updateController());
  }

  void _play() {
    setState(() => play = !play);
    _updateController();
  }

  void _updateController() {
    if (!play) {
      controller!.stop();
    } else {
      controller!.duration = Duration(
          microseconds:
              (currentDuration!.inMicroseconds * (upperBounds - lowerBounds))
                  .round());
      controller!.repeat(min: lowerBounds, max: upperBounds, reverse: false);
    }
  }

  void _scroll(double position) {
    controller!.stop();
    controller!.value = position;
    _updateController();
  }

  void _speed(double factor) {
    setState(() {});
    currentDuration = Duration(
        microseconds: (currentDuration!.inMicroseconds * factor).round());
    controller!.stop();
    _updateController();
  }

  String _currentSpeedFactor() {
    var factor = baseDuration!.inMicroseconds.toDouble() /
        currentDuration!.inMicroseconds.toDouble();

    if (factor >= 1) {
      return factor.round().toString();
    } else {
      return '1/${(1 / factor).round()}';
    }
  }

  void _lowerBounds() {
    setState(() => lowerBounds = lowerBounds == 0.0 ? controller!.value : 0.0);
    _fixBoundsOrder();
    _updateController();
  }

  void _upperBounds() {
    setState(() => upperBounds = upperBounds == 1.0 ? controller!.value : 1.0);
    _fixBoundsOrder();
    _updateController();
  }

  void _fixBoundsOrder() {
    if (lowerBounds > upperBounds) {
      var lower = lowerBounds;
      setState(() {
        lowerBounds = upperBounds;
        upperBounds = lower;
      });
      _updateController();
    }

    if (lowerBounds == upperBounds) {
      setState(() {
        lowerBounds = 0.0;
        upperBounds = 1.0;
      });
      _updateController();
    }
  }
}

class _ToolbarButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final IconData icon;
  final bool active;

  const _ToolbarButton({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.active,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _GestureDetectorWithClickHover(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              border: Border.all(
                  color: active ? Colors.white : Colors.transparent, width: 2),
              color: Colors.grey.shade800),
          child: Icon(icon, color: active ? Colors.white : Colors.grey),
        ),
      ),
    );
  }
}

class _GestureDetectorWithClickHover extends StatelessWidget {
  final GestureTapCallback onTap;
  final Widget child;

  const _GestureDetectorWithClickHover({
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: child,
      ),
    );
  }
}

class AnimationControllerTransfer extends InheritedWidget {
  final void Function(AnimationController) controllerProvider;

  const AnimationControllerTransfer({
    Key? key,
    required this.controllerProvider,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant AnimationControllerTransfer oldWidget) {
    return oldWidget.controllerProvider != controllerProvider;
  }
}
