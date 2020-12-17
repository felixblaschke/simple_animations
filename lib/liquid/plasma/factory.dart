part of simple_animations;

class LiPlasmaComputeFactory {
  static LiPlasmaCompute create({
    PlasmaType type,
    double circleSize,
    double offset,
    Size canvasSize,
    double value,
    double blur,
    int particles,
    double variation1,
    double variation2,
    double variation3,
  }) {
    if (type == PlasmaType.bubbles) {
      return LiBubblesPlasmaCompute(
        value: value,
        offset: offset,
        canvasSize: canvasSize,
        circleSize: circleSize,
        variation1: variation1,
        variation2: variation2,
        variation3: variation3,
      );
    }

    if (type == PlasmaType.circle) {
      return LiCirclePlasmaCompute(
        particles: particles,
        value: value,
        offset: offset,
        canvasSize: canvasSize,
        circleSize: circleSize,
        variation1: variation1,
        variation2: variation2,
        variation3: variation3,
      );
    }

    if (type == PlasmaType.infinity) {
      // return default
    }

    return LiInfinityPlasmaCompute(
      value: value,
      offset: offset,
      canvasSize: canvasSize,
      circleSize: circleSize,
      variation1: variation1,
      variation2: variation2,
      variation3: variation3,
    );
  }
}
