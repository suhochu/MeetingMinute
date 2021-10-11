import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetingminutes52/components/custom_card.dart';
import 'package:meetingminutes52/models/meeting_minute_controller.dart';
import 'package:meetingminutes52/models/meeting_resource_controller.dart';
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

class BottomSheetAgendaStatusWidget extends GetView<MeetingMinuteController> {
  int number = 0;

  BottomSheetAgendaStatusWidget({Key? key, required this.number}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (number == -1) {
      controller.tempAgendaStatus.value = model.status[0];
    } else {
      controller.tempAgendaStatus.value =
          controller.meetingContentsModel[number].agendaStatus;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Status : ', style: bottomSheetSubTitleTextStyle()),
        Obx(() => Text(controller.tempAgendaStatus.toString(),
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
            controller.tempAgendaStatus.value = valueSelected;
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

class BottomSheetContentsIssuedByWidget extends GetView<MeetingMinuteController> {
  int number = 0;
  int index = 0;

  BottomSheetContentsIssuedByWidget({Key? key, required this.number ,required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (number == -1) {
      controller.tempContentsIssuedBy.value = '';
    } else {
      controller.tempContentsIssuedBy.value =
          controller.meetingContentsModel[number].contentsModels[index].issuedBy;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text('Issued By : ', style: bottomSheetSubTitleTextStyle()),
        Obx(() => Text(controller.tempContentsIssuedBy.toString(),
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
            controller.tempContentsIssuedBy.value = valueSelected;
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

class BottomSheetTodoResponsibleWidget extends GetView<MeetingMinuteController> {
  int number = 0;
  int index = 0;

  BottomSheetTodoResponsibleWidget({Key? key, required this.number ,required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (number == -1) {
      controller.tempTodoResponsible.value = '';
    } else {
      controller.tempTodoResponsible.value =
          controller.meetingContentsModel[number].todoModels[index].responsible;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text('Responsible : ', style: bottomSheetSubTitleTextStyle()),
        Obx(() => Text(controller.tempTodoResponsible.toString(),
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
            controller.tempTodoResponsible.value = valueSelected;
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

class BottomSheetTodoEditingWidget extends GetView<MeetingMinuteController> {
  int number = 0;
  int index = 0;

  BottomSheetTodoEditingWidget({Key? key, required this.index, required this.number}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (number == -1) {
      controller.tempTodoStatus.value = model.status[0];
    } else {
      controller.tempTodoStatus.value =
          controller.meetingContentsModel[number].todoModels[index].todoStatus;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text('Status : ', style: bottomSheetSubTitleTextStyle()),
        Obx(() => Text(controller.tempTodoStatus.toString(),
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
            controller.tempTodoStatus.value = valueSelected;
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

Widget completeButton(VoidCallback onPressed){
  return Container(
    alignment: Alignment.center,
    child: ElevatedButton(
      child: const Text('완료'),
      style: ElevatedButton.styleFrom(
          primary: const Color(0xffFF5722),
          minimumSize: const Size(70, 35),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
      onPressed: onPressed,
    ),
  );
}

Padding AddingButtonWidget(String text) {
  return Padding(
    padding: const EdgeInsets.only(top: 10),
    child: agendaCardWidget(
      widget: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xffFFFFFF),
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      color: const Color(0xff795548),
    ),
  );
}