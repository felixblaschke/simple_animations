import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';

main() {
  test('empty tracks => error', () {
    expect(() => MultiTrackTween([]), throwsA(isAssertionError));
  });

  test('unconfigured track', () {
    expect(() => MultiTrackTween([Track("test")]), throwsA(isAssertionError));
  });

  test('track name must not be null', () {
    expect(() => MultiTrackTween([Track(null)]), throwsA(isAssertionError));
  });

  test('invalid parameter on track - duration', () {
    expect(() => MultiTrackTween([Track("test").add(null, ConstantTween(1))]),
        throwsA(isAssertionError));
  });

  test('invalid parameter on track - tween', () {
    expect(
        () => MultiTrackTween([Track("test").add(Duration(seconds: 1), null)]),
        throwsA(isAssertionError));
  });

  test('one track - one item', () {
    final tween = MultiTrackTween([
      Track("a").add(Duration(milliseconds: 1000), IntTween(begin: 0, end: 100))
    ]);

    expect(tween.duration, Duration(milliseconds: 1000));
    expect(tween.transform(0.0), {"a": 0});
    expect(tween.transform(0.5), {"a": 50});
    expect(tween.transform(1.0), {"a": 100});
  });

  test('one track - multiple items', () {
    final tween = MultiTrackTween([
      Track("a")
          .add(Duration(milliseconds: 1000), IntTween(begin: 0, end: 100))
          .add(Duration(milliseconds: 500), IntTween(begin: 100, end: 50))
    ]);

    expect(tween.duration, Duration(milliseconds: 1500));
    expect(tween.transform(0.0), {"a": 0});
    expect(tween.transform(1 / 3), {"a": 50});
    expect(tween.transform(2 / 3), {"a": 100});
    expect(tween.transform(1.0), {"a": 50});
  });

  test('multiple tracks', () {
    final tween = MultiTrackTween([
      Track("a")
          .add(Duration(milliseconds: 1000), IntTween(begin: 0, end: 100))
          .add(Duration(milliseconds: 500), IntTween(begin: 100, end: 50)),
      Track("b")
          .add(Duration(milliseconds: 500), IntTween(begin: 200, end: 100))
          .add(Duration(milliseconds: 500), IntTween(begin: 100, end: 0))
    ]);

    expect(tween.duration, Duration(milliseconds: 1500));
    expect(tween.transform(0.0), {"a": 0, "b": 200});
    expect(tween.transform(1 / 3), {"a": 50, "b": 100});
    expect(tween.transform(0.5), {"a": 75, "b": 50});
    expect(tween.transform(2 / 3), {"a": 100, "b": 0});
    expect(tween.transform(1.0), {"a": 50, "b": 0});
  });

  test('curved track items', () {
    final tween = MultiTrackTween([
      Track("a")
          .add(Duration(milliseconds: 1000), IntTween(begin: 0, end: 100),
              curve: Curves.easeIn)
          .add(Duration(milliseconds: 1000), IntTween(begin: 100, end: 200),
              curve: Curves.linear)
          .add(Duration(milliseconds: 1000), IntTween(begin: 200, end: 300),
              curve: Curves.easeOut)
    ]);

    expect(tween.duration, Duration(milliseconds: 3000));
    expect(tween.transform(0.0), {"a": 0});
    expect(tween.transform(0.1), {"a": 30});
    expect(tween.transform(0.2), {"a": 60});
    expect(tween.transform(1 / 3), {"a": 100});
    expect(tween.transform(0.4), {"a": 120});
    expect(tween.transform(0.6), {"a": 180});
    expect(tween.transform(2 / 3), {"a": 200});
    expect(tween.transform(0.8), {"a": 240});
    expect(tween.transform(0.9), {"a": 270});
    expect(tween.transform(1.0), {"a": 300});
  });
}
