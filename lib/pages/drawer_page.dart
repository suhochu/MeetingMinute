import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetingminutes52/pages/resource_manage_page.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double topPadding = Get.mediaQuery.padding.top;
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
          child: Container(
            color: const Color(0xff795548),
            child: Column(
              children: [
                SizedBox(
                  height: topPadding + 10,
                ),
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/images/princessjju.png'),
                ),
                SizedBox(height: 15),
                Text('눈이 부시게 예쁜 주영공주님',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.white.withOpacity(0.7))),
                Text('abc.def@gmai.com',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.white.withOpacity(0.7))),
                SizedBox(height: 30),
              ],
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
            print('Home is clicked');
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
            Get.to(ResourceManagementPage());
          },
        ),
        const SizedBox(height: 10),
        ListTile(
          leading: Icon(
            Icons.search,
            color: Colors.grey[850],
          ),
          title: const Text('탐색'),
          onTap: () {
            print('Q&A is clicked');
          },
        ),
        const SizedBox(height: 10),
        ListTile(
          leading: Icon(
            Icons.settings,
            color: Colors.grey[850],
          ),
          title: Text('Setting'),
          onTap: () {
            print('Setting is clicked');
          },
        ),
      ],
    );
  }
}