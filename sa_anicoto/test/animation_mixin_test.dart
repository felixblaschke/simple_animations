import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sa_anicoto/sa_anicoto.dart';
import 'package:supercharged/supercharged.dart';
import './widget_tester_extension.dart';

void main() {
  testWidgets('AnimationMixin', (WidgetTester tester) async {
    var values = <int>[];
    var animation = MaterialApp(home: TestWidget(values.add));

    await tester.addAnimationWidget(animation);

    for (var i = 0; i < 200; i++) {
      await tester.wait(1.days);
    }

    expect(values, expectedValues);
  });
}

class TestWidget extends StatefulWidget {
  final Function(int) exposeValue;

  TestWidget(this.exposeValue);

  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> with AnimationMixin {
  Animation<int> a;
  Animation<int> b;

  @override
  void initState() {
    a = 0.tweenTo(100).animatedBy(controller..play(duration: 100.days));
    b = 1000.tweenTo(1100).animatedBy(createController()..play(duration: 100.days));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.exposeValue(a.value);
    widget.exposeValue(b.value);
    return Container();
  }
}

const expectedValues = [0, 1000, 0, 1000, 1, 1001, 1, 1001, 2, 1002, 2, 1002, 3, 1003, 3, 1003, 4, 1004, 4, 1004, 5, 1005, 5, 1005, 6, 1006, 6, 1006, 7, 1007, 7, 1007, 8, 1008, 8, 1008, 9, 1009, 9, 1009, 10, 1010, 10, 1010, 11, 1011, 11, 1011, 12, 1012, 12, 1012, 13, 1013, 13, 1013, 14, 1014, 14, 1014, 15, 1015, 15, 1015, 16, 1016, 16, 1016, 17, 1017, 17, 1017, 18, 1018, 18, 1018, 19, 1019, 19, 1019, 20, 1020, 20, 1020, 21, 1021, 21, 1021, 22, 1022, 22, 1022, 23, 1023, 23, 1023, 24, 1024, 24, 1024, 25, 1025, 25, 1025, 26, 1026, 26, 1026, 27, 1027, 27, 1027, 28, 1028, 28, 1028, 29, 1029, 29, 1029, 30, 1030, 30, 1030, 31, 1031, 31, 1031, 32, 1032, 32, 1032, 33, 1033, 33, 1033, 34, 1034, 34, 1034, 35, 1035, 35, 1035, 36, 1036, 36, 1036, 37, 1037, 37, 1037, 38, 1038, 38, 1038, 39, 1039, 39, 1039, 40, 1040, 40, 1040, 41, 1041, 41, 1041, 42, 1042, 42, 1042, 43, 1043, 43, 1043, 44, 1044, 44, 1044, 45, 1045, 45, 1045, 46, 1046, 46, 1046, 47, 1047, 47, 1047, 48, 1048, 48, 1048, 49, 1049, 49, 1049, 50, 1050, 50, 1050, 51, 1051, 51, 1051, 52, 1052, 52, 1052, 53, 1053, 53, 1053, 54, 1054, 54, 1054, 55, 1055, 55, 1055, 56, 1056, 56, 1056, 57, 1057, 57, 1057, 58, 1058, 58, 1058, 59, 1059, 59, 1059, 60, 1060, 60, 1060, 61, 1061, 61, 1061, 62, 1062, 62, 1062, 63, 1063, 63, 1063, 64, 1064, 64, 1064, 65, 1065, 65, 1065, 66, 1066, 66, 1066, 67, 1067, 67, 1067, 68, 1068, 68, 1068, 69, 1069, 69, 1069, 70, 1070, 70, 1070, 71, 1071, 71, 1071, 72, 1072, 72, 1072, 73, 1073, 73, 1073, 74, 1074, 74, 1074, 75, 1075, 75, 1075, 76, 1076, 76, 1076, 77, 1077, 77, 1077, 78, 1078, 78, 1078, 79, 1079, 79, 1079, 80, 1080, 80, 1080, 81, 1081, 81, 1081, 82, 1082, 82, 1082, 83, 1083, 83, 1083, 84, 1084, 84, 1084, 85, 1085, 85, 1085, 86, 1086, 86, 1086, 87, 1087, 87, 1087, 88, 1088, 88, 1088, 89, 1089, 89, 1089, 90, 1090, 90, 1090, 91, 1091, 91, 1091, 92, 1092, 92, 1092, 93, 1093, 93, 1093, 94, 1094, 94, 1094, 95, 1095, 95, 1095, 96, 1096, 96, 1096, 97, 1097, 97, 1097, 98, 1098, 98, 1098, 99, 1099, 99, 1099, 100, 1100];