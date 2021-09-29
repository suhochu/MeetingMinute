import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetingminutes52/components/buttons.dart';
import 'package:meetingminutes52/components/multi_select.dart';
import 'package:meetingminutes52/components/textFieldStyle.dart';
import 'package:meetingminutes52/components/timePicker.dart';
import 'package:meetingminutes52/models/contents_model.dart';
import 'package:meetingminutes52/models/models.dart' as model;

class MeetingMinutePage extends GetView<MeetingMinuteController> {

  final TextEditingController meetingTitleCtrl = TextEditingController();
  final TextEditingController meetingDateCtrl = TextEditingController();
  final TextEditingController meetingPlaceCtrl = TextEditingController();
  final TextEditingController meetingModeratorCtrl = TextEditingController();
  final TextEditingController meetingSelectCtrl = TextEditingController();

  final double defaultDividerSize = 40.0;

  @override
  Widget build(BuildContext context) {
    var ctx = context;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: Get.size.width * 0.95,
            child: mainFormPage(ctx),
          ),
        ),
      ),
    );
  }

  Form mainFormPage(BuildContext ctx) {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          meetingTitleWidget(),
          SizedBox(height: defaultDividerSize),
          meetingTimeWidget(ctx),
          SizedBox(height: defaultDividerSize),
          meetingPlaceWidget(),
          SizedBox(height: defaultDividerSize),
          meetingAttendantWidget(ctx),
          SizedBox(height: defaultDividerSize),
          meetingModeratorWidget(),
          SizedBox(height: defaultDividerSize),
          meetingsWidget(),
          SizedBox(height: defaultDividerSize),
        ],
      ),
    );
  }

  Container meetingTitleWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: TextFormField(
        controller: meetingSelectCtrl,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
        decoration: textFormFieldInputSytle('회의 제목', null),
        style: TextStyle(color: Color(0xff5D4037)),
        onChanged: (val) {
          controller.meetingTitle = val;
        },
      ),
    );
  }

  Container meetingTimeWidget(BuildContext ctx) {
    return Container(
      child: GestureDetector(
        onTap: () async {
          meetingDateCtrl.text = await yearMonthDayTimePicker(ctx);
          controller.meetingTime = meetingDateCtrl.text;
        },
        child: AbsorbPointer(
          child: TextFormField(
            controller: meetingDateCtrl,
            textAlign: TextAlign.center,
            decoration: textFormFieldInputSytle(
                '회의 시간',
                Icon(
                  Icons.date_range,
                  color: Color(0xff5D4037),
                  size: 30,
                )),
            style: TextStyle(color: Color(0xff5D4037)),
          ),
        ),
      ),
    );
  }

  Container meetingPlaceWidget() {
    return Container(
      child: TextFormField(
        controller: meetingPlaceCtrl,
        textAlign: TextAlign.center,
        decoration: textFormFieldInputSytle(
          '회의 장소',
          customPopupMenuButton(meetingPlaceCtrl, model.meetingPlace),
        ),
        style: TextStyle(color: Color(0xff5D4037)),
        onSaved: (value) {
          controller.meetingPlace = value ?? '';
        },
        onChanged: (value) {
          controller.meetingPlace = value;
        },
      ),
    );
  }

  Container meetingAttendantWidget(BuildContext ctx) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  '회의 참석자',
                  style: TextStyle(
                      color: Color(0xff5D4037).withOpacity(0.5), fontSize: 18),
                ),
              ),
              GestureDetector(
                  child: Icon(
                    Icons.person_search,
                    size: 30,
                    color: Color(0xff5D4037),
                  ),
                  onTap: () async {
                    showMultiSelect(ctx);
                  }),
            ],
          ),
          Container(
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1.0,
                color: Color(0xff5D4037),
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Obx(() {
                      return Wrap(
                          spacing: 10.0,
                          children: controller.selectedValues.map((v) {
                            return Chip(
                              label: Text('${model.peoples[v]}'),
                              labelStyle: TextStyle(color: Color(0xffFFFFFF)),
                              backgroundColor:
                                  Color(0xff795548).withOpacity(0.8),
                              elevation: 6,
                              onDeleted: () {
                                controller.selectedValues.remove(v); // 이거 obs
                              },
                            );
                          }).toList());
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container meetingModeratorWidget() {
    return Container(
      child: PopupMenuButton(
        padding: const EdgeInsets.only(top: 5.0),
        child: AbsorbPointer(
          child: TextFormField(
            controller: meetingModeratorCtrl,
            textAlign: TextAlign.center,
            decoration: textFormFieldInputSytle(
              '회의 주관자',
              Icon(
                Icons.arrow_drop_down,
                color: Color(0xff5D4037),
                size: 40,
              ),
            ),
            style: TextStyle(color: Color(0xff5D4037)),
            onSaved: (value) {
              controller.meetingModerator = value ?? '';
            },
          ),
        ),
        offset: Offset(80, 40),
        onSelected: (String valueSelected) {
          meetingModeratorCtrl.text = valueSelected;
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
    );
  }

  Container meetingsWidget() {
    return Container(
      child: TextFormField(
        controller: meetingTitleCtrl,
        textAlign: TextAlign.center,
        decoration: textFormFieldInputSytle(
          '회의 종류',
          customPopupMenuButton(meetingTitleCtrl, model.meetings),
        ),
        style: TextStyle(color: Color(0xff5D4037)),
        onSaved: (value) {
          controller.meetings = value ?? '';
        },
        onChanged: (value) {
          controller.meetingPlace = value;
        },
      ),
    );
  }
}
