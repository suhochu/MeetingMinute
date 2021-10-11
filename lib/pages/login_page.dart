import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetingminutes52/components/buttons.dart';
import 'package:meetingminutes52/models/meeting_resource_controller.dart';
import 'package:meetingminutes52/pages/resource_manage_page.dart';
import 'package:meetingminutes52/theme/color_style.dart';
import 'package:meetingminutes52/pages/meeting_home.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double appWidth = Get.width;
    double appHeight = Get.height;
    Map<String, Color> selectedColors = colorSetting[0];

    return Stack(children: [
      SizedBox(
        width: double.infinity,
        child: Image.asset(
          'assets/images/login.png',
          fit: BoxFit.fill,
          height: appHeight,
          width: appWidth,
        ),
      ),
      Positioned(
        bottom: 50,
        child: SizedBox(
          width: appWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              loginButton(const Text('로컬에서 로그인'), () {
                Get.off(MeetingHomePage());
              }),
              const SizedBox(
                height: 30,
              ),
              loginButton(const Text('서버에서 로그인'), () {}),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                child: Text(
                  '아직 계정이 없으신가요? Sign Up!',
                  style: TextStyle(
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
                    color: selectedColors['TEXT_ICONS']!.withOpacity(0.8),
                  ),
                ),
                onTap: () {
                  print('Go To SignUp!');
                },
              )
            ],
          ),
        ),
      ),
    ]);
  }
}
