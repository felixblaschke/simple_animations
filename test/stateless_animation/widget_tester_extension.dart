import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

extension WidgetTesterExtension on WidgetTester {
  Future<void> addAnimationWidget(Widget widget) async {
    await pumpWidget(widget);
    await pump(const Duration(milliseconds: 100));
  }

  Future<void> wait(Duration duration) async {
    await pump(duration);
    await pump(const Duration(milliseconds: 100));
  }
}
