import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';

void main() {
  testWidgets(
    'AnimationDeveloperTools shows waiting state without a controller',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AnimationDeveloperTools(child: SizedBox())),
        ),
      );

      expect(
        find.text('Waiting for widget to enable Developer Mode...'),
        findsOneWidget,
      );
      expect(find.byType(Slider), findsNothing);
    },
  );

  testWidgets('AnimationDeveloperTools controls the connected animation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AnimationDeveloperTools(
            child: CustomAnimationBuilder<int>(
              developerMode: true,
              duration: const Duration(seconds: 10),
              tween: IntTween(begin: 0, end: 100),
              builder: (context, value, child) => Text('$value'),
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(Slider), findsOneWidget);
    expect(find.text('1x'), findsOneWidget);
    expect(find.text('0 ms'), findsOneWidget);

    final playValue = sliderValue(tester);
    await tester.pump(const Duration(seconds: 1));
    expect(sliderValue(tester), greaterThan(playValue));

    await tester.tap(find.byIcon(Icons.play_arrow));
    await tester.pump();

    final pausedValue = sliderValue(tester);
    await tester.pump(const Duration(seconds: 1));
    expect(sliderValue(tester), pausedValue);

    await tester.tap(find.byIcon(Icons.fast_rewind));
    await tester.pump();
    expect(find.text('1/2x'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.fast_forward));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.fast_forward));
    await tester.pump();
    expect(find.text('2x'), findsOneWidget);
  });

  testWidgets('AnimationDeveloperTools updates slider bounds', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AnimationDeveloperTools(
            child: CustomAnimationBuilder<double>(
              developerMode: true,
              duration: const Duration(seconds: 10),
              tween: Tween(begin: 0, end: 1),
              builder: (context, value, child) => const SizedBox(),
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    await tester.tap(find.byIcon(Icons.play_arrow));
    await tester.pump();

    setSliderValue(tester, 0.7);
    await tester.pump();
    await tester.tap(find.byIcon(Icons.keyboard_tab).at(0));
    await tester.pump();

    setSliderValue(tester, 0.3);
    await tester.pump();
    await tester.tap(find.byIcon(Icons.keyboard_tab).at(1));
    await tester.pump();

    expect(toolbarBoundIcon(tester, 0).color, Colors.white);
    expect(toolbarBoundIcon(tester, 1).color, Colors.white);

    setSliderValue(tester, 0.4);
    await tester.pump();
    await tester.tap(find.byIcon(Icons.keyboard_tab).at(0));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.keyboard_tab).at(1));
    await tester.pump();

    expect(toolbarBoundIcon(tester, 0).color, Colors.grey);
    expect(toolbarBoundIcon(tester, 1).color, Colors.grey);
  });

  testWidgets('AnimationDeveloperTools hidden position keeps toolbar hidden', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AnimationDeveloperTools(
            position: AnimationDeveloperToolsPosition.hidden,
            child: CustomAnimationBuilder<int>(
              developerMode: true,
              duration: const Duration(seconds: 1),
              tween: IntTween(begin: 0, end: 100),
              builder: (context, value, child) => Text('$value'),
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(Slider), findsNothing);
    expect(
      find.text('Waiting for widget to enable Developer Mode...'),
      findsNothing,
    );
    expect(find.text('0'), findsOneWidget);
  });

  test('AnimationControllerTransfer only notifies for changed providers', () {
    void provider(AnimationController controller) {}
    void otherProvider(AnimationController controller) {}

    final transfer = AnimationControllerTransfer(
      controllerProvider: provider,
      child: const SizedBox(),
    );

    expect(
      transfer.updateShouldNotify(
        AnimationControllerTransfer(
          controllerProvider: provider,
          child: const SizedBox(),
        ),
      ),
      isFalse,
    );
    expect(
      transfer.updateShouldNotify(
        AnimationControllerTransfer(
          controllerProvider: otherProvider,
          child: const SizedBox(),
        ),
      ),
      isTrue,
    );
  });
}

double sliderValue(WidgetTester tester) {
  return tester.widget<Slider>(find.byType(Slider)).value;
}

void setSliderValue(WidgetTester tester, double value) {
  tester.widget<Slider>(find.byType(Slider)).onChanged!(value);
}

Icon toolbarBoundIcon(WidgetTester tester, int index) {
  return tester.widget<Icon>(find.byIcon(Icons.keyboard_tab).at(index));
}
