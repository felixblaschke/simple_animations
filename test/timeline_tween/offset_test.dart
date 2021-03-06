import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

void main() {
  test('shift', () {
    var timeline = TimelineTween<Prop>();
    timeline.addScene(begin: 2.seconds, end: 4.seconds).animate(
          Prop.width,
          tween: 100.0.tweenTo(200.0),
          shiftBegin: -1.seconds,
          shiftEnd: 2.seconds,
        );

    expect(timeline.duration, 6.seconds);
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
