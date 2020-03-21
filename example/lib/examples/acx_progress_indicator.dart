import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:simple_animations_example_app/widgets/example_page.dart';

class ProgressIndicatorAnimation extends StatefulWidget {
  @override
  _ProgressIndicatorAnimationState createState() =>
      _ProgressIndicatorAnimationState();
}

class _ProgressIndicatorAnimationState extends State<ProgressIndicatorAnimation>
    with AnimationControllerMixin {
  Animation tween;

  @override
  void initState() {
    tween = MultiTrackTween([
      Track("translateY")
          .add(Duration(seconds: 1), Tween(begin: -100.0, end: 0.0)),
      Track("scale")
          .add(Duration(seconds: 1), ConstantTween(1.0))
          .add(Duration(seconds: 1), Tween(begin: 1.0, end: 0.0)),
    ]).animate(controller);

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
        offset: Offset(0, tween.value["translateY"]),
        child: Transform.scale(
          scale: tween.value["scale"],
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

  var _dataIsLoaded = false;

  _loadData() {
    // Simulate HTTP Request
    _dataIsLoaded = false;
    Future.delayed(Duration(seconds: 4)).then((_) => _dataIsLoaded = true);

    controller.addTasks([
      FromToTask(
          duration: Duration(milliseconds: 700),
          from: 0,
          to: 0.5,
          onStart: () => _showCircularProgressIndicator = true),
      ConditionalTask(
        predicate: () => _dataIsLoaded,
      ),
      FromToTask(
          duration: Duration(milliseconds: 1500),
          from: 0.5,
          to: 1.0,
          onComplete: () => _showCircularProgressIndicator = false)
    ]);
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
