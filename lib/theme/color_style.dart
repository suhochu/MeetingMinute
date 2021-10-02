import 'package:flutter/material.dart';

List<Map<String, Color>> colorSetting = [
  {
    'PRIMARY_COLOR': const Color(0xff795548),
    'ACCENT_COLOR': const Color(0xffFF5722),
    'DARK_PRIMARY_COLOR': const Color(0xff5D4037),
    'LIGHT_PRIMARY_COLOR': const Color(0xffD7CCC8),
    'TEXT_ICONS': const Color(0xffFFFFFF),
    'PRIMARY_TEXT': const Color(0xff212121),
    'SECONDARY_TEXT': const Color(0xff757575),
    'DIVIDER_COLOR': const Color(0xffBDBDBD),
  }
];

Color selectColor(String status) {
  switch (status) {
    case 'Initiated':
      return const Color(0xff212121);
    case 'Processing':
      return Colors.lightGreen;
    case 'Delayed':
      return Colors.redAccent;
    case 'Done':
      return Colors.blueAccent;
    case 'Deprecated':
      return Colors.yellowAccent;
    default:
      return const Color(0xff212121);
  }
}

