import 'package:flutter/material.dart';

InputDecoration textFormFieldInputStyle(String hintText, Widget? widget) {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(vertical: 10),
    isCollapsed: false,
    suffixIcon: widget,
    hintText: hintText,
    hintStyle: const TextStyle(fontSize: 16, color: Color(0xffD7CCC8)),
    fillColor: const Color(0xffD7CCC8).withOpacity(0.1),
    filled: true,
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: const Color(0xff795548).withOpacity(0.3),
      ),
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xff5D4037), width: 2),
    ),
  );
}

Widget contentsTextField(TextEditingController controller, String hintText, Widget? widget) {
  return Padding(
    padding: const EdgeInsets.symmetric(
        horizontal: 16.0, vertical: 15.0),
    child: TextField(
      controller: controller,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.start,
      decoration: textFormFieldInputStyle(hintText, widget),
      style: const TextStyle(color: Color(0xff5D4037)),
      maxLines: 2,
      maxLength: 100,
    ),
  );
}
