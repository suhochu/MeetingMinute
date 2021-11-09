import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meetingminutes52/components/buttons.dart';
import 'package:meetingminutes52/components/profile_widget.dart';
import 'package:meetingminutes52/components/textfield_style.dart';
import 'package:meetingminutes52/models/user_controller.dart';
import 'package:meetingminutes52/theme/text_style.dart';
import 'package:image_cropper/image_cropper.dart';

class ProfilePage extends GetView<UserController> {
  double heightUnit = (Get.size.height) / 20;
  bool isEdit = false;
  final TextEditingController _userNameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();

  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Obx(
        () => Column(
          children: [
            ProfileWidget(
              imagePath: controller.user.value.imagePath,
              isEdit: isEdit,
              onClicked: () async {
                final pickedFile =
                    await picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  File? croppedFile = await ImageCropper.cropImage(
                      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
                      sourcePath: pickedFile.path,
                      androidUiSettings: const AndroidUiSettings(
                          toolbarTitle: 'Cropper',
                          toolbarColor: Colors.deepOrange,
                          toolbarWidgetColor: Colors.white,
                          initAspectRatio: CropAspectRatioPreset.original,
                          lockAspectRatio: false),
                      iosUiSettings: const IOSUiSettings(
                        minimumAspectRatio: 1.0,
                      ));
                  if (croppedFile != null) {
                    String imagePath = croppedFile.path;
                    controller.updateProfileImage(imagePath);
                  }
                }
              },
            ),
            SizedBox(height: heightUnit),
            buildName(),
            SizedBox(height: heightUnit),
            NumbersWidget(),
            SizedBox(height: heightUnit),
            buildRegularMeetings(),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        onPressed: () {
          Get.back();
        },
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  Widget buildName() => GestureDetector(
        onTap: _editProfile,
        child: Column(
          children: [
            Text(
              controller.user.value.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              controller.user.value.email,
              style: const TextStyle(color: Colors.grey, fontSize: 20),
            )
          ],
        ),
      );

  Widget buildRegularMeetings() {
    return Container(
      width: Get.size.width - 60,
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: const Color(0xff5D4037),
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Center(
          child: Text(
        '여기에는 정규 미팅 리스트를 나열함',
        style: TextStyle(fontSize: 20),
      )),
    );
  }

  void _editProfile() {
    _userNameCtrl.text = controller.user.value.name;
    _emailCtrl.text = controller.user.value.email;

    Get.bottomSheet(
      SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      alignment: Alignment.center,
                      child: Text('프로필 변경', style: bottomSheetTitleTextStyle()),
                    ),
                    const SizedBox(height: 20),
                    bottomSheetTextField(
                        _userNameCtrl, '변경할 이름을 입력 하세요', null, 1, 20),
                    bottomSheetTextField(
                        _emailCtrl, '변경할 이메일을 입력 하세요', null, 1, 30),
                    const SizedBox(height: 20),
                    completeButton(() {
                      if (_userNameCtrl.text != '') {
                        controller.editingUserName(_userNameCtrl.text);
                        _userNameCtrl.clear();
                      }
                      if (_emailCtrl.text != '') {
                        controller.editingUseEmail(_emailCtrl.text);
                        _emailCtrl.clear();
                      }
                      Get.back();
                    }),
                    const SizedBox(height: 20),
                  ]))),
      isDismissible: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(35),
        side: const BorderSide(
          width: 1,
          color: Color(0xff5D4037),
        ),
      ),
      enableDrag: true,
    );
  }
}
