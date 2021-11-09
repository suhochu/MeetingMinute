import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetingminutes52/models/user_controller.dart';
import 'package:meetingminutes52/pages/profile_page.dart';
import 'package:meetingminutes52/pages/resource_manage_page.dart';

class DrawerPage extends GetView<UserController> {
  const DrawerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double topPadding = Get.mediaQuery.padding.top;


    return ListView(
      padding: EdgeInsets.zero,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
          child: Container(
            color: const Color(0xff795548),
            child: Obx(
              () => Column(
                children: [
                  SizedBox(
                    height: topPadding + 10,
                  ),
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        AssetImage('assets/images/princessjju.png'),
                  ),
                  const SizedBox(height: 15),
                  Text(controller.user.value.name,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Colors.white.withOpacity(0.7))),
                  Text(controller.user.value.email,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Colors.white.withOpacity(0.7))),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        ListTile(
          leading: Icon(
            Icons.account_circle,
            color: Colors.grey[850],
          ),
          title: const Text('User Profile'),
          onTap: () {
            Get.to(ProfilePage());
          },
        ),
        const SizedBox(height: 10),
        ListTile(
          leading: Icon(
            Icons.source,
            color: Colors.grey[850],
          ),
          title: const Text('프로젝트 관리'),
          onTap: () {
            Get.to(ResourceManagementPage(
              first: false,
            ));
          },
        ),
        const SizedBox(height: 10),
        ListTile(
          leading: Icon(
            Icons.search,
            color: Colors.grey[850],
          ),
          title: const Text('탐색'),
          onTap: () {},
        ),
        const SizedBox(height: 10),
        ListTile(
          leading: Icon(
            Icons.settings,
            color: Colors.grey[850],
          ),
          title: const Text('Setting'),
          onTap: () {},
        ),
      ],
    );
  }
}
