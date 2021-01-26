import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

void main() {
  test('unused properties', () {
    var timeline = TimelineTween<Prop>();
    timeline.addScene(begin: 0.seconds, duration: 1.seconds);

    expect(() => timeline.transform(0.0).get<double>(Prop.width),
        throwsAssertionError);
  });
}

enum Prop { width }
