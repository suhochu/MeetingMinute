import 'package:flutter/material.dart';

List<Map<String, Color>> colorSetting = [
  {
    'PRIMARY_COLOR': Color(0xff795548),
    'ACCENT_COLOR': Color(0xffFF5722),
    'DARK_PRIMARY_COLOR': Color(0xff5D4037),
    'LIGHT_PRIMARY_COLOR': Color(0xffD7CCC8),
    'TEXT_ICONS': Color(0xffFFFFFF),
    'PRIMARY_TEXT': Color(0xff212121),
    'SECONDARY_TEXT': Color(0xff757575),
    'DIVIDER_COLOR': Color(0xffBDBDBD),
  }
];

Widget smallTextStyle(
    {required String context, Color? color, GestureTapCallback? onTap}) {
  return Expanded(
      child: InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        context,
        style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: color),
        textAlign: TextAlign.center,
      ),
    ),
  ));
}
