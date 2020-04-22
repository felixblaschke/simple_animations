import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:simple_animations_example_app/widgets/example_page.dart';
import 'package:supercharged/supercharged.dart';

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

  Widget _buildMole() {
    _manageParticleLifecycle();
    return LoopAnimation<int>(
      tween: ConstantTween(1),
      builder: (context, child, value) {
        return Stack(
          overflow: Overflow.visible,
          children: [
            if (_moleIsVisible)
              GestureDetector(onTap: () => _hitMole(), child: _mole()),
            ...particles.map((it) => it.buildWidget())
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

  _hitMole() {
    _setMoleVisible(false);
    Iterable.generate(50).forEach((i) => particles.add(MoleParticle()));
  }

  void _restartMole() async {
    var respawnTime = (2000 + Random().nextInt(8000)).milliseconds;
    await Future.delayed(respawnTime);
    _setMoleVisible(true);

    var timeVisible = (500 + Random().nextInt(1500)).milliseconds;
    await Future.delayed(timeVisible);
    _setMoleVisible(false);

    _restartMole();
  }

  _manageParticleLifecycle() {
    particles.removeWhere((particle) {
      return particle.progress() == 1;
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

enum _MoleProps { x, y, scale }

class MoleParticle {
  Animatable<MultiTweenValues<_MoleProps>> tween;
  Duration startTime;
  final duration = 600.milliseconds;

  MoleParticle() {
    final random = Random();
    final x = (100 + 200) * random.nextDouble() * (random.nextBool() ? 1 : -1);
    final y = (100 + 200) * random.nextDouble() * (random.nextBool() ? 1 : -1);

    tween = MultiTween<_MoleProps>()
      ..add(_MoleProps.x, 0.0.tweenTo(x))
      ..add(_MoleProps.y, 0.0.tweenTo(y))
      ..add(_MoleProps.scale, 1.0.tweenTo(0.0));

    startTime = DateTime.now().duration();
  }

  Widget buildWidget() {
    final MultiTweenValues<_MoleProps> values = tween.transform(progress());

    return Positioned(
      left: values.get(_MoleProps.x),
      top: values.get(_MoleProps.y),
      child: Transform.scale(
        scale: values.get(_MoleProps.scale),
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
              color: Colors.brown, borderRadius: BorderRadius.circular(50)),
        ),
      ),
    );
  }

  double progress() {
    return ((DateTime.now().duration() - startTime) / duration)
        .clamp(0.0, 1.0)
        .toDouble();
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
