import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../animation_developer_tools/animation_developer_tools.dart';

/// Extends your state class with the ability to manage an arbitrary number
/// of [AnimationController] instances. It takes care of initialization
/// and disposing of these instances.
///
/// Simply start using [controller] as your [AnimationController] instance.
///
/// You can create additional instances of [AnimationController] by calling
/// [createController].
///
/// See API documentation for [controller] and [createController] for examples.
mixin AnimationMixin<T extends StatefulWidget> on State<T>
    implements TickerProvider {
  AnimationController? _mainControllerInstance;

  final _controllerInstances = <AnimationController>[];

  /// Returns the main [AnimationController] instance for this state class.
  AnimationController get controller {
    _mainControllerInstance ??= _newAnimationController();
    return _mainControllerInstance!;
  }

  /// Connects given [controller] to the closest [AnimationDeveloperTools]
  /// widget to enable developer mode.
  void enableDeveloperMode(AnimationController controller) {
    var transfer =
        context.findAncestorWidgetOfExactType<AnimationControllerTransfer>();
    assert(transfer != null,
        'Please place an AnimationDeveloperTools widget inside the widget tree');
    transfer?.controllerProvider(controller);
  }

  /// Creates an additional [AnimationController] instance that gets initialized
  /// and disposed by this mixin.
  ///
  /// Optionally you can limit the framerate (fps) by specifying a target [fps]
  /// value.
  ///
  /// You can create an unbound [AnimationController] by setting the [unbounded]
  /// parameter.
  AnimationController createController({
    bool unbounded = false,
    int? fps,
  }) {
    final instance = _newAnimationController(unbounded: unbounded, fps: fps);
    _controllerInstances.add(instance);
    return instance;
  }

  AnimationController _newAnimationController({
    bool unbounded = false,
    int? fps,
  }) {
    var controller = _instanceController(unbounded: unbounded);

    if (fps == null) {
      controller.addListener(() => setState(() {}));
    } else {
      _addFrameLimitingUpdater(controller, fps);
    }

    return controller;
  }

  void _addFrameLimitingUpdater(AnimationController controller, int fps) {
    var lastUpdateEmitted = DateTime(1970);
    final frameTimeMs = (1000 / fps).floor();

    controller.addListener(() {
      final now = DateTime.now();
      if (lastUpdateEmitted
          .isBefore(now.subtract(Duration(milliseconds: frameTimeMs)))) {
        lastUpdateEmitted = DateTime.now();
        setState(() {});
      }
    });
  }

  AnimationController _instanceController({required bool unbounded}) {
    if (!unbounded) {
      return AnimationController(
          vsync: this, duration: const Duration(seconds: 1));
    } else {
      return AnimationController.unbounded(
          vsync: this, duration: const Duration(seconds: 1));
    }
  }

  // below code from [TickerProviderStateMixin] (dispose method is modified) ----------------------------------------

  Set<Ticker>? _tickers;

  @override
  Ticker createTicker(TickerCallback onTick) {
    if (_tickerModeNotifier == null) {
      // Setup TickerMode notifier before we vend the first ticker.
      _updateTickerModeNotifier();
    }
    assert(_tickerModeNotifier != null);
    _tickers ??= <_WidgetTicker>{};
    final _WidgetTicker result = _WidgetTicker(onTick, this,
        debugLabel: kDebugMode ? 'created by ${describeIdentity(this)}' : null)
      ..muted = !_tickerModeNotifier!.value;
    _tickers!.add(result);
    return result;
  }

  void _removeTicker(_WidgetTicker ticker) {
    assert(_tickers != null);
    assert(_tickers!.contains(ticker));
    _tickers!.remove(ticker);
  }

  ValueListenable<bool>? _tickerModeNotifier;

  @override
  void activate() {
    super.activate();
    // We may have a new TickerMode ancestor, get its Notifier.
    _updateTickerModeNotifier();
    _updateTickers();
  }

  void _updateTickers() {
    if (_tickers != null) {
      final bool muted = !_tickerModeNotifier!.value;
      for (final Ticker ticker in _tickers!) {
        ticker.muted = muted;
      }
    }
  }

  void _updateTickerModeNotifier() {
    final ValueListenable<bool> newNotifier = TickerMode.getNotifier(context);
    if (newNotifier == _tickerModeNotifier) {
      return;
    }
    _tickerModeNotifier?.removeListener(_updateTickers);
    newNotifier.addListener(_updateTickers);
    _tickerModeNotifier = newNotifier;
  }

  @override
  void dispose() {
    // Added disposing for created entities
    _mainControllerInstance?.dispose();
    for (var instance in _controllerInstances) {
      instance.dispose();
    }
    // Original dispose code
    assert(() {
      if (_tickers != null) {
        for (final Ticker ticker in _tickers!) {
          if (ticker.isActive) {
            throw FlutterError.fromParts(<DiagnosticsNode>[
              ErrorSummary('$this was disposed with an active Ticker.'),
              ErrorDescription(
                '$runtimeType created a Ticker via its TickerProviderStateMixin, but at the time '
                'dispose() was called on the mixin, that Ticker was still active. All Tickers must '
                'be disposed before calling super.dispose().',
              ),
              ErrorHint(
                'Tickers used by AnimationControllers '
                'should be disposed by calling dispose() on the AnimationController itself. '
                'Otherwise, the ticker will leak.',
              ),
              ticker.describeForError('The offending ticker was'),
            ]);
          }
        }
      }
      return true;
    }());
    _tickerModeNotifier?.removeListener(_updateTickers);
    _tickerModeNotifier = null;
    super.dispose();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Set<Ticker>>(
      'tickers',
      _tickers,
      description: _tickers != null
          ? 'tracking ${_tickers!.length} ticker${_tickers!.length == 1 ? "" : "s"}'
          : null,
      defaultValue: null,
    ));
  }
}

// This class should really be called _DisposingTicker or some such, but this
// class name leaks into stack traces and error messages and that name would be
// confusing. Instead we use the less precise but more anodyne "_WidgetTicker",
// which attracts less attention.
class _WidgetTicker extends Ticker {
  _WidgetTicker(super.onTick, this._creator, {super.debugLabel});

  final AnimationMixin _creator;

  @override
  void dispose() {
    _creator._removeTicker(this);
    super.dispose();
  }
}
