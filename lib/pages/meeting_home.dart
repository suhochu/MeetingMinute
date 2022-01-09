import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetingminutes52/models/meeting_minute_controller.dart';
import 'package:meetingminutes52/pages/drawer_page.dart';
import 'package:meetingminutes52/pages/meeting_contents_page.dart';
import 'package:meetingminutes52/pages/meeting_minute_page.dart';
import 'package:meetingminutes52/pages/meeting_open.dart';

class MeetingHomePage extends GetView<MeetingMinuteController> {
  final List<String> _appBarTitle = ['기본 정보', '회의 내용'];
  final List<Widget> _selectedBody = [
    MeetingMinutePage(),
    MeetingContentsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: meetingMinutePageAppBar(),
        drawer: meetingMinuteDrawer(),
        body: meetingMinuteBody(),
        bottomNavigationBar: meetingBottomNavi(),
      ),
    );
  }

  AppBar meetingMinutePageAppBar() {
    return AppBar(
      iconTheme: const IconThemeData(color: Color(0xff5D4037)),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () async {
            bool isConfirmed = false;
            await Get.defaultDialog(
              content: const Text('새 회의록을 작성 합니까?'),
              title: '알림',
              textConfirm: '작성',
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
              controller.screenClear();
              controller.createNewMeetingMinute();
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.launch),
          onPressed: () {
            Get.to(MeetingOpen(id: controller.currentMeetingMinute.id));
          },
        ),
        IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              bool isConfirmed = false;
              await Get.defaultDialog(
                content: const Text('회의록을 저장 합니까?'),
                title: '알림',
                textConfirm: '저장',
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
                controller.isValidation.value = true;
                controller.updateIsSelectedValueEmpty();
                if (controller.formKey.currentState!.validate()) {
                  print('*****');
                  controller.saveToDB();
                }
              }
            })
      ],
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        _appBarTitle[controller.tapSelection.value],
        style: const TextStyle(fontSize: 20, color: Color(0xff5D4037), fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      // centerTitle: true,
    );
  }

  Drawer meetingMinuteDrawer() {
    return const Drawer(
      child: DrawerPage(),
    );
  }

  Widget meetingMinuteBody() {
    return _selectedBody[controller.tapSelection.value];
  }

  BottomNavigationBar meetingBottomNavi() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xff795548),
      selectedItemColor: const Color(0xffFFFFFF),
      unselectedItemColor: const Color(0xffD7CCC8).withOpacity(0.5),
      selectedFontSize: 14,
      unselectedFontSize: 14,
      currentIndex: controller.tapSelection.value,
      onTap: (int index) {
        controller.tapSelection.value = index;
      },
      items: const [
        BottomNavigationBarItem(
          label: '기본 정보',
          icon: Icon(Icons.info),
        ),
        BottomNavigationBarItem(
          label: '회의 내용',
          icon: Icon(Icons.question_answer),
        ),
      ],
    );
  }
}
