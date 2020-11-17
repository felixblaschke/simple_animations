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

  Plasma({
    Key key,
    this.particles = 10,
    this.foregroundColor = Colors.white,
    this.backgroundColor = Colors.black,
    this.size = 1.0,
    this.speed = 1.0,
    this.offset = 0.0,
    this.fps,
    this.blendMode,
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
          fps: fps,
          duration:
              speed > 0 ? (120000.0 / speed).round().milliseconds : 1.seconds,
          builder: (context, child, value) {
            return CustomPaint(
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
    final circleRadius =
        (circleSize * (size.width + size.height) / 2 / 3).roundToDouble();
    final blurRadius = (circleRadius * 1.2).roundToDouble();
    var paint = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius)
      ..blendMode = blendMode;

    0.until(particles).forEach((n) {
      var rand = sin(n).abs();
      var rvalue = (value + rand * 2 * pi) % (2 * pi);

      var x = sin(-rand + rvalue + offset) * size.width / 2;
      var y = sin(rand + -2 * rvalue + offset) * size.height / 2;

      var center = Offset(size.width / 2 + x, size.height / 2 + y);
      canvas.drawCircle(center, circleRadius, paint);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
