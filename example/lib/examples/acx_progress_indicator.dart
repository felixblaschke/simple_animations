import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:simple_animations_example_app/widgets/example_page.dart';
import 'package:supercharged/supercharged.dart';

class ProgressIndicatorAnimation extends StatefulWidget {
  @override
  _ProgressIndicatorAnimationState createState() =>
      _ProgressIndicatorAnimationState();
}

class _ProgressIndicatorAnimationState extends State<ProgressIndicatorAnimation>
    with AnimationMixin {
  AnimationController fadeInController;
  AnimationController fadeOutController;

  Animation<double> translateY;
  Animation<double> scale;

  @override
  void initState() {
    fadeInController = createController();
    fadeOutController = createController();

    translateY = (-100.0).tweenTo(0.0).animatedBy(fadeInController);
    scale = 1.0.tweenTo(0.0).animatedBy(fadeOutController);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[_progressIndicator(), _requestButton()],
    );
  }

  var _showCircularProgressIndicator = false;

  Widget _progressIndicator() {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Transform.translate(
        offset: Offset(0.0, translateY.value),
        child: Transform.scale(
          scale: scale.value,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            width: 40,
            height: 40,
            child: _showCircularProgressIndicator
                ? CircularProgressIndicator()
                : Container(),
          ),
        ),
      ),
    );
  }

  Widget _requestButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          MaterialButton(
            child: Text(
              "Load data",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: _loadData,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  _loadData() async {
    if (_showCircularProgressIndicator) {
      return;
    }

    _showCircularProgressIndicator = true;
    fadeInController.reset();
    fadeOutController.reset();

    // Simulate HTTP Request
    final futureHttpRequest = Future.delayed(4.seconds);

    final futureFadeIn = fadeInController.play(duration: 700.milliseconds);

    await Future.wait([futureHttpRequest, futureFadeIn]);

    // check if widget is still visible (otherwise animation will fail)
    if (mounted) {
      await fadeOutController.play(duration: 1200.milliseconds);
    }
    setState(() {
      if (mounted) {
        _showCircularProgressIndicator = false;
      }
    });
  }
}

class AcxProgressIndicatorDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: "Progress Indicator",
      pathToFile: "acx_progress_indicator.dart",
      delayStartup: false,
      builder: (context) => ProgressIndicatorAnimation(),
    );
  }
}
