import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:simple_animations_example_app/widgets/example_page.dart';
import 'package:supercharged/supercharged.dart';

class ParticleBackgroundApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Positioned.fill(child: AnimatedBackground()),
      Positioned.fill(child: Particles(30)),
      Positioned.fill(child: CenteredText()),
    ]);
  }
}

class Particles extends StatefulWidget {
  final int numberOfParticles;

  Particles(this.numberOfParticles);

  @override
  _ParticlesState createState() => _ParticlesState();
}

class _ParticlesState extends State<Particles> {
  final Random random = Random();

  final List<ParticleModel> particles = [];

  @override
  void initState() {
    widget.numberOfParticles.times(() => particles.add(ParticleModel(random)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoopAnimation(
      tween: ConstantTween(1),
      builder: (context, child, _) {
        _simulateParticles();
        return CustomPaint(
          painter: ParticlePainter(particles),
        );
      },
    );
  }

  _simulateParticles() {
    particles
        .forEach((particle) => particle.checkIfParticleNeedsToBeRestarted());
  }
}

enum _OffsetProps { x, y }

class ParticleModel {
  MultiTween<_OffsetProps> tween;
  double size;
  Duration duration;
  Duration startTime;
  Random random;

  ParticleModel(this.random) {
    _restart();
    _shuffle();
  }

  _restart({Duration time = Duration.zero}) {
    final startPosition = Offset(-0.2 + 1.4 * random.nextDouble(), 1.2);
    final endPosition = Offset(-0.2 + 1.4 * random.nextDouble(), -0.2);

    tween = MultiTween<_OffsetProps>()
      ..add(_OffsetProps.x, startPosition.dx.tweenTo(endPosition.dx))
      ..add(_OffsetProps.y, startPosition.dy.tweenTo(endPosition.dy));

    duration = 3000.milliseconds + random.nextInt(6000).milliseconds;
    startTime = DateTime.now().duration();
    size = 0.2 + random.nextDouble() * 0.4;
  }

  void _shuffle() {
    startTime -= (this.random.nextDouble() * duration.inMilliseconds)
        .round()
        .milliseconds;
  }

  checkIfParticleNeedsToBeRestarted() {
    if (progress() == 1.0) {
      _restart();
    }
  }

  double progress() {
    return ((DateTime.now().duration() - startTime) / duration).clamp(0.0, 1.0);
  }
}

class ParticlePainter extends CustomPainter {
  List<ParticleModel> particles;

  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withAlpha(50);

    particles.forEach((particle) {
      final progress = particle.progress();
      final animation = particle.tween.transform(progress);
      final position = Offset(
        animation.get(_OffsetProps.x) * size.width,
        animation.get(_OffsetProps.y) * size.height,
      );
      canvas.drawCircle(position, size.width * 0.2 * particle.size, paint);
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

enum _ColorTween { color1, color2 }

class AnimatedBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<_ColorTween>()
      ..add(
        _ColorTween.color1,
        Color(0xff8a113a).tweenTo(Colors.lightBlue.shade900),
        3.seconds,
      )
      ..add(
        _ColorTween.color2,
        Color(0xff440216).tweenTo(Colors.blue.shade600),
        3.seconds,
      );

    return MirrorAnimation<MultiTweenValues<_ColorTween>>(
      tween: tween,
      duration: tween.duration,
      builder: (context, child, value) {
        return Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                value.get<Color>(_ColorTween.color1),
                value.get<Color>(_ColorTween.color2)
              ])),
        );
      },
    );
  }
}

class CenteredText extends StatelessWidget {
  const CenteredText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      "Welcome",
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w200),
      textScaleFactor: 4,
    ));
  }
}

class ParticleBackgroundDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: "Particle Background",
      pathToFile: "particle_background.dart",
      delayStartup: false,
      builder: (context) => ParticleBackgroundApp(),
    );
  }
}
