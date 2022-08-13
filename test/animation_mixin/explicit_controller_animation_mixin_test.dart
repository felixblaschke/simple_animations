import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';

import '../util/widget_tester_extension.dart';

void main() {
  testWidgets('AnimationMixin - Explicit Controller',
      (WidgetTester tester) async {
    var values = <int>[];
    var animation = MaterialApp(home: TestWidget(values.add));

    await tester.addAnimationWidget(animation);

    for (var i = 0; i < 200; i++) {
      await tester.wait(const Duration(days: 1));
    }

    expect(values, expectedValues);
  });
}

class TestWidget extends StatefulWidget {
  final Function(int) exposeValue;

  const TestWidget(this.exposeValue, {Key? key}) : super(key: key);

  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> with AnimationMixin {
  late Animation<int> a;

  @override
  void initState() {
    a = IntTween(begin: 1000, end: 1100)
        .animate(createController()..play(duration: const Duration(days: 100)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.exposeValue(a.value);
    return Container();
  }
}

const expectedValues = [
  1000,
  1000,
  1001,
  1001,
  1002,
  1002,
  1003,
  1003,
  1004,
  1004,
  1005,
  1005,
  1006,
  1006,
  1007,
  1007,
  1008,
  1008,
  1009,
  1009,
  1010,
  1010,
  1011,
  1011,
  1012,
  1012,
  1013,
  1013,
  1014,
  1014,
  1015,
  1015,
  1016,
  1016,
  1017,
  1017,
  1018,
  1018,
  1019,
  1019,
  1020,
  1020,
  1021,
  1021,
  1022,
  1022,
  1023,
  1023,
  1024,
  1024,
  1025,
  1025,
  1026,
  1026,
  1027,
  1027,
  1028,
  1028,
  1029,
  1029,
  1030,
  1030,
  1031,
  1031,
  1032,
  1032,
  1033,
  1033,
  1034,
  1034,
  1035,
  1035,
  1036,
  1036,
  1037,
  1037,
  1038,
  1038,
  1039,
  1039,
  1040,
  1040,
  1041,
  1041,
  1042,
  1042,
  1043,
  1043,
  1044,
  1044,
  1045,
  1045,
  1046,
  1046,
  1047,
  1047,
  1048,
  1048,
  1049,
  1049,
  1050,
  1050,
  1051,
  1051,
  1052,
  1052,
  1053,
  1053,
  1054,
  1054,
  1055,
  1055,
  1056,
  1056,
  1057,
  1057,
  1058,
  1058,
  1059,
  1059,
  1060,
  1060,
  1061,
  1061,
  1062,
  1062,
  1063,
  1063,
  1064,
  1064,
  1065,
  1065,
  1066,
  1066,
  1067,
  1067,
  1068,
  1068,
  1069,
  1069,
  1070,
  1070,
  1071,
  1071,
  1072,
  1072,
  1073,
  1073,
  1074,
  1074,
  1075,
  1075,
  1076,
  1076,
  1077,
  1077,
  1078,
  1078,
  1079,
  1079,
  1080,
  1080,
  1081,
  1081,
  1082,
  1082,
  1083,
  1083,
  1084,
  1084,
  1085,
  1085,
  1086,
  1086,
  1087,
  1087,
  1088,
  1088,
  1089,
  1089,
  1090,
  1090,
  1091,
  1091,
  1092,
  1092,
  1093,
  1093,
  1094,
  1094,
  1095,
  1095,
  1096,
  1096,
  1097,
  1097,
  1098,
  1098,
  1099,
  1099,
  1100
];
