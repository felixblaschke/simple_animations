import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';

void main() {
  test('shift', () {
    var timeline = TimelineTween<Prop>();
    timeline
        .addScene(
            begin: const Duration(seconds: 2), end: const Duration(seconds: 4))
        .animate(
          Prop.width,
          tween: Tween(begin: 100.0, end: 200.0),
          shiftBegin: -const Duration(seconds: 1),
          shiftEnd: const Duration(seconds: 2),
        );

    expect(timeline.duration, const Duration(seconds: 6));
    expect(timeline.transform(0.0 / 6.0).get<double>(Prop.width), 100.0);
    expect(timeline.transform(1.0 / 6.0).get<double>(Prop.width), 100.0);
    expect(timeline.transform(2.0 / 6.0).get<double>(Prop.width), 120.0);
    expect(timeline.transform(3.0 / 6.0).get<double>(Prop.width), 140.0);
    expect(timeline.transform(4.0 / 6.0).get<double>(Prop.width), 160.0);
    expect(timeline.transform(5.0 / 6.0).get<double>(Prop.width), 180.0);
    expect(timeline.transform(6.0 / 6.0).get<double>(Prop.width), 200.0);
  });
}

enum Prop { width }
