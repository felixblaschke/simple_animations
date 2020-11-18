part of sa_liquid;

class Plasma extends StatelessWidget {
  final int particles;
  final Color foregroundColor;
  final Color backgroundColor;
  final double size;
  final double speed;
  final int fps;
  final BlendMode blendMode;
  final double offset;
  final Widget child;

  Plasma({
    Key key,
    this.particles = 10,
    this.foregroundColor = Colors.white,
    this.backgroundColor = Colors.black,
    this.size = 1.0,
    this.speed = 1.0,
    this.offset = 0.0,
    this.fps,
    this.blendMode = BlendMode.srcOver,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      clipBehavior: Clip.hardEdge,
      child: CustomAnimation<double>(
          control: speed > 0
              ? CustomAnimationControl.LOOP
              : CustomAnimationControl.STOP,
          tween: 0.0.tweenTo(2 * pi),
          child: child,
          fps: fps,
          duration:
              speed > 0 ? (120000.0 / speed).round().milliseconds : 1.seconds,
          builder: (context, animatedChild, value) {
            return Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    foregroundPainter: _PlasmaPainter(
                      particles: particles,
                      value: value,
                      color: foregroundColor,
                      circleSize: size,
                      blendMode: blendMode,
                      offset: offset,
                    ),
                    child: Container(
                      color: backgroundColor,
                    ),
                  ),
                ),
                if (animatedChild != null)
                  Positioned.fill(
                    child: animatedChild,
                  )
              ],
            );
          }),
    );
  }
}

class _PlasmaPainter extends CustomPainter {
  final int particles;
  final double value;
  final Color color;
  final double circleSize;
  final BlendMode blendMode;
  final double offset;

  _PlasmaPainter(
      {this.particles,
      this.value,
      this.color,
      this.circleSize,
      this.blendMode,
      this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    var compute = PlasmaCompute(
        circleSize: circleSize, offset: offset, canvasSize: size, value: value);

    var paint = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, compute.blurRadius())
      ..blendMode = blendMode;

    0.until(particles).forEach((n) {
      canvas.drawCircle(compute.position(n), compute.radius(), paint);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
