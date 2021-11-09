import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetingminutes52/components/constants.dart';
import 'package:meetingminutes52/models/models.dart';

class MeetingMinuteController extends GetxController {
  RxInt tapSelection = 0.obs;
  late MeetingMinute meetingMinute;


  RxInt selectedProject = (-1).obs;
  RxList<AgendaModel> meetingContentsModel = <AgendaModel>[].obs;
  RxString tempAgendaStatus = status[0].obs;
  RxString tempContentsIssuedBy = ''.obs;
  RxString tempTodoStatus = status[0].obs;
  RxString tempTodoResponsible = ''.obs;
  RxString tempTodoDueData = ''.obs;
  var selectedValues = <int>{}.obs;
  var updatedSelectedPeople = false.obs;


  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    meetingMinute = MeetingMinute(
        projectName: '',
        meetingTitle: '',
        meetingTime: '',
        meetingPlace: '',
        meetingAttendants: '',
        meetingModerator: '',
        meetings: '',
        agendaList: meetingContentsModel,
        meetingMinuteId: calIdWithMakingTime());
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

  void addingAgenda(String agendaString, String agendaStatus, String issuedTime) {
    meetingContentsModel.add(
      AgendaModel(
          agendaID: meetingMinute.meetingMinuteId + '-' + (meetingMinute.agendaList.length + 1).toString(),
          agendaString: agendaString,
          contentsModels: [],
          todoModels: [],
          agendaStatus: agendaStatus,
          issuedTime: issuedTime),
    );
    // meetingMinute.agendaModelCount++;
  }

  void editingAgenda(int number, String agendaTitle, String issuedTime, String agendaStatus) {
    meetingContentsModel[number] = meetingContentsModel[number]
        .copyWith(agendaString: agendaTitle, issuedTime: issuedTime, agendaStatus: agendaStatus);
  }

  void removingAgenda(int number) {
    meetingContentsModel.removeAt(number);
  }

  void addingContents(int number, ContentsModel content) {
    AgendaModel dummyModel = meetingContentsModel[number];
    dummyModel.contentsModels.add(content);
    meetingContentsModel[number] = meetingContentsModel[number].copyWith(contentsModels: dummyModel.contentsModels);
    // meetingContentsModel[number].contentCount++;
  }

  void editingContent(int number, int index, ContentsModel content) {
    AgendaModel dummyModel = meetingContentsModel[number];
    dummyModel.contentsModels[index] = content;
    meetingContentsModel[number] = dummyModel;
  }

  void removingContents(int number, int index) {
    AgendaModel dummyModel = meetingContentsModel[number];
    dummyModel.contentsModels.removeAt(index);
    meetingContentsModel[number] = dummyModel;
  }

  void addingTodo(int number, TodoModel todo) {
    AgendaModel dummyModel = meetingContentsModel[number];
    dummyModel.todoModels.add(todo);
    meetingContentsModel[number] = meetingContentsModel[number].copyWith(
      todoModels: dummyModel.todoModels,
    );
    // meetingContentsModel[number].todoCount++;
  }

  void editingTodos(int number, int index, TodoModel todo) {
    AgendaModel dummyModel = meetingContentsModel[number];
    dummyModel.todoModels[index] = todo;
    meetingContentsModel[number] = dummyModel;
  }

  void removingTodos(int number, int index) {
    AgendaModel dummyModel = meetingContentsModel[number];
    dummyModel.todoModels.removeAt(index);
    meetingContentsModel[number] = dummyModel;
  }
}
