import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';

main() {
  testWidgets("simple rendering", (WidgetTester tester) async {
    Text text;
    final rendering = Rendering(
      builder: (context, timeElapsed) {
        text = Text(timeElapsed.inMilliseconds.toString());
        return MaterialApp(home: text);
      },
    );

    await tester.pumpWidget(rendering);
    expect(contentOf(text), "0");

    await tester.pump(Duration(milliseconds: 100));
    expect(contentOf(text), "100");

    await tester.pump(Duration(seconds: 100));
    expect(contentOf(text), "100100");
  });

  testWidgets("onTick function", (WidgetTester tester) async {
    int elapsedMillis;
    int onTickCalled = 0;
    final rendering = Rendering(
      onTick: (time) {
        onTickCalled++;
        elapsedMillis = time.inMilliseconds;
      },
      builder: (context, timeElapsed) {
        return MaterialApp(home: Text("Anything"));
      },
    );

    await tester.pumpWidget(rendering);

    await tester.pump(Duration(milliseconds: 16));
    expect(onTickCalled, 1);
    expect(elapsedMillis, 16);

    await tester.pump(Duration(milliseconds: 16));
    expect(onTickCalled, 2);
    expect(elapsedMillis, 32);
  });

  testWidgets("fast forward", (WidgetTester tester) async {
    List<int> onTickCalls = [];
    Text text;
    final rendering = Rendering(
      startTime: Duration(seconds: 10),
      startTimeSimulationTicks: 10,
      onTick: (timeElapsed) {
        onTickCalls.add(timeElapsed.inMilliseconds);
      },
      builder: (context, timeElapsed) {
        text = Text(timeElapsed.inMilliseconds.toString());
        return MaterialApp(home: text);
      },
    );

    await tester.pumpWidget(rendering);
    await tester.pump(Duration(milliseconds: 100));
    expect(contentOf(text), "10100");

    expect(onTickCalls.length, 12);
    expect(onTickCalls, [
      0,
      1000,
      2000,
      3000,
      4000,
      5000,
      6000,
      7000,
      8000,
      9000,
      10000,
      10100
    ]);

    await tester.pump(Duration(milliseconds: 1000));
    expect(onTickCalls.length, 13);
    expect(onTickCalls[12], 11100);
  });
}

contentOf(Text text) {
  final textToString = text.toString();
  return textToString.substring('Text("'.length, textToString.length - 2);
}
