import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:simple_animations/simple_animations/animation_controller_x/animation_controller_x.dart';

/// Adds an [AnimationControllerX] to your widget state.
///
/// You can access the animation controller by calling [controller].
///
/// ```dart
/// Animation<double> width;
///
/// @override
/// void initState() {
///   width = Tween(begin: 100.0, end: 200.0).animate(controller);
///   controller.addTask(FromToTask(duration: Duration(seconds: 1), to: 1.0));
///   super.initState();
/// }
///
///   @override
///  Widget build(BuildContext context) {
///    return Container(width: width.value);
///  }
/// ```
@optionalTypeArgs
mixin AnimationControllerMixin<T extends StatefulWidget> on State<T>
    implements TickerProvider {
  Ticker _ticker;

  AnimationControllerX controller = AnimationControllerX();

  @override
  void initState() {
    controller.configureVsync(this);
    controller.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Ticker createTicker(TickerCallback onTick) {
    assert(() {
      if (_ticker == null) return true;
      throw FlutterError(
          '$runtimeType is a SingleTickerProviderStateMixin but multiple tickers were created.\n'
          'A SingleTickerProviderStateMixin can only be used as a TickerProvider once. If a '
          'State is used for multiple AnimationController objects, or if it is passed to other '
          'objects and those objects might use it more than one time in total, then instead of '
          'mixing in a SingleTickerProviderStateMixin, use a regular TickerProviderStateMixin.');
    }());
    _ticker = Ticker(onTick, debugLabel: 'created by $this');
    // We assume that this is called from initState, build, or some sort of
    // event handler, and that thus TickerMode.of(context) would return true. We
    // can't actually check that here because if we're in initState then we're
    // not allowed to do inheritance checks yet.
    return _ticker;
  }

  @override
  void dispose() {
    controller.dispose();
    assert(() {
      if (_ticker == null || !_ticker.isActive) return true;
      throw FlutterError('$this was disposed with an active Ticker.\n'
          '$runtimeType created a Ticker via its SingleTickerProviderStateMixin, but at the time '
          'dispose() was called on the mixin, that Ticker was still active. The Ticker must '
          'be disposed before calling super.dispose(). Tickers used by AnimationControllers '
          'should be disposed by calling dispose() on the AnimationController itself. '
          'Otherwise, the ticker will leak.\n'
          'The offending ticker was: ${_ticker.toString(debugIncludeStack: true)}');
    }());
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_ticker != null) _ticker.muted = !TickerMode.of(context);
    super.didChangeDependencies();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    String tickerDescription;
    if (_ticker != null) {
      if (_ticker.isActive && _ticker.muted)
        tickerDescription = 'active but muted';
      else if (_ticker.isActive)
        tickerDescription = 'active';
      else if (_ticker.muted)
        tickerDescription = 'inactive and muted';
      else
        tickerDescription = 'inactive';
    }
    properties.add(DiagnosticsProperty<Ticker>('ticker', _ticker,
        description: tickerDescription,
        showSeparator: false,
        defaultValue: null));
  }
}
