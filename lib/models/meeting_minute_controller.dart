import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetingminutes52/components/constants.dart';
import 'package:meetingminutes52/models/models.dart';
import 'package:meetingminutes52/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class MeetingMinuteController extends GetxController {

  RxInt tapSelection = 0.obs;
  late MeetingMinute meetingMinute;
  List<MeetingMinute> meetingMinuteList = [];
  RxList<AgendaModel> meetingAgendasModel = <AgendaModel>[].obs;

  RxInt selectedProject = (-1).obs;
  RxString tempAgendaStatus = status[0].obs;
  RxString tempContentsIssuedBy = ''.obs;
  RxString tempTodoStatus = status[0].obs;
  RxString tempTodoResponsible = ''.obs;
  RxString tempTodoDueData = ''.obs;

  var selectedValues = <int>{}.obs;
  var updatedSelectedPeople = false.obs;

  late Store _store;
  Box<MeetingMinute>? projectBox;

  bool hasBeenInitialized = false;
  bool hasBeenUpdated = false;
  bool notYetSaved = false;

  final TextEditingController projectTeamCtrl = TextEditingController();
  final TextEditingController meetingTitleCtrl = TextEditingController();
  final TextEditingController meetingDateCtrl = TextEditingController();
  final TextEditingController meetingPlaceCtrl = TextEditingController();
  final TextEditingController meetingModeratorCtrl = TextEditingController();
  final TextEditingController meetingSelectCtrl = TextEditingController();

  final TextEditingController agendaController = TextEditingController();
  final TextEditingController contentsController = TextEditingController();
  final TextEditingController todoController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    meetingMinute = MeetingMinute(
        projectName: '',
        meetingTitle: '',
        meetingTime: '',
        meetingPlace: '',
        meetingAttendants: [],
        meetingModerator: '',
        meetings: '',
        meetingMinuteId: calIdWithMakingTime());
    meetingMinute.agendaList.clear();

    getApplicationDocumentsDirectory().then((dir) {
      try {
        _store = Store(
          getObjectBoxModel(),
          directory: join(dir.path, 'meeting_Minute'),
        );

        projectBox = _store.box<MeetingMinute>();
        hasBeenInitialized = true;
      } catch (e) {
        print(e);
        hasBeenInitialized = false;
      }
      if (hasBeenInitialized) {
        getApplicationDocumentsDirectory().then((dir) {
          try {
            _store = Store(
              getObjectBoxModel(),
              directory: join(dir.path, 'objectbox'),
            );
            projectBox = _store.box<MeetingMinute>();
            hasBeenInitialized = true;
          } catch (e) {
            print(e);
            hasBeenInitialized = false;
          }
          if (hasBeenInitialized) {
            List<MeetingMinute> initialMeetingMinuteList = projectBox!.getAll();
            if (initialMeetingMinuteList.isNotEmpty) {
              meetingMinuteList = initialMeetingMinuteList;
            }
          }
        });
      }
    });
  }

  String calIdWithMakingTime() {
    return DateTime.now().toString().split(' ')[0].split('-')[0] +
        DateTime.now().toString().split(' ')[0].split('-')[1] +
        DateTime.now().toString().split(' ')[0].split('-')[2];
  }

  void editingSelectedValues(Set<int> changedValues) {
    selectedValues.clear();
    selectedValues(changedValues);
  }

  void attendantUpdate(List<String> list) {

    List<String> tempSelectedList = [];
    for(var i in selectedValues) {
      tempSelectedList.add(list[i]);
    }
    meetingMinute.meetingAttendants.clear();
    meetingMinute.meetingAttendants = tempSelectedList;
  }

  void addingAgenda(
      String agendaString, String agendaStatus, String issuedTime) {
    meetingAgendasModel.add(
      AgendaModel(
          agendaID: meetingMinute.meetingMinuteId +
              '-' +
              (meetingMinute.agendaList.length + 1).toString(),
          agendaString: agendaString,
          agendaStatus: agendaStatus,
          issuedTime: issuedTime),
    );
  }

  void editingAgenda(
      int number, String agendaTitle, String issuedTime, String agendaStatus) {
    meetingAgendasModel[number] = meetingAgendasModel[number].copyWith(
        agendaString: agendaTitle,
        issuedTime: issuedTime,
        agendaStatus: agendaStatus);
  }

  void removingAgenda(int number) {
    meetingAgendasModel.removeAt(number);
  }

  void updateAgenda(){
    meetingMinute.agendaList.clear();
    meetingMinute.agendaList.addAll(meetingAgendasModel);
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
    int id = projectBox!.put(meetingMinute);
    print('id is $id');
    hasBeenUpdated = false;
  }

  List<MeetingMinute> openMeetingMinute(){
    List<MeetingMinute> meetingMinutes = projectBox!.getAll();
    print('Length of meetingminute is ${meetingMinutes.length}');
    if(meetingMinutes.isNotEmpty){
      return meetingMinutes;
    }
    return [];
  }

  void showDB() {

    List<MeetingMinute> temp = projectBox!.getAll();
    print(temp.length);
    for (int i = 0; i < temp.length; i++) {

      print('meetingMinuteId is : ${temp[i].meetingMinuteId}');
      print('projectName is : ${temp[i].projectName}');
      print('meetingTitle is : ${temp[i].meetingTitle}');
      print('meetingTime is : ${temp[i].meetingTime}');
      print('meetingPlace is : ${temp[i].meetingPlace}');
      print('meetingAttendants is : ${temp[i].meetingAttendants}');
      print('meetingModerator is : ${temp[i].meetingModerator}');
      print('meetings is : ${temp[i].meetings}');
    }
  }

  void selectedMeetingMinute(int id) {
    MeetingMinute? selectedMeetingMinute = projectBox!.get(id);
    print(selectedMeetingMinute!.id);
  }

}
