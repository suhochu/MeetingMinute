import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetingminutes52/components/buttons.dart';
import 'package:meetingminutes52/components/custom_card.dart';
import 'package:meetingminutes52/components/textfield_style.dart';
import 'package:meetingminutes52/models/meeting_resource_controller.dart';
import 'package:meetingminutes52/models/project_model.dart';
import 'package:meetingminutes52/pages/meeting_home.dart';
import 'package:meetingminutes52/theme/text_style.dart';

class ResourceManagementPage extends GetView<MeetingSourceController> {
  ResourceManagementPage({Key? key, required this.first}) : super(key: key);
  bool first;

  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _peopleNameController = TextEditingController();
  final TextEditingController _peopleEmailController = TextEditingController();
  final TextEditingController _meetingPlaceController = TextEditingController();
  final TextEditingController _meetingsController = TextEditingController();
  final TextEditingController _meetingsTimingsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff795548),
        title: const Text('회의 자원 관리'),
        leading: first ? Container(
          width: 10,
        ) : IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () async {
            await saveProject();
            Get.back();
          },
        ),
        actions: [
          first
              ? TextButton(
                  child: const Text(
                    '회의록 작성',
                    style: TextStyle(color: Color(0xffFF5722), fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  onPressed: () {
                    if (controller.projects.isNotEmpty) {
                      Get.off(MeetingHomePage());
                    } else {
                      Get.defaultDialog(content: const Text('프로젝트를 하나 이상 입력 하세요'), title: '알림');
                    }
                  })
              : Container(),
          const SizedBox(width: 20),
          GestureDetector(
              child: const Icon(Icons.delete),
              onTap: () async {
                bool isConfirmed = false;
                await Get.defaultDialog(
                  content: const Text('모든 프로젝트를 삭제 합니까?'),
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
                  controller.deleteDB();
                }
              }),
          const SizedBox(
            width: 20,
          ),
          GestureDetector(
              child: const Icon(Icons.save),
              onTap: () async {
                await saveProject();
              }),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Center(
              child: Container(
                  padding: const EdgeInsets.only(top: 16.0),
                  width: Get.size.width * 0.95,
                  child: Obx(() => Column(
                        children: _projectListBuild(context),
                      ))))),

    );
  }

  List<Widget> _projectListBuild(BuildContext ctx) {
    List<Widget> cardList = [];
    cardList = List.generate(controller.projects.length + 1, (index) {
      if (index == controller.projects.length) {
        return GestureDetector(
          child: addingButtonWidget('프로젝트 추가'),
          onTap: () => _addingProjectMethod(index), //Adding Contents
        );
      } else {
        return _projectExpansion(ctx, index);
      }
    });
    return cardList;
  }

  Widget _projectExpansion(BuildContext ctx, int number) {
    var project = controller.projects[number];
    return ExpansionTile(
        childrenPadding: const EdgeInsets.symmetric(vertical: 5),
        title: agendaCardWidget(
          widget: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                const SizedBox(height: 4),
                GestureDetector(
                  child: Container(
                      color: Colors.transparent,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(project.teamName,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic)),
                          const SizedBox(height: 6),
                          Text(project.projectName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                        ],
                      )),
                  onTap: () => _editingProjectMethod(number), // Editing Contents
                  onLongPress: () async {
                    bool? deleteParameter = await _removeProjectMethod(number);
                    if (deleteParameter!) {
                      controller.removingProject(number); //Remove Contents
                    }
                  },
                ),
                const SizedBox(height: 12),
                Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  smallTextStyleInsideAgenda(
                    context: '프로젝트 맴버',
                    color: Colors.blue,
                    onTap: () => _addingPeopleMethod(number),
                    paddingValue: 4,
                  ),
                  smallTextStyleInsideAgenda(
                    context: '회의실',
                    color: const Color(0xffFF5722),
                    onTap: () => _addingMeetingPlaceMethod(ctx, number),
                    paddingValue: 4,
                  ),
                  smallTextStyleInsideAgenda(
                    context: '회의목록',
                    color: Colors.green,
                    onTap: () => _addingMeetingsMethod(number),
                  )
                ])
              ])),
          color: const Color(0xffFFFFFF),
        ),
        initiallyExpanded: true,
        tilePadding: const EdgeInsets.all(0),
        collapsedBackgroundColor: Colors.transparent,
        children: [
          Column(children: [
            ..._peoplesExpansions(ctx, number),
            const SizedBox(height: 5),
          ]),
          Column(children: [
            ..._meetingPlaceExpansions(ctx, number),
            const SizedBox(height: 10),
          ]),
          Column(children: [
            ..._meetingsExpansions(ctx, number),
            const SizedBox(height: 10),
          ]),
        ]);
  }

  void _addingProjectMethod(int index) {
    _projectNameController.clear();
    _teamNameController.clear();

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
                  bottomSheetTextField(_teamNameController, '프로젝트 담당 팀의 입력하세요', null, 1, 30),
                  completeButton(() {
                    if (_projectNameController.text != '' && _projectNameController.text != '') {
                      ProjectModel newProject = ProjectModel(
                        projectName: _projectNameController.text,
                        teamName: _teamNameController.text,
                      );
                      controller.addingProject(newProject);
                      _projectNameController.clear();
                      _teamNameController.clear();
                    }
                    Get.back();
                  }),
                  const SizedBox(height: 20)
                ],
              ))),
      isDismissible: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(35),
          side: const BorderSide(
            width: 1,
            color: Color(0xff5D4037),
          )),
      enableDrag: true,
    );
  }

  void _editingProjectMethod(int number) {
    var project = controller.projects[number];
    _projectNameController.text = project.projectName;
    _teamNameController.text = project.teamName;

    Get.bottomSheet(
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('프로젝트 정보 수정', textAlign: TextAlign.center, style: bottomSheetTitleTextStyle()),
              const SizedBox(height: 20),
              Text('프로젝트 이름 : ', style: bottomSheetSubTitleTextStyle()),
              bottomSheetTextField(_projectNameController, '프로젝트 이름을 변경하세요', null, 1, 30),
              const SizedBox(height: 20),
              Text('팀 이름 : ', style: bottomSheetSubTitleTextStyle()),
              bottomSheetTextField(_teamNameController, '프로젝트 담당 팀을 변경하세요', null, 1, 30),
              completeButton(() {
                if (_projectNameController.text != '' && _projectNameController.text != '') {
                  controller.editingProject(number, _projectNameController.text, _teamNameController.text);
                  _projectNameController.clear();
                  _teamNameController.clear();
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
          )),
      enableDrag: true,
    );
  }

  Future<bool?> _removeProjectMethod(int number) async {
    return await Get.defaultDialog<bool>(
      title: '아젠다 지움 확인',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      middleText: '"${controller.projects[number].projectName}"를 삭제 합니까?',
      backgroundColor: const Color(0xff795548),
      textCancel: '아니오',
      textConfirm: '예',
      barrierDismissible: false,
      radius: 50,
      onCancel: () => Get.back(result: false),
      onConfirm: () => Get.back(result: true),
    );
  }

  List<Widget> _peoplesExpansions(BuildContext ctx, int number) {
    var people = controller.projects[number].peoples;
    List<Widget> peopleList = [];

    if (people.isNotEmpty) {
      peopleList = List.generate(people.length + 1, (index) {
        int correctedIndex = index - 1;
        if (index == 0) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(3.0),
            child: const Text(
              '프로젝트 맴버',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.blueAccent),
            ),
          );
        } else {
          return GestureDetector(
              onTap: () {
                _editingPeopleMethod(number, correctedIndex);
              },
              child: Dismissible(
                  background: const Icon(Icons.delete, color: Colors.red),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) async {
                    controller.removingPeople(number, correctedIndex);
                  },
                  confirmDismiss: (DismissDirection dismissDirection) async {
                    bool confirmed = await _removePeopleMethod(number, correctedIndex);
                    return confirmed;
                  },
                  key: UniqueKey(),
                  child: Card(
                      elevation: 0,
                      color: Colors.blue.withOpacity(0.2),
                      child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Row(
                            children: [
                              SizedBox(
                                  width: 100,
                                  child: Text(
                                    people[correctedIndex].name,
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                                  )),
                              const SizedBox(width: 10),
                              Text(
                                people[correctedIndex].email,
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                              ),
                            ],
                          )))));
        }
      });
    }
    return peopleList;
  }

  void _addingPeopleMethod(int number) {
    _peopleNameController.clear();
    _peopleEmailController.clear();
    var project = controller.projects[number];

    Get.bottomSheet(
      SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                completeButton(() {
                  if (_peopleNameController.text != '') {
                    People newPeople = People(
                      name: _peopleNameController.text,
                      email: _peopleEmailController.text,
                      team: project.projectName,
                    );
                    controller.addingPeople(number, newPeople);
                    _peopleNameController.clear();
                    _peopleEmailController.clear();
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

  void _editingPeopleMethod(int number, int index) {
    var project = controller.projects[number];
    _peopleNameController.text = project.peoples[index].name;
    _peopleEmailController.text = project.peoples[index].email;

    Get.bottomSheet(
      SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  child: Text('회의 참석자 변경', style: bottomSheetTitleTextStyle()),
                ),
                const SizedBox(height: 30),
                Text('이름 : ', style: bottomSheetSubTitleTextStyle()),
                bottomSheetTextField(_peopleNameController, '프로젝트 맴버의 이름을 변경 하세요', null, 1, 20),
                const SizedBox(height: 20),
                Text('이메일 : ', style: bottomSheetSubTitleTextStyle()),
                bottomSheetTextField(_peopleEmailController, '프로젝트 맴버의 이메일을 변경 하세요', null, 1, 40),
                const SizedBox(height: 20),
                completeButton(() {
                  if (_peopleNameController.text != '') {
                    People newPeople = People(
                      name: _peopleNameController.text,
                      email: _peopleEmailController.text,
                      team: project.projectName,
                    );
                    controller.editingPeople(number, index, newPeople);
                    _peopleNameController.clear();
                    _peopleEmailController.clear();
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

  Future<bool> _removePeopleMethod(int number, int index) async {
    var people = controller.projects[number].peoples[index];
    bool removeConfirmed = false;
    await Get.defaultDialog<bool>(
        title: '프로젝트 맴버 지움 확인',
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
        });
    return removeConfirmed;
  }

  List<Widget> _meetingPlaceExpansions(BuildContext ctx, int number) {
    var meetingPlaces = controller.projects[number].meetingPlace;
    List<Widget> meetingPlaceList = [];
    if (meetingPlaces.isNotEmpty) {
      meetingPlaceList = List.generate(meetingPlaces.length + 1, (index) {
        int correctedIndex = index - 1;
        if (index == 0) {
          return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(3.0),
              child: const Text('회의실',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xffFF5722),
                  )));
        } else {
          return GestureDetector(
              onTap: () {
                _editingMeetingPlaceMethod(number, correctedIndex);
              },
              child: Dismissible(
                  background: const Icon(Icons.delete, color: Colors.red),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) async {
                    controller.removingMeetingPlace(number, correctedIndex);
                  },
                  confirmDismiss: (DismissDirection dismissDirection) async {
                    bool confirmed = await _removeMeetingPlaceMethod(number, correctedIndex);
                    return confirmed;
                  },
                  key: UniqueKey(),
                  child: Card(
                      elevation: 0,
                      color: Colors.redAccent.withOpacity(0.2),
                      child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: SizedBox(
                              width: double.infinity,
                              child: Text(
                                meetingPlaces[correctedIndex],
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                              ))))));
        }
      });
    }
    return meetingPlaceList;
  }

  void _addingMeetingPlaceMethod(BuildContext ctx, int number) {
    _meetingPlaceController.clear();

    Get.bottomSheet(
      SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  child: Text('회의실 추가', style: bottomSheetTitleTextStyle()),
                ),
                const SizedBox(height: 30),
                Text('회의실 이름 : ', style: bottomSheetSubTitleTextStyle()),
                bottomSheetTextField(_meetingPlaceController, '회의실의 이름을 입력 하세요', null, 1, 20),
                const SizedBox(height: 20),
                completeButton(() {
                  if (_meetingPlaceController.text != '') {
                    controller.addingMeetingPlace(number, _meetingPlaceController.text);
                    _meetingPlaceController.clear();
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

  void _editingMeetingPlaceMethod(int number, int index) {
    var selectedMeetingPlace = controller.projects[number].meetingPlace[index];
    _meetingPlaceController.text = selectedMeetingPlace;

    Get.bottomSheet(
      SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  child: Text('회의실 변경', style: bottomSheetTitleTextStyle()),
                ),
                const SizedBox(height: 30),
                Text('회의실 이름 : ', style: bottomSheetSubTitleTextStyle()),
                bottomSheetTextField(_meetingPlaceController, '프로젝트 맴버의 이름을 변경 하세요', null, 1, 20),
                const SizedBox(height: 20),
                completeButton(() {
                  if (_meetingPlaceController.text != '') {
                    controller.editingMeetingPlace(number, index, _meetingPlaceController.text);
                    _meetingPlaceController.clear();
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
          )),
      enableDrag: true,
    );
  }

  Future<bool> _removeMeetingPlaceMethod(int number, int index) async {
    var selectedMeetingPlace = controller.projects[number].meetingPlace[index];
    bool removeConfirmed = false;
    await Get.defaultDialog<bool>(
        title: '프로젝트 맴버 지움 확인',
        titleStyle: const TextStyle(fontWeight: FontWeight.bold),
        middleText: '$selectedMeetingPlace를 삭제 합니까?',
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
        });
    return removeConfirmed;
  }

  List<Widget> _meetingsExpansions(BuildContext ctx, int number) {
    var meetings = controller.projects[number].meetings;
    List<Widget> meetingsList = [];
    if (meetings.isNotEmpty) {
      meetingsList = List.generate(meetings.length + 1, (index) {
        int correctedIndex = index - 1;
        if (index == 0) {
          return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(3.0),
              child: const Text('회의',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.green,
                  )));
        } else {
          return GestureDetector(
              onTap: () {
                _editingMeetingsMethod(number, correctedIndex);
              },
              child: Dismissible(
                  background: const Icon(Icons.delete, color: Colors.red),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) async {
                    controller.removingMeetings(number, correctedIndex);
                  },
                  confirmDismiss: (DismissDirection dismissDirection) async {
                    bool confirmed = await _removeMeetingsMethod(number, correctedIndex);
                    return confirmed;
                  },
                  key: UniqueKey(),
                  child: Card(
                      elevation: 0,
                      color: Colors.greenAccent.withOpacity(0.2),
                      child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: SizedBox(
                              width: double.infinity,
                              child: Row(children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    meetings[correctedIndex].meetingName,
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: Text(
                                      meetings[correctedIndex].meetingTiming,
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                                    ))
                              ]))))));
        }
      });
    }
    return meetingsList;
  }

  void _addingMeetingsMethod(int number) {
    _meetingsController.clear();
    _meetingsTimingsController.clear();

    Get.bottomSheet(
      SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  child: Text('회의 추가', style: bottomSheetTitleTextStyle()),
                ),
                const SizedBox(height: 30),
                Text('회의 이름 : ', style: bottomSheetSubTitleTextStyle()),
                bottomSheetTextField(_meetingsController, '회의의 이름을 입력 하세요', null, 1, 20),
                const SizedBox(height: 20),
                bottomSheetTextField(_meetingsTimingsController, '회의의 주기를 입력 하세요', null, 1, 20),
                const SizedBox(height: 20),
                completeButton(
                  () {
                    if (_meetingsController.text != '') {
                      Meetings newMeetings = Meetings(
                        meetingName: _meetingsController.text,
                        meetingTiming: _meetingsTimingsController.text,
                      );

                      controller.addingMeetings(number, newMeetings);
                      _meetingsController.clear();
                      _meetingsTimingsController.clear();
                    }
                    Get.back();
                  },
                ),
                const SizedBox(height: 20),
              ]))),
      isDismissible: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(35),
          side: const BorderSide(
            width: 1,
            color: Color(0xff5D4037),
          )),
      enableDrag: true,
    );
  }

  void _editingMeetingsMethod(int number, int index) {
    var meetings = controller.projects[number].meetings[index];
    _meetingsController.text = meetings.meetingName;
    _meetingsTimingsController.text = meetings.meetingTiming;

    Get.bottomSheet(
      SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  child: Text('회의 추가', style: bottomSheetTitleTextStyle()),
                ),
                const SizedBox(height: 30),
                Text('회의 이름 : ', style: bottomSheetSubTitleTextStyle()),
                bottomSheetTextField(_meetingsController, '회의의 이름을 입력 하세요', null, 1, 20),
                const SizedBox(height: 20),
                bottomSheetTextField(_meetingsTimingsController, '회의의 주기를 입력 하세요', null, 1, 20),
                const SizedBox(height: 20),
                completeButton(() {
                  if (_meetingsController.text != '') {
                    Meetings newMeetings = Meetings(
                      meetingName: _meetingsController.text,
                      meetingTiming: _meetingsTimingsController.text,
                    );

                    controller.editingMeetings(number, index, newMeetings);
                    _meetingsController.clear();
                    _meetingsTimingsController.clear();
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
          )),
      enableDrag: true,
    );
  }

  Future<bool> _removeMeetingsMethod(int number, int index) async {
    var selectedMeetings = controller.projects[number].meetings[index];
    bool removeConfirmed = false;
    await Get.defaultDialog<bool>(
        title: '프로젝트 맴버 지움 확인',
        titleStyle: const TextStyle(fontWeight: FontWeight.bold),
        middleText: '${selectedMeetings.meetingName}를 삭제 합니까?',
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
        });
    return removeConfirmed;
  }

  Future<void> saveProject() async {
    if (controller.notYetSaved) {
      bool isConfirmed = false;
      await Get.defaultDialog(
        content: const Text('변경 사항을 저장 합니까?'),
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
        controller.saveToDB();
        controller.notYetSaved = false;
      }
    }
  }
}
