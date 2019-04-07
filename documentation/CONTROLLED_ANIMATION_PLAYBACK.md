# ControlledAnimation - Playback

Without explicit setting a the `playback` property your animation will
start at the beginning and stop at the end.

You can modify this behavior by setting the `playback` property.

## Overview

playback value | description
-------------- | ------------
Playback.PAUSE | Stops the animation at the current time.
Playback.PLAY_FORWARD | Starts the animation at the current time, playing forward and stops at the end.
Playback.PLAY_REVERSE | Starts the animation from the current time, playing backward and stops at the beginning.
Playback.START_OVER_FORWARD | Starts the animation from the beginning, playing forward and stops at the end.
Playback.START_OVER_REVERSE | Starts the animation from the end, playing backward and stops at the beginning.
Playback.LOOP | Starts the animation from the current time, playing forward and repeating from beginning when reaching the end. 
Playback.MIRROR | Starts the animation from the current time, playing forward until reaching the end. Then it turns around and plays backwards until the beginning. Then again forward. And so on. 

## Stateless example

```dart
class StatelessUseCase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ControlledAnimation(
        playback: Playback.MIRROR,
        duration: Duration(milliseconds: 1500),
        tween: ColorTween(begin: Colors.red, end: Colors.blue),
        builder: (context, color) {
          // return ...
        });
  }
}
```
This widget's animation will smoothly shift the colors from red to blue.


## Stateful example

```dart
class StatefulUseCase extends StatefulWidget {
  @override
  _StatefulUseCaseState createState() => _StatefulUseCaseState();
}

class _StatefulUseCaseState extends State<StatefulUseCase> {
  Playback playback = Playback.PLAY_FORWARD;

  void _togglePlaybackDirection() {
    setState(() {
      playback = playback == Playback.PLAY_FORWARD
          ? Playback.PLAY_REVERSE
          : Playback.PLAY_FORWARD;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlaybackDirection,
      child: ControlledAnimation(
          playback: playback,
          duration: Duration(milliseconds: 1500),
          tween: ColorTween(begin: Colors.red, end: Colors.blue),
          builder: (context, color) {
            // return ...
          }),
    );
  }
}
```
This widget can control dynamically the direction of the animation by
user interaction.