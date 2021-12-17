import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetingminutes52/components/constants.dart';
import 'package:meetingminutes52/models/models.dart';
import 'package:meetingminutes52/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class MeetingMinuteController extends GetxController {
  //Tab 관련 변수들
  RxInt tapSelection = 0.obs;

  //MeetingMinute 관련 class 변수
  late String meetingMinuteId;
  late MeetingMinute currentMeetingMinute;
  RxList<MeetingMinute> meetingMinuteList = <MeetingMinute>[].obs;
  late MeetingMinute backUpMeetingMinute;

  //프로젝트 선택 관련 변수
  RxInt selectedProject = 0.obs;
  List<String> projects = [];
  var projectHasBeenSelected = false.obs;

  //Temporary AgendaList
  RxList<AgendaModel> meetingAgendasModel = <AgendaModel>[].obs;

  //아젠다 리스트 관련 임시 변수들
  RxString tempAgendaStatus = status[0].obs;
  RxString tempContentsIssuedBy = ''.obs;
  RxString tempTodoStatus = status[0].obs;
  RxString tempTodoResponsible = ''.obs;
  RxString tempTodoDueData = ''.obs;

  // 회의 참석자 관련 변수들
  var selectedValues = <int>{}.obs;
  List<String> peopleList = [];
  List<String> selectedAttendantInt = [];
  List<String> meetingAttendants = [];

  //오브젝트 박스 관련 변수
  late Store _store;
  Box<MeetingMinute>? projectBox;

  //업데이트 관련 변수들
  bool hasBeenInitialized = false;
  bool hasAgendaUpdated = false;

  //Open Page 관련 변수들
  var linkCheck = false.obs;

  // 기본 정보 화면 관련 Text Controllers
  // 기본정보 Tap 에 사용되는 TextEditingControllers
  final TextEditingController projectTeamCtrl = TextEditingController();
  final TextEditingController meetingsCtrl = TextEditingController();
  final TextEditingController meetingDateCtrl = TextEditingController();
  final TextEditingController meetingPlaceCtrl = TextEditingController();
  final TextEditingController meetingModeratorCtrl = TextEditingController();
  final TextEditingController meetingTitleCtrl = TextEditingController();

  // 회의내용 Tap 에 사용되는 TextEditingControllers
  final TextEditingController agendaController = TextEditingController();
  final TextEditingController contentsController = TextEditingController();
  final TextEditingController todoController = TextEditingController();

  // todo Save/Validation 구현해야함
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    createNewMeetingMinute();
    getApplicationDocumentsDirectory().then((dir) {
      try {
        _store = Store(
          getObjectBoxModel(),
          directory: join(dir.path, 'meeting_Minute'),
        );
        projectBox = _store.box<MeetingMinute>();
        hasBeenInitialized = true;
      } catch (e) {
        Get.defaultDialog(
          middleText: e.toString(),
        );
        hasBeenInitialized = false;
      }
      if (hasBeenInitialized) {
        List<MeetingMinute> initialMeetingMinuteList = projectBox!.getAll();
        if (initialMeetingMinuteList.isNotEmpty) {
          meetingMinuteList.addAll(initialMeetingMinuteList);
        }
      }
    });
  }

  String calIdWithMakingTime() {
    return DateTime.now().toString().split(' ')[0].split('-')[0] +
        DateTime.now().toString().split(' ')[0].split('-')[1] +
        DateTime.now().toString().split(' ')[0].split('-')[2] +
        DateTime.now().toString().split(' ')[1].split(':')[0] +
        DateTime.now().toString().split(' ')[1].split(':')[1];
  }

  void editingSelectedValues(Set<int> changedValues) {
    selectedValues.clear();
    selectedValues(changedValues);
  }

  void attendantUpdate() {
    List<String> tempSelectedList = [];
    for (var i in selectedValues) {
      tempSelectedList.add(peopleList[i]);
    }
    selectedAttendantInt.clear();
    for (var i in selectedValues) {
      selectedAttendantInt.add(i.toString());
    }
    peopleList = peopleList;
    meetingAttendants.clear();
    meetingAttendants = tempSelectedList;
  }

  void addingAgenda(
      String agendaString, String agendaStatus, String issuedTime) {
    meetingAgendasModel.add(
      AgendaModel(
          agendaID: meetingMinuteId +
              '-' +
              (meetingAgendasModel.length + 1).toString(),
          agendaString: agendaString,
          agendaStatus: agendaStatus,
          issuedTime: issuedTime),
    );
    hasAgendaUpdated = true;
  }

  void editingAgenda(
      int number, String agendaTitle, String issuedTime, String agendaStatus) {
    meetingAgendasModel[number] = meetingAgendasModel[number].copyWith(
        agendaString: agendaTitle,
        issuedTime: issuedTime,
        agendaStatus: agendaStatus);
    hasAgendaUpdated = true;
  }

  void removingAgenda(int number) {
    meetingAgendasModel.removeAt(number);
    hasAgendaUpdated = true;
  }

  void addingContents(int number, ContentsModel content) {
    AgendaModel dummyModel = meetingAgendasModel[number];
    dummyModel.contentsModels.add(content);
    meetingAgendasModel[number] = dummyModel;
    hasAgendaUpdated = true;
  }

  void editingContent(int number, int index, ContentsModel content) {
    AgendaModel dummyModel = meetingAgendasModel[number];
    dummyModel.contentsModels[index] = content;
    meetingAgendasModel[number] = dummyModel;
    hasAgendaUpdated = true;
  }

  void removingContents(int number, int index) {
    AgendaModel dummyModel = meetingAgendasModel[number];
    dummyModel.contentsModels.removeAt(index);
    meetingAgendasModel[number] = dummyModel;
    hasAgendaUpdated = true;
  }

  void addingTodo(int number, TodoModel todo) {
    AgendaModel dummyModel = meetingAgendasModel[number];
    dummyModel.todoModels.add(todo);
    meetingAgendasModel[number] = dummyModel;
    hasAgendaUpdated = true;
  }

  void editingTodos(int number, int index, TodoModel todo) {
    AgendaModel dummyModel = meetingAgendasModel[number];
    dummyModel.todoModels[index] = todo;
    meetingAgendasModel[number] = dummyModel;
    hasAgendaUpdated = true;
  }

  void removingTodos(int number, int index) {
    AgendaModel dummyModel = meetingAgendasModel[number];
    dummyModel.todoModels.removeAt(index);
    meetingAgendasModel[number] = dummyModel;
    hasAgendaUpdated = true;
  }

  // void agendaListUpdate(){
  //   for(int i=0; i<currentMeetingMinute.agendaList.length; i++) {
  //     currentMeetingMinute.agendaList[i].
  //   }
  // }


  void updateMeetingMinute() {
    currentMeetingMinute.meetingMinuteId =
        meetingMinuteId; //todo 이거 불러오기 기능에서는 변경 안되도록 수
    currentMeetingMinute.projectName = projectTeamCtrl.text;
    currentMeetingMinute.meetingTitle = meetingTitleCtrl.text;
    currentMeetingMinute.meetingTime = meetingDateCtrl.text;
    currentMeetingMinute.meetingPlace = meetingPlaceCtrl.text;
    currentMeetingMinute.meetingModerator = meetingModeratorCtrl.text;
    currentMeetingMinute.meetings = meetingsCtrl.text;
    currentMeetingMinute.meetingAttendants = meetingAttendants;
    selectedAttendantInt
        .map((e) => currentMeetingMinute.selectedAttendantInt.add(e));
    peopleList.map((e) => currentMeetingMinute.peopleList.add(e));
    print(hasAgendaUpdated);
    print(
        'for currentMeetingMinute.agendaList.length is : ${currentMeetingMinute.agendaList.length}');
    if (hasAgendaUpdated == true) {
      for (int i = 0; i < currentMeetingMinute.agendaList.length; i++) {
        currentMeetingMinute.agendaList.removeAt(0);
      }
      currentMeetingMinute.agendaList.addAll(meetingAgendasModel.toList());
      hasAgendaUpdated = false;
    }//todo 이부분 전체 수정

    print(
        'currentMeetingMinute.agendaList.length is : ${currentMeetingMinute.agendaList.length}');
    print('meetingAgendasModel.length is : ${meetingAgendasModel.length}');
  }

  void saveToDB() {
    updateMeetingMinute();
    int id = projectBox!.put(currentMeetingMinute);
    print('Saved id is $id');
    MeetingMinute? temporary = projectBox!.get(id);
    print('temporary!.agendaList.length is : ${temporary!.agendaList.length}');
  }

  void openMeetingMinute() {
    meetingMinuteList.clear();
    meetingMinuteList.addAll(projectBox!.getAll());
  }

  void selectedMeetingMinuteOpen(int id) {
    screenClear();
    currentMeetingMinute = projectBox!.get(id)!;
    print(
        '##currentMeetingMinute.agendaList.length is : ${currentMeetingMinute.agendaList.length}');
    print('##id is : ${currentMeetingMinute.id}');

    if (linkCheck.value == true) {
      MeetingMinute temporaryMeetingMinute = currentMeetingMinute.copyWith();
      temporaryMeetingMinute.agendaList.addAll(currentMeetingMinute.agendaList);
      createNewMeetingMinute();

      currentMeetingMinute.meetingMinuteId =
          temporaryMeetingMinute.meetingMinuteId;
      currentMeetingMinute.projectName = temporaryMeetingMinute.projectName;
      currentMeetingMinute.meetingTitle = temporaryMeetingMinute.meetingTitle;
      currentMeetingMinute.meetingTime = temporaryMeetingMinute.meetingTime;
      currentMeetingMinute.meetingPlace = temporaryMeetingMinute.meetingPlace;
      currentMeetingMinute.meetingAttendants =
          temporaryMeetingMinute.meetingAttendants;
      currentMeetingMinute.meetingModerator =
          temporaryMeetingMinute.meetingModerator;
      currentMeetingMinute.selectedAttendantInt =
          temporaryMeetingMinute.selectedAttendantInt;
      currentMeetingMinute.peopleList = temporaryMeetingMinute.peopleList;
      currentMeetingMinute.meetings = temporaryMeetingMinute.meetings;
      currentMeetingMinute.agendaList.addAll(temporaryMeetingMinute.agendaList);
      print(
          '###currentMeetingMinute.agendaList.length is : ${currentMeetingMinute.agendaList.length}');
      print('##id is : ${currentMeetingMinute.id}');
    }
    projectTeamCtrl.text = currentMeetingMinute.projectName;
    selectProject(currentMeetingMinute.projectName); //프로젝트 선택
    meetingsCtrl.text = currentMeetingMinute.meetings;
    meetingDateCtrl.text = currentMeetingMinute.meetingTime;
    meetingPlaceCtrl.text = currentMeetingMinute.meetingPlace;
    meetingModeratorCtrl.text = currentMeetingMinute.meetingModerator;
    meetingTitleCtrl.text = currentMeetingMinute.meetingTitle;
    selectedValues.clear;
    selectedValues.addAll(currentMeetingMinute.selectedAttendantInt
        .map((e) => int.parse(e))
        .toSet()); //회의 참석자
    peopleList = currentMeetingMinute.peopleList;
    meetingAgendasModel.addAll(currentMeetingMinute.agendaList);
    meetingAttendants = currentMeetingMinute.meetingAttendants;
    selectedAttendantInt = currentMeetingMinute.selectedAttendantInt;
  }

  void screenClear() {
    meetingPlaceCtrl.clear();
    meetingModeratorCtrl.clear();
    meetingTitleCtrl.clear();
    projectTeamCtrl.clear();
    meetingsCtrl.clear();
    meetingDateCtrl.clear();
    selectedValues.clear();
    meetingAgendasModel.clear();
    peopleList.clear();
    meetingAttendants.clear();
    selectedAttendantInt.clear();
  }

  void selectProject(String valueSelected) {
    projectTeamCtrl.text = valueSelected;
    if (projects.contains(valueSelected)) {
      selectedProject.value = projects.indexOf(valueSelected);
      projectHasBeenSelected.value = true;
    }
  }

  void createNewMeetingMinute() {
    meetingMinuteId = calIdWithMakingTime(); //meetingMinuteId 생성
    currentMeetingMinute = MeetingMinute(
        projectName: '',
        meetingTitle: '',
        meetingTime: '',
        meetingPlace: '',
        meetingAttendants: [],
        meetingModerator: '',
        meetings: '',
        peopleList: [],
        selectedAttendantInt: [],
        meetingMinuteId: '');
  }

  void selectedMeetingMinuteDelete(int id) {
    projectBox!.remove(id);
  }

  int countTodos(String name) {
    int todoCount = 0;
    openMeetingMinute();
    for (int i = 0; i < meetingMinuteList.length; i++) {
      for (int j = 0; j < meetingMinuteList[i].agendaList.length; j++) {
        for (int k = 0;
            k < meetingMinuteList[i].agendaList[j].todoModels.length;
            k++) {
          if (meetingMinuteList[i].agendaList[j].todoModels[k].responsible ==
              name) {
            todoCount++;
          }
        }
      }
    }
    return todoCount;
  }
}
