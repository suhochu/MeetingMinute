import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetingminutes52/models/meeting_resource_controller.dart';
import 'package:meetingminutes52/pages/drawer_page.dart';
import 'package:meetingminutes52/pages/meeting_contents_page.dart';
import 'package:meetingminutes52/pages/meeting_minute_page.dart';
import 'package:meetingminutes52/pages/resource_manage_page.dart';

class MeetingHomePage extends GetView<MeetingSourceController> {

  final List<String> _appBarTitle = ['기본 정보', '회의 내용', '해야 할일'];
  final List<Widget> _meetingPages = [
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
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.link),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.file_upload),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.save),
          onPressed: () {},
        ),
      ],
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        _appBarTitle[controller.selectedIndex.value],
        style: const TextStyle(fontSize: 20, color: Color(0xff5D4037), fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      // centerTitle: true,
    );
  }

  Drawer meetingMinuteDrawer() {
    return Drawer(
      child: DrawerPage(),
    );
  }

  Widget meetingMinuteBody() {
    return _meetingPages[controller.selectedIndex.value];
  }

  BottomNavigationBar meetingBottomNavi() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xff795548),
      selectedItemColor: const Color(0xffFFFFFF),
      unselectedItemColor: const Color(0xffD7CCC8).withOpacity(0.5),
      selectedFontSize: 14,
      unselectedFontSize: 14,
      currentIndex: controller.selectedIndex.value,
      onTap: (int index) {
        controller.selectedIndex.value = index;
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

        // BottomNavigationBarItem(
        //   label: '해야 할일',
        //   icon: Icon(Icons.engineering),
        // ),
      ],
    );
  }
}
