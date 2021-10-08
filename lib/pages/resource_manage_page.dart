import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetingminutes52/components/buttons.dart';
import 'package:meetingminutes52/components/custom_card.dart';
import 'package:meetingminutes52/components/multi_select.dart';
import 'package:meetingminutes52/components/textfield_style.dart';
import 'package:meetingminutes52/models/meeting_resource_controller.dart';
import 'package:meetingminutes52/models/project_model.dart';
import 'package:meetingminutes52/theme/text_style.dart';

class ResourceManagementPage extends GetView<MeetingSourceController> {
  ResourceManagementPage({Key? key}) : super(key: key);

  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _organizationNameController = TextEditingController();
  final TextEditingController _peopleNameController = TextEditingController();
  final TextEditingController _peopleEmailController = TextEditingController();

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
                child: Obx(
                  () => Column(
                    children: _projectListBuild(context),
                  ),
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
            onTap: () => _addingProjectMethod(index), //Adding Contents
          );
        } else {
          return _projectExpansion(ctx, index);
        }
      },
    );

    return cardList;
  }

  Widget _projectExpansion(BuildContext ctx, int index) {
    var project = controller.projects[index];
    return ExpansionTile(
      childrenPadding: const EdgeInsets.symmetric(vertical: 5),
      title: agendaCardWidget(
        widget: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 4),
              GestureDetector(
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(project.teamName,
                          style:
                              const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic)),
                      const SizedBox(height: 6),
                      Text(project.projectName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
                onTap: () => _editingProjectMethod(index), // Editing Contents
                onLongPress: () async {
                  bool? deleteParameter = await _removeProjectMethod(index);
                  if (deleteParameter!) {
                    controller.removingProject(index); //Remove Contents
                  }
                },
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  smallTextStyleInsideAgenda(
                    context: '프로젝트 맴버',
                    color: Colors.blue,
                    onTap: () => _addingPeopleMethod(index),
                    paddingValue: 4,
                  ),
                  smallTextStyleInsideAgenda(
                    context: '회의실',
                    color: const Color(0xffFF5722),
                    onTap: () => _addingMeetingPlaceMethod(ctx, index),
                    paddingValue: 4,
                  ),
                  smallTextStyleInsideAgenda(
                      context: '회의목록', color: Colors.green, onTap: () => _addingMeetingsMethod(index)),
                ],
              ),
            ],
          ),
        ),
        color: const Color(0xffFFFFFF),
      ),
      initiallyExpanded: true,
      tilePadding: const EdgeInsets.all(0),
      collapsedBackgroundColor: Colors.transparent,
      children: [
        Column(children: [
          ..._peoplesExpansions(ctx, index),
          const SizedBox(
            height: 5,
          ),
        ]),
        // Column(
        //   children: [
        //     ..._meetingPlaceExpansions(ctx, index),
        //     const SizedBox(
        //       height: 10,
        //     ),
      ],
    );
  }

  void _addingProjectMethod(int index) {
    _projectNameController.clear();
    _organizationNameController.clear();

    Get.bottomSheet(
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('프로젝트 추가', textAlign: TextAlign.center, style: bottomSheetTitleTextStyle()),
              const SizedBox(height: 20),
              Text('프로젝트 이름 : ', style: bottomSheetSubTitleTextStyle()),
              bottomSheetTextField(_projectNameController, '신규 프로젝트 이름을 입력하세요', null, 1, 30),
              const SizedBox(height: 20),
              Text('팀 이름 : ', style: bottomSheetSubTitleTextStyle()),
              bottomSheetTextField(_organizationNameController, '프로젝트 담당 팀의 입력하세요', null, 1, 30),
              completeButton(() {
                if (_projectNameController.text != '' && _projectNameController.text != '') {
                  ProjectModel newProject = ProjectModel(
                    projectName: _projectNameController.text,
                    teamName: _organizationNameController.text,
                  );
                  controller.projects.add(newProject);
                  _projectNameController.clear();
                  _organizationNameController.clear();
                }
                Get.back();
              }),
              const SizedBox(height: 20)
            ],
          ),
        ),
      ),
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

  _editingProjectMethod(int index) {
    print('hello!');
  }

  _removeProjectMethod(int index) {}

  void _addingPeopleMethod(int number) {
    _peopleNameController.clear();
    _peopleEmailController.clear();
    var project = controller.projects[number];

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
                child: Text('회의 참석자 추가', style: bottomSheetTitleTextStyle()),
              ),
              const SizedBox(height: 30),
              Text('이름 : ', style: bottomSheetSubTitleTextStyle()),
              bottomSheetTextField(_peopleNameController, '프로젝트 맴버의 이름을 입력 하세요', null, 1, 20),
              const SizedBox(height: 20),
              Text('이메일 : ', style: bottomSheetSubTitleTextStyle()),
              bottomSheetTextField(_peopleEmailController, '프로젝트 맴버의 이메일을 입력 하세요', null, 1, 40),
              const SizedBox(height: 20),
              completeButton(
                () {
                  if (_peopleNameController.text != '') {
                    People newPeople = People(
                      name: _peopleNameController.text,
                      email: _peopleEmailController.text,
                      organization: project.projectName,
                    );
                    controller.addingPeople(number, newPeople);
                    _peopleNameController.clear();
                  }
                  for (int i = 0; i < project.peoples.length; i++) {
                    print(project.peoples[i].name);
                    print(project.peoples[i].email);
                    print(project.peoples[i].organization);
                  }
                  Get.back();
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
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

  _addingMeetingPlaceMethod(BuildContext ctx, int index) {}

  _addingMeetingsMethod(int index) {}

  _peoplesExpansions(BuildContext ctx, int number) {
    var people = controller.projects[number].peoples;
    List<Widget> peopleList = List.generate(people.length, (index) {
      return GestureDetector(
          onTap: () {
            // _editingContentsMethod(number, index);
          },
          child: Dismissible(
            background: const Icon(Icons.delete, color: Colors.red),
            direction: DismissDirection.startToEnd,
            onDismissed: (direction) async {
                controller.removingPeople(number, index);
            },
            confirmDismiss: (DismissDirection dismissDirection) async {
              bool confirmed = await _removePeopleMethod(number, index);
              return confirmed;
            },



            key: UniqueKey(),
            child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(people[index].name),
                      Text(people[index].email),
                    ],
                  ),
                ),
              ),
            ),
          );
    });
    return peopleList;
  }

  _meetingPlaceExpansions(BuildContext ctx, int index) {}

   Future<bool> _removePeopleMethod(int number, int index) async {
    var people = controller.projects[number].peoples[index];
    bool removeConfirmed = false;
    await Get.defaultDialog<bool>(
      title: '프로젝트 맴 지움 확인',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      middleText: '"${people.name}"를 삭제 합니까?',
      backgroundColor: const Color(0xff795548),
      textCancel: '아니오',
      textConfirm: '예',
      barrierDismissible: false,
      radius: 50,
      onCancel: () {
        removeConfirmed = false;
      },
     onConfirm: () {
        removeConfirmed = true;
        Get.back();
      }
    );
    print(removeConfirmed);
    return removeConfirmed;
  }
}
