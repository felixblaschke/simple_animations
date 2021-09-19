import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';

void main() {
  test('unused properties', () {
    var timeline = TimelineTween<Prop>();
    timeline.addScene(
        begin: const Duration(seconds: 0),
        duration: const Duration(seconds: 1));

    expect(() => timeline.transform(0.0).get<double>(Prop.width),
        throwsAssertionError);
  });
}

enum Prop { width }
