import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetingminutes52/models/contents_model.dart';
import 'package:meetingminutes52/models/models.dart' as model;
import 'package:meetingminutes52/theme/color_style.dart';
import 'package:meetingminutes52/theme/text_style.dart';

Widget loginButton(Widget widget, VoidCallback onPressed) {
  Map<String, Color> selectedColors = colorSetting[0];
  return SizedBox(
    width: 200,
    height: 50,
    child: ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(40)),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: selectedColors['ACCENT_COLOR'],
            textStyle:
                const TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
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
    icon: const Icon(
      Icons.arrow_drop_down,
      color: Color(0xff5D4037),
      size: 40,
    ),
    offset: const Offset(80, 40),
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

class BottomSheetStatusWidget extends GetView<MeetingMinuteController> {
  int index = 0;

  BottomSheetStatusWidget({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (index == -1) {
      controller.newAgendaStatus.value = model.status[0];
    } else {
      controller.newAgendaStatus.value =
          controller.meetingContentsModel[index].agendaStatus;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Status : ', style: bottomSheetSubTitleTextStyle()),
        Obx(() => Text(controller.newAgendaStatus.toString(),
            style: bottomSheetContentsTextStyle())),
        PopupMenuButton(
          padding: const EdgeInsets.only(top: 5.0),
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Color(0xff5D4037),
            size: 40,
          ),
          offset: const Offset(80, 40),
          onSelected: (String valueSelected) {
            controller.newAgendaStatus.value = valueSelected;
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            ...model.status.map<PopupMenuItem<String>>((String value) {
              return PopupMenuItem<String>(
                child: Center(child: Text(value)),
                value: value,
              );
            }).toList()
          ],
        ),
      ],
    );
  }
}

class BottomSheetIssuedByWidget extends GetView<MeetingMinuteController> {
  int number = 0;
  int index = 0;

  BottomSheetIssuedByWidget({Key? key, required this.number ,required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (number == -1) {
      controller.tempSelectedValues.value = '';
    } else {
      controller.tempSelectedValues.value =
          controller.meetingContentsModel[number].contentsModels[index].issuedBy;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Issued By : ', style: bottomSheetSubTitleTextStyle()),
        Obx(() => Text(controller.tempSelectedValues.toString(),
            style: bottomSheetContentsTextStyle())),
        PopupMenuButton(
          padding: const EdgeInsets.only(top: 5.0),
          child: const Icon(
            Icons.arrow_drop_down,
            color: Color(0xff5D4037),
            size: 40,
          ),
          offset: const Offset(80, 40),
          onSelected: (String valueSelected) {
            controller.tempSelectedValues.value = valueSelected;
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            ...controller.selectedValues
                .map((index) {
                  return model.peoples[index];
                })
                .toList()
                .map<PopupMenuItem<String>>((String value) {
                  return PopupMenuItem<String>(
                    child: Center(child: Text(value)),
                    value: value,
                  );
                })
                .toList()
          ],
        ),
      ],
    );
  }
}
