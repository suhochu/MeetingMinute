import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetingminutes52/components/buttons.dart';
import 'package:meetingminutes52/components/multi_select.dart';
import 'package:meetingminutes52/components/textfield_style.dart';
import 'package:meetingminutes52/components/time_component.dart';
import 'package:meetingminutes52/models/meeting_minute_controller.dart';
import 'package:meetingminutes52/models/meeting_resource_controller.dart';

class MeetingMinutePage extends GetView<MeetingMinuteController> {
  final projectController = Get.put(MeetingSourceController());

  // final TextEditingController projectTeamCtrl = TextEditingController();
  // final TextEditingController meetingTitleCtrl = TextEditingController();
  // final TextEditingController meetingDateCtrl = TextEditingController();
  // final TextEditingController meetingPlaceCtrl = TextEditingController();
  // final TextEditingController meetingModeratorCtrl = TextEditingController();
  // final TextEditingController meetingSelectCtrl = TextEditingController();

  final double defaultDividerSize = 40.0;

  MeetingMinutePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var ctx = context;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: Get.size.width * 0.95,
            child: GetX<MeetingSourceController>(builder: (_) {
              if (projectController.hasBeenUpdated) {
                clearContents();
              }
              return mainFormPage(ctx);
            }),
          ), // child: mainFormPage(ctx)),
        ),
      ),
    );
  }

  Form mainFormPage(BuildContext ctx) {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          SizedBox(height: defaultDividerSize),
          projectTeamWidget(),
          SizedBox(height: defaultDividerSize * 0.3),
          meetingTitleWidget(),
          SizedBox(height: defaultDividerSize),
          meetingTimeWidget(ctx),
          SizedBox(height: defaultDividerSize),
          meetingPlaceWidget(),
          SizedBox(height: defaultDividerSize),
          Obx(() => meetingAttendantWidget(ctx)),
          SizedBox(height: defaultDividerSize),
          meetingModeratorWidget(),
          SizedBox(height: defaultDividerSize),
          meetingsWidget(),
          SizedBox(height: defaultDividerSize),
        ],
      ),
    );
  }

  Widget projectTeamWidget() {
    List<String> projects = projectController.projectTeamList;
    return PopupMenuButton(
      padding: const EdgeInsets.only(top: 5.0),
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller.projectTeamCtrl,
          textAlign: TextAlign.center,
          decoration: textFormFieldInputStyle(
            '프로젝트',
            const Icon(
              Icons.arrow_drop_down,
              color: Color(0xff5D4037),
              size: 40,
            ),
          ),
          style: const TextStyle(color: Color(0xff5D4037)),
          onSaved: (value) {
            controller.meetingMinute.projectName = value ?? '';
          },
          onChanged: (value) {
            controller.meetingMinute.projectName = value;
          },
        ),
      ),
      offset: const Offset(80, 40),
      onSelected: (String valueSelected) {
        controller.projectTeamCtrl.text = valueSelected;
        if (projects.contains(valueSelected)) {
          controller.selectedProject.value = projects.indexOf(valueSelected);
          controller.meetingMinute.projectName = valueSelected;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        ...projects.map<PopupMenuItem<String>>((String value) {
          return PopupMenuItem<String>(
            child: Center(child: Text(value)),
            value: value,
          );
        }).toList()
      ],
    );
  }

  Container meetingTitleWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: TextFormField(
        controller: controller.meetingSelectCtrl,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
        decoration: textFormFieldInputStyle('회의 제목', null),
        style: const TextStyle(color: Color(0xff5D4037)),
        onChanged: (val) {
          controller.meetingMinute.meetingTitle = val;
        },
      ),
    );
  }

  Widget meetingTimeWidget(BuildContext ctx) {
    return GestureDetector(
      onTap: () async {
        controller.meetingDateCtrl.text = await yearMonthDayTimePicker(ctx);
        if (controller.meetingDateCtrl.text != '') {
          controller.meetingMinute.meetingTime = controller.meetingDateCtrl.text;
        } else {
          controller.meetingDateCtrl.text = controller.meetingMinute.meetingTime;
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller.meetingDateCtrl,
          textAlign: TextAlign.center,
          decoration: textFormFieldInputStyle(
              '회의 시간',
              const Icon(
                Icons.date_range,
                color: Color(0xff5D4037),
                size: 30,
              )),
          style: const TextStyle(color: Color(0xff5D4037)),
        ),
      ),
    );
  }

  Widget meetingPlaceWidget() {
    if (projectController.projects.isEmpty) {
      controller.selectedProject.value = -1;
    }
    return TextFormField(
      controller: controller.meetingPlaceCtrl,
      textAlign: TextAlign.center,
      decoration: textFormFieldInputStyle(
        '회의 장소',
        customPopupMenuButton(
          controller.meetingPlaceCtrl,
          controller.selectedProject.value == -1
              ? []
              : projectController.projects[controller.selectedProject.value].meetingPlace,
        ),
      ),
      style: const TextStyle(color: Color(0xff5D4037)),
      onSaved: (value) {
        controller.meetingMinute.meetingPlace = value ?? '';
      },
      onChanged: (value) {
        controller.meetingMinute.meetingPlace = value;
      },
    );
  }

  Widget meetingAttendantWidget(BuildContext ctx) {

    List<String> peopleList = [];

    if (projectController.projects.isEmpty) {
      controller.selectedProject.value = -1;
    }

    if (controller.selectedProject.value != -1) {
      for (var people in projectController.projects[controller.selectedProject.value].peoples) {
        peopleList.add(people.name);
      }
    }
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                '회의 참석자',
                style: TextStyle(color: const Color(0xff5D4037).withOpacity(0.5), fontSize: 18),
              ),
            ),
            GestureDetector(
                child: const Icon(
                  Icons.person_search,
                  size: 30,
                  color: Color(0xff5D4037),
                ),
                onTap: () async {
                  showMultiSelect(ctx, peopleList);
                }),
          ],
        ),
        Container(
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.0,
              color: const Color(0xff5D4037),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Wrap(
                            spacing: 10.0,
                            children: controller.selectedValues.map((v) {
                              return Chip(
                                label: Text(peopleList[v]),
                                labelStyle: const TextStyle(color: Color(0xffFFFFFF)),
                                backgroundColor: const Color(0xff795548).withOpacity(0.8),
                                elevation: 6,
                                onDeleted: () {
                                  controller.selectedValues.remove(v); // 이거 obs
                                  controller.attendantUpdate(peopleList);
                                },
                              );
                            }).toList())
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget meetingModeratorWidget() {
    List<String> peopleList = [];
    if (projectController.projects.isEmpty) {
      controller.selectedProject.value = -1;
    }
    if (controller.selectedProject.value != -1) {
      for (var people in projectController.projects[controller.selectedProject.value].peoples) {
        peopleList.add(people.name);
      }
    }
    return PopupMenuButton(
      padding: const EdgeInsets.only(top: 5.0),
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller.meetingModeratorCtrl,
          textAlign: TextAlign.center,
          decoration: textFormFieldInputStyle(
            '회의 주관자',
            const Icon(
              Icons.arrow_drop_down,
              color: Color(0xff5D4037),
              size: 40,
            ),
          ),
          style: const TextStyle(color: Color(0xff5D4037)),
          onSaved: (value) {
            controller.meetingMinute.meetingModerator = value ?? '';
          },
        ),
      ),
      offset: const Offset(80, 40),
      onSelected: (String valueSelected) {
        controller.meetingModeratorCtrl.text = valueSelected;
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        ...controller.selectedValues
            .map((index) {
              return peopleList[index];
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
    );
  }

  Widget meetingsWidget() {
    List<String> meetingsList = [];
    if (projectController.projects.isEmpty) {
      controller.selectedProject.value = -1;
    }
    if (controller.selectedProject.value != -1) {
      for (var meeting in projectController.projects[controller.selectedProject.value].meetings) {
        meetingsList.add(meeting.meetingName);
      }
    }
    return TextFormField(
      controller: controller.meetingTitleCtrl,
      textAlign: TextAlign.center,
      decoration: textFormFieldInputStyle(
        '회의 종류',
        customPopupMenuButton(controller.meetingTitleCtrl, meetingsList),
      ),
      style: const TextStyle(color: Color(0xff5D4037)),
      onSaved: (value) {
        controller.meetingMinute.meetings = value ?? '';
      },
      onChanged: (value) {
        controller.meetingMinute.meetingPlace = value;
      },
    );
  }

  void clearContents() {
    controller.meetingPlaceCtrl.clear();
    controller.meetingModeratorCtrl.clear();
    controller.meetingSelectCtrl.clear();
    controller.projectTeamCtrl.clear();
    controller.meetingTitleCtrl.clear();
    controller.meetingDateCtrl.clear();
    controller.selectedValues.clear();
    controller.meetingAgendasModel.clear();
    WidgetsBinding.instance!.addPostFrameCallback((_) => projectController.hasBeenUpdated = false);
  }
}
