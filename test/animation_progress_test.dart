import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';

main() {
  test("simple progress computation", () {
    final progress = AnimationProgress(
        startTime: Duration.zero, duration: Duration(seconds: 1));

    expect(progress.progress(Duration(milliseconds: 0)), 0.0);
    expect(progress.progress(Duration(milliseconds: 500)), 0.5);
    expect(progress.progress(Duration(milliseconds: 1000)), 1.0);
  });

  test("non zero start times", () {
    final progress = AnimationProgress(
        startTime: Duration(milliseconds: 1500),
        duration: Duration(milliseconds: 1500));

    expect(progress.progress(Duration(milliseconds: 0)), 0.0);
    expect(progress.progress(Duration(milliseconds: 1000)), 0.0);
    expect(progress.progress(Duration(milliseconds: 1500)), 0.0);
    expect(progress.progress(Duration(milliseconds: 1515)), 0.01);
    expect(progress.progress(Duration(milliseconds: 1650)), 0.10);
    expect(progress.progress(Duration(milliseconds: 2250)), 0.5);
    expect(progress.progress(Duration(milliseconds: 2625)), 0.75);
    expect(progress.progress(Duration(milliseconds: 3000)), 1.0);
    expect(progress.progress(Duration(milliseconds: 4000)), 1.0);
    expect(progress.progress(Duration(milliseconds: 5000)), 1.0);
  });
}
