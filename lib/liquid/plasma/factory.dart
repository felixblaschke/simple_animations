part of simple_animations;

class LiPlasmaComputeFactory {
  static LiPlasmaCompute create({
    required PlasmaType type,
    required double circleSize,
    required double offset,
    required Size canvasSize,
    required double value,
    required double blur,
    required int particles,
    required double variation1,
    required double variation2,
    required double variation3,
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
