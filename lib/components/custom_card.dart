import 'package:flutter/material.dart';

Widget agendaCardWidget({required Widget widget, required Color color}) {
  return Card(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
        side: const BorderSide(color: Color(0xff795548))),
    elevation: 1,
    margin: const EdgeInsets.all(2),
    color: color,
    child: Center(
      child: widget,
    ),
  );
}