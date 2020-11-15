part of sa_anicoto;

/// Extends your state class with the ability to manage an arbitrary number
/// of [AnimationController] instances. It takes care of initialization
/// and disposing of these instances.
///
/// Most use cases can be realized by start using [controller] as your main
/// [AnimationController] instance.
///
/// You can create additional instances of [AnimationController] by calling
/// [createController].
///
/// See API documentation for [controller] and [createController] for examples.
mixin AnimationMixin<T extends StatefulWidget> on State<T>
    implements TickerProvider {
  AnimationController _mainControllerInstance;

  final _controllerInstances = <AnimationController>[];

  /// Returns the main [AnimationController] instance for this state class.
  ///
  /// Example: (using [supercharged](https://pub.dev/packages/supercharged))
  /// ```dart
  /// class _MyAnimatedWidgetState extends State<MyAnimatedWidget>
  ///     with AnimationMixin {  // Add AnimationMixin to state class
  ///
  ///   Animation<double> size; // Declare animation variable
  ///
  ///   @override
  ///   void initState() {
  ///     size = 0.0.tweenTo(200.0).animatedBy(controller); // Connect tween and controller and apply to animation variable
  ///     controller.play(); // Start the animation playback
  ///     super.initState();
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Container(
  ///         width: size.value, // Use animation variable's value here
  ///         height: size.value, // Use animation variable's value here
  ///         color: Colors.red
  ///     );
  ///   }
  /// }
  /// ```
  AnimationController get controller {
    _mainControllerInstance ??= _newAnimationController();
    return _mainControllerInstance;
  }

  /// Creates an additional [AnimationController] instance that gets initialized
  /// and disposed by this mixin.
  ///
  /// You can create an unbound [AnimationController] by setting the [unbounded]
  /// parameter.
  ///
  /// Example: (using [supercharged](https://pub.dev/packages/supercharged))
  /// ```dart
  /// class _MyAnimatedWidgetState extends State<MyAnimatedWidget>
  ///     with AnimationMixin { // <-- use AnimationMixin
  ///
  ///   AnimationController sizeController; // <-- declare custom AnimationController
  ///   Animation<double> size;
  ///
  ///   @override
  ///   void initState() {
  ///     sizeController = createController(); // <-- create custom AnimationController
  ///     size = 0.0.tweenTo(100.0).animatedBy(sizeController); // <-- animate "size" with custom AnimationController
  ///     sizeController.play(duration: 5.seconds); // <-- start playback on custom AnimationController
  ///     super.initState();
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Container(width: size.value, height: size.value, color: Colors.red);
  ///   }
  /// }
  /// ```
  AnimationController createController({bool unbounded = false}) {
    final instance = _newAnimationController(unbounded: unbounded);
    _controllerInstances.add(instance);
    return instance;
  }

  AnimationController _newAnimationController({bool unbounded = false}) {
    AnimationController controller;
    if (!unbounded) {
      controller = AnimationController(vsync: this, duration: 1.seconds);
    } else {
      controller =
          AnimationController.unbounded(vsync: this, duration: 1.seconds);
    }

    controller.addListener(() => setState(() {}));
    return controller;
  }

  // below code from TickerProviderStateMixin (dispose method is modified) ----------------------------------------

  Set<Ticker> _tickers;

  @override
  Ticker createTicker(TickerCallback onTick) {
    _tickers ??= <_WidgetTicker>{};
    // ignore: omit_local_variable_types
    final _WidgetTicker result =
        _WidgetTicker(onTick, this, debugLabel: 'created by $this');
    _tickers.add(result);
    return result;
  }

  void _removeTicker(_WidgetTicker ticker) {
    assert(_tickers != null);
    assert(_tickers.contains(ticker));
    _tickers.remove(ticker);
  }

  @override
  void dispose() {
    // Added disposing for created entities
    if (_mainControllerInstance != null) {
      _mainControllerInstance.dispose();
    }
    _controllerInstances.forEach((instance) => instance.dispose());
    // Original dispose code
    assert(() {
      if (_tickers != null) {
        // ignore: omit_local_variable_types
        for (Ticker ticker in _tickers) {
          if (ticker.isActive) {
            throw FlutterError.fromParts(<DiagnosticsNode>[
              ErrorSummary('$this was disposed with an active Ticker.'),
              ErrorDescription(
                  '$runtimeType created a Ticker via its TickerProviderStateMixin, but at the time '
                  'dispose() was called on the mixin, that Ticker was still active. All Tickers must '
                  'be disposed before calling super.dispose().'),
              ErrorHint('Tickers used by AnimationControllers '
                  'should be disposed by calling dispose() on the AnimationController itself. '
                  'Otherwise, the ticker will leak.'),
              ticker.describeForError('The offending ticker was'),
            ]);
          }
        }
      }
      return true;
    }());
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // ignore: omit_local_variable_types
    final bool muted = !TickerMode.of(context);
    if (_tickers != null) {
      // ignore: omit_local_variable_types
      for (Ticker ticker in _tickers) {
        ticker.muted = muted;
      }
    }
    super.didChangeDependencies();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Set<Ticker>>(
      'tickers',
      _tickers,
      description: _tickers != null
          ? 'tracking ${_tickers.length} ticker${_tickers.length == 1 ? "" : "s"}'
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
  _WidgetTicker(TickerCallback onTick, this._creator, {String debugLabel})
      : super(onTick, debugLabel: debugLabel);

  final AnimationMixin _creator;

  @override
  void dispose() {
    _creator._removeTicker(this);
    super.dispose();
  }
}
