import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetingminutes52/models/contents_model.dart';
import 'package:meetingminutes52/theme/style.dart';

Widget loginButton(Widget widget, VoidCallback onPressed) {

  Map<String, Color> selectedColors = colorSetting[0];
  return SizedBox(
    width: 200,
    height: 50,
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(40)),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: selectedColors['ACCENT_COLOR'],
              textStyle: TextStyle(
            fontSize: 17, fontWeight: FontWeight.w500
        )
        ),
        onPressed: onPressed,
        child: widget,
      ),
    ),
  );
}

PopupMenuButton<String> customPopupMenuButton(
    TextEditingController textController, List<String> options) {
  var controller = Get.put<MeetingMinuteController>(MeetingMinuteController());
  return PopupMenuButton(
    padding: const EdgeInsets.only(top: 5.0),
    icon: Icon(
      Icons.arrow_drop_down,
      color: Color(0xff5D4037),
      size: 40,
    ),
    offset: Offset(80, 40),
    onSelected: (String valueSelected) {
      textController.text = valueSelected;
      controller.formKey.currentState!.save();
    },
    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
      ...options.map<PopupMenuItem<String>>((String value) {
        return PopupMenuItem<String>(
          child: Center(child: Text(value)),
          value: value,
        );
      }).toList()
    ],
  );
}


