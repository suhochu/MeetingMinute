import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetingminutes52/components/buttons.dart';
import 'package:meetingminutes52/components/multi_select.dart';
import 'package:meetingminutes52/components/textfield_style.dart';
import 'package:meetingminutes52/components/time_component.dart';
import 'package:meetingminutes52/models/meeting_minute_controller.dart';
import 'package:meetingminutes52/models/meeting_resource_controller.dart';
import 'package:meetingminutes52/pages/resource_manage_page.dart';

class MeetingMinutePage extends GetView<MeetingMinuteController> {
  final projectController = Get.put(MeetingSourceController());
  final double defaultDividerSize = 40.0;

  MeetingMinutePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var ctx = context;
    if (projectController.projects.isEmpty) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Get.defaultDialog(content: const Text('프로젝트를 프로젝트가 없습니다. 프로젝트를 등록하세요'), title: '알림');
        Get.to(ResourceManagementPage(
          first: true,
        ));
      });
    } else {
      controller.projects = projectController.projectTeamList;
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: Get.size.width * 0.95,
            child: GetX<MeetingSourceController>(builder: (_) {
              if (projectController.hasBeenUpdated) {
                initializeContents();
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
          projectNameWidget(),
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

  Widget projectNameWidget() {
    return PopupMenuButton(
      padding: const EdgeInsets.only(top: 5.0),
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller.projectNameCtrl,
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
          validator: (value) {
            if (value!.isEmpty) {
              return "프로젝트를 선택해 주세요";
            }
            return null;
          },
        ),
      ),
      offset: const Offset(80, 40),
      onSelected: (String valueSelected) {
        controller.selectProject(valueSelected);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        ...controller.projects.map<PopupMenuItem<String>>((String value) {
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
        controller: controller.meetingTitleCtrl,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
        decoration: textFormFieldInputStyle('회의 제목', null),
        style: const TextStyle(color: Color(0xff5D4037)),
        validator: (value) {
          if (value!.isEmpty) {
            return "회의 제목을 입력해 주세요";
          }
          return null;
        },
      ),
    );
  }

  Widget meetingTimeWidget(BuildContext ctx) {
    return GestureDetector(
      onTap: () async {
        String temporaryTime = await yearMonthDayTimePicker(ctx);
        if (temporaryTime != '') {
          controller.meetingDateCtrl.text = temporaryTime;
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
          validator: (value) {
            if (value!.isEmpty) {
              return "회의 시간을 선택해 주세요";
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget meetingPlaceWidget() {
    return TextFormField(
      controller: controller.meetingPlaceCtrl,
      textAlign: TextAlign.center,
      decoration: textFormFieldInputStyle(
        '회의 장소',
        customPopupMenuButton(
          controller.meetingPlaceCtrl,
          controller.projectHasBeenSelected.value ? projectController.projects[controller.selectedProject.value].meetingPlace : [],
        ),
      ),
      style: const TextStyle(color: Color(0xff5D4037)),
      validator: (value) {
        if (value!.isEmpty) {
          return "회의 장소를 선택해 주세요";
        }
        return null;
      },
    );
  }

  Widget meetingAttendantWidget(BuildContext ctx) {
    controller.peopleList.clear();
    if (controller.projectHasBeenSelected.value) {
      for (var people in projectController.projects[controller.selectedProject.value].peoples) {
        controller.peopleList.add(people.name);
      }
    }
    controller.updateIsSelectedValueEmpty();
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
                  showMultiSelect(ctx);
                }),
          ],
        ),
        Container(
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.0,
              color: controller.isSelectedValuesEmpty.value && controller.isValidation.value ? Colors.red : const Color(0xff5D4037),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: controller.isSelectedValuesEmpty.value && controller.isValidation.value
                        ? const Center(
                            child: Text('회의 참석자를 입력해 주세요', style: TextStyle(
                              fontSize: 12, color: Colors.red
                            ),),
                          )
                        : Wrap(
                            spacing: 10.0,
                            children: controller.selectedValues.map((v) {
                              return Chip(
                                label: Text(controller.peopleList[v]),
                                labelStyle: const TextStyle(color: Color(0xffFFFFFF)),
                                backgroundColor: const Color(0xff795548).withOpacity(0.8),
                                elevation: 6,
                                onDeleted: () {
                                  controller.selectedValues.remove(v); // 이거 obs
                                },
                              );
                            }).toList())),
              ],
            ),
          ),
        ), // todo Wrap 부분을 폼으로 감싸기
      ],
    );
  }

  Widget meetingModeratorWidget() {
    List<String> peopleList = [];

    if (controller.projectHasBeenSelected.value) {
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
          validator: (value) {
            if (value!.isEmpty) {
              return "회의 주관자를 선택해 주세요";
            }
            return null;
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
    if (controller.projectHasBeenSelected.value) {
      for (var meeting in projectController.projects[controller.selectedProject.value].meetings) {
        meetingsList.add(meeting.meetingName);
      }
    }
    return TextFormField(
      controller: controller.meetingsCtrl,
      textAlign: TextAlign.center,
      decoration: textFormFieldInputStyle(
        '회의 종류',
        customPopupMenuButton(controller.meetingsCtrl, meetingsList),
      ),
      style: const TextStyle(color: Color(0xff5D4037)),
      validator: (value) {
        if (value!.isEmpty) {
          return "회의 종류를 선택해 주세요";
        }
        return null;
      },
    );
  }

  void initializeContents() {
    controller.meetingPlaceCtrl.clear();
    controller.meetingModeratorCtrl.clear();
    controller.meetingTitleCtrl.clear();
    controller.projectNameCtrl.clear();
    controller.meetingsCtrl.clear();
    controller.meetingDateCtrl.clear();
    controller.selectedValues.clear();
    controller.meetingAgendasModel.clear();
    WidgetsBinding.instance!.addPostFrameCallback((_) => projectController.hasBeenUpdated = false);
    if (projectController.projects.isEmpty) {
      controller.selectedProject.value = -1;
    } else {
      controller.projects = projectController.projectTeamList;
    }
  }
}
