/// Simple Animation Framework
library simple_animations;

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:pedantic/pedantic.dart';
import 'package:supercharged/supercharged.dart';

export 'package:sa_v1_migration/sa_v1_migration.dart';

part 'anicoto/animation_controller_extension.dart';
part 'anicoto/animation_mixin.dart';
part 'liquid/plasma/plasma.dart';
part 'multi_tween/default_animation_properties.dart';
part 'multi_tween/multi_tween.dart';
part 'timeline_tween/timeline_tween.dart';
part 'stateless_animation/animated_widget_builder.dart';
part 'stateless_animation/custom_animation.dart';
part 'stateless_animation/loop_animation.dart';
part 'stateless_animation/mirror_animation.dart';
part 'stateless_animation/play_animation.dart';
