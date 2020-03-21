import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:simple_animations_example_app/widgets/example_page.dart';

class GameArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text("Wait for the moles and hit it."),
        ...Iterable.generate(3).map((i) => rowWith2Moles()),
      ],
    );
  }

  Widget rowWith2Moles() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[Mole(), Mole()],
    );
  }
}

class Mole extends StatefulWidget {
  @override
  _MoleState createState() => _MoleState();
}

class _MoleState extends State<Mole> {
  final List<MoleParticle> particles = [];

  bool _moleIsVisible = false;

  @override
  void initState() {
    _restartMole();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      child: _buildMole(),
    );
  }

  Rendering _buildMole() {
    return Rendering(
      onTick: (time) => _manageParticleLifecycle(time),
      builder: (context, time) {
        return Stack(
          overflow: Overflow.visible,
          children: [
            if (_moleIsVisible)
              GestureDetector(onTap: () => _hitMole(time), child: _mole()),
            ...particles.map((it) => it.buildWidget(time))
          ],
        );
      },
    );
  }

  Widget _mole() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.brown, borderRadius: BorderRadius.circular(50)),
    );
  }

  _hitMole(Duration time) {
    _setMoleVisible(false);
    Iterable.generate(50).forEach((i) => particles.add(MoleParticle(time)));
  }

  void _restartMole() async {
    var respawnTime = Duration(milliseconds: 2000 + Random().nextInt(8000));
    await Future.delayed(respawnTime);
    _setMoleVisible(true);

    var timeVisible = Duration(milliseconds: 500 + Random().nextInt(1500));
    await Future.delayed(timeVisible);
    _setMoleVisible(false);

    _restartMole();
  }

  _manageParticleLifecycle(Duration time) {
    particles.removeWhere((particle) {
      return particle.progress.progress(time) == 1;
    });
  }

  void _setMoleVisible(bool visible) {
    setState(() {
      _moleIsVisible = visible;
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}

class MoleParticle {
  Animatable tween;
  AnimationProgress progress;

  MoleParticle(Duration time) {
    final random = Random();
    final x = (100 + 200) * random.nextDouble() * (random.nextBool() ? 1 : -1);
    final y = (100 + 200) * random.nextDouble() * (random.nextBool() ? 1 : -1);

    tween = MultiTrackTween([
      Track("x").add(Duration(seconds: 1), Tween(begin: 0.0, end: x)),
      Track("y").add(Duration(seconds: 1), Tween(begin: 0.0, end: y)),
      Track("scale").add(Duration(seconds: 1), Tween(begin: 1.0, end: 0.0))
    ]);
    progress = AnimationProgress(
        startTime: time, duration: Duration(milliseconds: 600));
  }

  buildWidget(Duration time) {
    final animation = tween.transform(progress.progress(time));
    return Positioned(
      left: animation["x"],
      top: animation["y"],
      child: Transform.scale(
        scale: animation["scale"],
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
              color: Colors.brown, borderRadius: BorderRadius.circular(50)),
        ),
      ),
    );
  }
}

class HitAMoleDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: "Hit a mole",
      pathToFile: "hit_a_mole.dart",
      delayStartup: false,
      builder: (context) => GameArea(),
    );
  }
}
