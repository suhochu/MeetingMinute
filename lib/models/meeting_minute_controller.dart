import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetingminutes52/components/constants.dart';
import 'package:meetingminutes52/models/models.dart';
import 'package:meetingminutes52/objectbox.g.dart';
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
  List<String> selectedValuesList = [];

  //오브젝트 박스 관련 변수
  late Store _store;
  Box<MeetingMinute>? projectBox;

  //업데이트 관련 변수들
  bool hasBeenInitialized = false;

  //Open Page 관련 변수들
  var linkCheck = false.obs;

  // 기본 정보 화면 관련 Text Controllers
  // 기본정보 Tap 에 사용되는 TextEditingControllers
  final TextEditingController projectNameCtrl = TextEditingController();
  final TextEditingController meetingsCtrl = TextEditingController();
  final TextEditingController meetingDateCtrl = TextEditingController();
  final TextEditingController meetingPlaceCtrl = TextEditingController();
  final TextEditingController meetingModeratorCtrl = TextEditingController();
  final TextEditingController meetingTitleCtrl = TextEditingController();

  // 회의내용 Tap 에 사용되는 TextEditingControllers
  final TextEditingController agendaController = TextEditingController();
  final TextEditingController contentsController = TextEditingController();
  final TextEditingController todoController = TextEditingController();

  // Form Validation
  final formKey = GlobalKey<FormState>();
  var isSelectedValuesEmpty = false.obs;
  var isValidation = false.obs;

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

  void addingAgenda(String agendaString, String agendaStatus, String issuedTime) {
    meetingAgendasModel.add(
      AgendaModel(
        agendaID: meetingMinuteId + '-' + (meetingAgendasModel.length + 1).toString(),
        agendaString: agendaString,
        agendaStatus: agendaStatus,
        issuedTime: issuedTime,
        contentsModelsString: '',
        todoModelsString: '',
      ),
    );
  }

  void editingAgenda(int number, String agendaTitle, String issuedTime, String agendaStatus) {
    List<ContentsModel> tempContents = meetingAgendasModel[number].contentsModels;
    List<TodoModel> tempTodos = meetingAgendasModel[number].todoModels;

    meetingAgendasModel[number] =
        meetingAgendasModel[number].copyWith(agendaString: agendaTitle, issuedTime: issuedTime, agendaStatus: agendaStatus);

    meetingAgendasModel[number].contentsModels = tempContents;
    meetingAgendasModel[number].todoModels = tempTodos;
  }

  void removingAgenda(int number) {
    meetingAgendasModel.removeAt(number);
  }

  void addingContents(int number, ContentsModel content) {
    AgendaModel dummyModel = meetingAgendasModel[number];
    dummyModel.contentsModels.add(content);
    meetingAgendasModel[number] = dummyModel;
  }

  void editingContent(int number, int index, ContentsModel content) {
    AgendaModel dummyModel = meetingAgendasModel[number];
    dummyModel.contentsModels[index] = content;
    meetingAgendasModel[number] = dummyModel;
  }

  void removingContents(int number, int index) {
    AgendaModel dummyModel = meetingAgendasModel[number];
    dummyModel.contentsModels.removeAt(index);
    meetingAgendasModel[number] = dummyModel;
  }

  void addingTodo(int number, TodoModel todo) {
    AgendaModel dummyModel = meetingAgendasModel[number];
    dummyModel.todoModels.add(todo);
    meetingAgendasModel[number] = dummyModel;
  }

  void editingTodos(int number, int index, TodoModel todo) {
    AgendaModel dummyModel = meetingAgendasModel[number];
    dummyModel.todoModels[index] = todo;
    meetingAgendasModel[number] = dummyModel;
  }

  void removingTodos(int number, int index) {
    AgendaModel dummyModel = meetingAgendasModel[number];
    dummyModel.todoModels.removeAt(index);
    meetingAgendasModel[number] = dummyModel;
  }

  void saveToDB() {
    updateMeetingMinute();
    int id = projectBox!.put(currentMeetingMinute);
    Get.snackbar('알림', '저장 되었습니다.', backgroundColor: Colors.white12,);
  }

  //회의록을 저장할때 화면상의 내용을 currentMeetingMinute 로 업데이트 하는 기능
  void updateMeetingMinute() {
    currentMeetingMinute.meetingMinuteId = meetingMinuteId; //todo 이거 불러오기 기능에서는 변경 안되도록 수
    currentMeetingMinute.projectName = projectNameCtrl.text;
    currentMeetingMinute.meetingTitle = meetingTitleCtrl.text;
    currentMeetingMinute.meetingTime = meetingDateCtrl.text;
    currentMeetingMinute.meetingPlace = meetingPlaceCtrl.text;
    currentMeetingMinute.meetingModerator = meetingModeratorCtrl.text;
    currentMeetingMinute.meetings = meetingsCtrl.text;
    currentMeetingMinute.selectedAttendantInt.clear();
    for (var value in selectedValues) {
      currentMeetingMinute.selectedAttendantInt.add(value.toString());
    }
    peopleList.map((e) => currentMeetingMinute.peopleList.add(e));

    int todosCount = 0;
    List<String> jsonData = [];

    for (int i = 0; i < meetingAgendasModel.length; i++) {
      Map<String, dynamic> json = meetingAgendasModel[i].toJson();
      List<String> jsonContents = [];
      List<String> jsonTodos = [];

      for (int j = 0; j < meetingAgendasModel[i].contentsModels.length; j++) {
        Map<String, dynamic> jsonContent = meetingAgendasModel[i].contentsModels[j].toJson();
        String jsonContentString = jsonEncode(jsonContent);
        jsonContents.add(jsonContentString);
        jsonContents.add('&&&***%%%');
      }
      json['contentsList'] = jsonContents.toString();

      for (int k = 0; k < meetingAgendasModel[i].todoModels.length; k++) {
        if (meetingAgendasModel[i].todoModels[k].todoStatus != 'Done') {
          todosCount++;
        }
        Map<String, dynamic> jsonTodo = meetingAgendasModel[i].todoModels[k].toJson();
        String jsonTodoString = jsonEncode(jsonTodo);
        jsonTodos.add(jsonTodoString);
        jsonTodos.add('&&&***%%%');
      }
      json['todosList'] = jsonTodos.toString();
      String jsonString = jsonEncode(json);
      jsonData.add(jsonString);
    }
    currentMeetingMinute.agendaListToString.clear();
    currentMeetingMinute.agendaListToString = jsonData;
    currentMeetingMinute.todoCount = todosCount;
  }

  void openMeetingMinute() {
    meetingMinuteList.clear();
    meetingMinuteList.addAll(projectBox!.getAll());
  }

  //openPage 에서 회의록을 불러오는 기능 (linkCheck value 에 따라서 단순 불러오기 및 복사 선택)
  void selectedMeetingMinuteOpen(int id) {
    screenClear();
    currentMeetingMinute = projectBox!.get(id)!;

    if (linkCheck.value == true) {
      MeetingMinute temporaryMeetingMinute = currentMeetingMinute.copyWith();
      createNewMeetingMinute();
      currentMeetingMinute.meetingMinuteId = temporaryMeetingMinute.meetingMinuteId;
      currentMeetingMinute.projectName = temporaryMeetingMinute.projectName;
      currentMeetingMinute.meetingTitle = temporaryMeetingMinute.meetingTitle;
      currentMeetingMinute.meetingTime = temporaryMeetingMinute.meetingTime;
      currentMeetingMinute.meetings = temporaryMeetingMinute.meetings;
      currentMeetingMinute.meetingPlace = temporaryMeetingMinute.meetingPlace;
      currentMeetingMinute.meetingAttendants = temporaryMeetingMinute.meetingAttendants;
      currentMeetingMinute.meetingModerator = temporaryMeetingMinute.meetingModerator;
      currentMeetingMinute.selectedAttendantInt = temporaryMeetingMinute.selectedAttendantInt;
      currentMeetingMinute.peopleList = temporaryMeetingMinute.peopleList;
      currentMeetingMinute.agendaListToString = temporaryMeetingMinute.agendaListToString;
    }
    projectNameCtrl.text = currentMeetingMinute.projectName;
    selectProject(currentMeetingMinute.projectName); // todo project 명이 바뀔때 어떻게 할 건지 수정해야함
    meetingsCtrl.text = currentMeetingMinute.meetings;
    meetingDateCtrl.text = currentMeetingMinute.meetingTime;
    meetingPlaceCtrl.text = currentMeetingMinute.meetingPlace;
    meetingModeratorCtrl.text = currentMeetingMinute.meetingModerator;
    meetingTitleCtrl.text = currentMeetingMinute.meetingTitle;
    selectedValues.clear;
    selectedValues.addAll(currentMeetingMinute.selectedAttendantInt.map((e) => int.parse(e)).toSet()); //회의 참석자
    peopleList = currentMeetingMinute.peopleList;
    meetingAgendasModel.addAll(currentMeetingMinute.agendaList);

    currentMeetingMinute.agendaList.clear();
    for (var tempAgenda in currentMeetingMinute.agendaListToString) {
      Map<String, dynamic> jsonData = jsonDecode(tempAgenda);
      AgendaModel tempAgendaModel = AgendaModel.fromJson(jsonData);

      if (tempAgendaModel.contentsModelsString != '[]') {
        String tempContentsString = (tempAgendaModel.contentsModelsString).substring(1, tempAgendaModel.contentsModelsString.length - 12);
        var tempContentsList = tempContentsString.split(', &&&***%%%, ');
        for (var content in tempContentsList) {
          ContentsModel tempContentsModel = ContentsModel.fromJson(json.decode(content));
          tempAgendaModel.contentsModels.add(tempContentsModel);
        }
      }
      if (tempAgendaModel.todoModelsString != '[]') {
        String tempTodosString = (tempAgendaModel.todoModelsString).substring(1, tempAgendaModel.todoModelsString.length - 12);
        var tempTodosList = tempTodosString.split(', &&&***%%%, ');
        for (var content in tempTodosList) {
          TodoModel tempTodosModel = TodoModel.fromJson(json.decode(content));
          tempAgendaModel.todoModels.add(tempTodosModel);
        }
      }
      currentMeetingMinute.agendaList.add(tempAgendaModel);
    }
    meetingAgendasModel.value = currentMeetingMinute.agendaList;
  }

  void screenClear() {
    meetingPlaceCtrl.clear();
    meetingModeratorCtrl.clear();
    meetingTitleCtrl.clear();
    projectNameCtrl.clear();
    meetingsCtrl.clear();
    meetingDateCtrl.clear();
    selectedValues.clear();
    meetingAgendasModel.clear();
    peopleList.clear();
  }

  // DB 에서 회의록을 불러올때 프로젝트가 선택되게 하는 함수

  void selectProject(String valueSelected) {
    if (projects.contains(valueSelected)) {
      projectHasBeenSelected.value = true;
      selectedProject.value = projects.indexOf(valueSelected);
      projectNameCtrl.text = valueSelected;
    }
  }

  // 새로운 MeetingMinute 를 생성하는 함수

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
      meetingMinuteId: '',
      agendaListToString: [],
      todoCount: 0,
    );
  }

  void selectedMeetingMinuteDelete(int id) {
    projectBox!.remove(id);
  }

  int countTodos() {
    int todoCount = 0;
    openMeetingMinute();
    for (var value in meetingMinuteList) {
      todoCount = value.todoCount + todoCount;
    }
    return todoCount;
  }

  void updateAllMeetingMinute(String originalProjectName, String modifiedProjectName) {
    openMeetingMinute();
    print(meetingMinuteList.length);
    for (int i = 0; i < meetingMinuteList.length; i++) {
      selectedMeetingMinuteOpen(meetingMinuteList[i].id);
      if (currentMeetingMinute.projectName == originalProjectName) {
        currentMeetingMinute.projectName = modifiedProjectName;
        int id = projectBox!.put(currentMeetingMinute);
      }
    }
  }

  void updateIsSelectedValueEmpty(){
    if (selectedValues.isNotEmpty) {
      isSelectedValuesEmpty.value = false;
    } else {
      isSelectedValuesEmpty.value = true;
    }
  }
}
