import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetingminutes52/components/buttons.dart';
import 'package:meetingminutes52/models/meeting_resource_controller.dart';

class ResourceManagementPage extends GetView<MeetingSourceController> {
  const ResourceManagementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff795548),
        title: const Text('회의 자원 관리'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: SizedBox(
                width: Get.size.width * 0.95,
                child: Column(
                  children: _projectListBuild(context),
                )),
          ),
        ),
      ),
    );
  }

  List<Widget> _projectListBuild(BuildContext ctx) {
    List<Widget> cardList = [];
    cardList = List.generate(
      controller.projects.length + 1,
      (index) {
        if (index == controller.projects.length) {
          return GestureDetector(
            child: AddingButtonWidget('프로젝트 추가'),
            onTap: () {}, //Adding Contents
          );
        } else {
          return _projectExpansion(ctx, index);
        }
      },
    );

    return cardList;
  }

  Widget _projectExpansion(BuildContext ctx, int index) {
    return Container();
  }
}
