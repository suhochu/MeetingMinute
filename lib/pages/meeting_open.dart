import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetingminutes52/models/meeting_minute_controller.dart';
import 'package:meetingminutes52/models/models.dart';

class MeetingOpen extends GetView<MeetingMinuteController> {
  MeetingOpen({Key? key}) : super(key: key);

  bool link = false;

  @override
  Widget build(BuildContext context) {
    controller.openMeetingMinute();
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () async {
                controller.linkCheck.value = false;
                Get.back();
              },
            ),
            titleSpacing: Get.size.width * 0.1,
            toolbarHeight: 60,
            iconTheme: const IconThemeData(color: Color(0xff5D4037)),
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: const Text(
              'Meeting Minute Open',
              style: TextStyle(
                  fontSize: 20,
                  color: Color(0xff5D4037),
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            actions: [
              Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 25,
                      width: 25,
                      child: Checkbox(
                        value: controller.linkCheck.value,
                        onChanged: (bool? value) {
                          controller.linkCheck.value =
                              !controller.linkCheck.value;
                        },
                      ),
                    ),
                    Text(
                      'Linking',
                      style: TextStyle(
                          fontSize: 12,
                          color: controller.linkCheck.value
                              ? Colors.deepOrangeAccent
                              : const Color(0xff5D4037),
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ), //
              const SizedBox(
                width: 30,
              )
            ],
          ),
        ),
        body: Obx(() {
          return controller.meetingMinuteList.isEmpty
              ? const Center(
                  child: Text('표시할 내용이 없습니다.'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: controller.meetingMinuteList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            controller.selectedMeetingMinuteOpen(
                                controller.meetingMinuteList[index].id);
                            controller.linkCheck.value = false;
                            Get.back();
                          },
                          onLongPress: () async {
                            bool isConfirmed = false;
                            await Get.defaultDialog(
                              content: const Text('이 회의록을 삭제 합니까?'),
                              title: '알림',
                              textConfirm: '삭제',
                              onConfirm: () {
                                isConfirmed = true;
                                Get.back();
                              },
                              textCancel: '취소',
                              onCancel: () {
                                isConfirmed = false;
                              },
                            );
                            if (isConfirmed) {
                              controller.selectedMeetingMinuteDelete(
                                  controller.meetingMinuteList[index].id);
                              controller.openMeetingMinute();
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.all(8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      meetingMinuteOpenBox(
                                          'ID : ',
                                          controller.meetingMinuteList[index]
                                              .meetingMinuteId),
                                      meetingMinuteOpenBox('회의제목 : ',
                                          controller.meetingMinuteList[index].meetingTitle),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      meetingMinuteOpenBox('PROJECT : ',
                                          controller.meetingMinuteList[index].projectName),
                                      meetingMinuteOpenBox('회의시간 : ',
                                          controller.meetingMinuteList[index].meetingTime),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      meetingMinuteOpenBox('회의종류 : ',
                                          controller.meetingMinuteList[index].meetings),
                                      meetingMinuteOpenBox(
                                          '회의주관 : ',
                                          controller.meetingMinuteList[index]
                                              .meetingModerator),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            decoration: BoxDecoration(
                              // color: const Color(0xffD7CCC8),
                              border: Border.all(
                                width: 1.0,
                                color: const Color(0xff5D4037),
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                        Container(
                          height: 5,
                        )
                      ],
                    );
                  });
        }));
  }

  Text meetingMinuteOpenBox(String txt_1, String txt_2) => Text.rich(
        TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: txt_1,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Color(0xff757575),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextSpan(
              text: txt_2,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xff5D4037),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
}
