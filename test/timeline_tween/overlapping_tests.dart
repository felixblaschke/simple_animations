import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

void main() {
  test('overlapping property', () {
    var timeline = TimelineTween<Prop>();
    timeline
        .addScene(begin: 0.seconds, duration: 2.seconds)
        .animate(Prop.width, tween: 0.0.tweenTo(100.0));

    timeline
        .addScene(begin: 1.seconds, duration: 2.seconds)
        .animate(Prop.width, tween: 200.0.tweenTo(300.0));

    expect(timeline.transform(0.0 / 3.0).get<double>(Prop.width), 0.0);
    expect(timeline.transform(0.5 / 3.0).get<double>(Prop.width), 25.0);
    expect(timeline.transform(1.0 / 3.0).get<double>(Prop.width), 50.0);
    expect(timeline.transform(1.5 / 3.0).get<double>(Prop.width), 75.0);
    expect(timeline.transform(2.0 / 3.0).get<double>(Prop.width), 100.0);
    expect(timeline.transform(2.5 / 3.0).get<double>(Prop.width), 275.0);
    expect(timeline.transform(3.0 / 3.0).get<double>(Prop.width), 300.0);
  });

  test('between multiple scenes', () {
    var timeline = TimelineTween<Prop>();
    timeline
        .addScene(begin: 0.seconds, end: 1.seconds)
        .animate(Prop.width, tween: 10.0.tweenTo(20.0));

    timeline
        .addScene(begin: 2.seconds, end: 3.seconds)
        .animate(Prop.width, tween: 100.0.tweenTo(200.0));

    timeline
        .addScene(begin: 4.seconds, end: 5.seconds)
        .animate(Prop.width, tween: 1000.0.tweenTo(2000.0));

    expect(timeline.transform(1.5 / 5.0).get<double>(Prop.width), 20.0);
    expect(timeline.transform(3.5 / 5.0).get<double>(Prop.width), 200.0);
  });
}

enum Prop { width }
