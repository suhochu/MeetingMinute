import 'package:flutter/material.dart';

Widget smallTextStyleInsideAgenda(
    {required String context, Color? color, GestureTapCallback? onTap}) {
  return Expanded(
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          context,
          style: TextStyle(
            fontSize: 12,
            fontStyle: FontStyle.italic,
            color: color,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}

TextStyle bottomSheetContentsTextStyle() {
  return const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: Color(0xff212121),
    fontStyle: FontStyle.italic,
  );
}

TextStyle bottomSheetTitleTextStyle() {
  return const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );
}

TextStyle bottomSheetSubTitleTextStyle() {
  return const TextStyle(
      fontWeight: FontWeight.w200,
      fontSize: 16,
      color: Color(0xff212121)
  );
}
