import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetingminutes52/models/models.dart';

class MeetingMinuteController extends GetxController {
  String projectName = '';
  RxInt selectedProject = (-1).obs;
  String meetingMinuteId = '';
  String meetingTitle = '';
  String meetingTime = '';
  String meetingPlace = '';
  String meetingAttendants = '';
  String meetingModerator = '';
  String meetings = '';
  RxList<AgendaModel> meetingContentsModel = <AgendaModel>[].obs;
  int agendaModelCount = 1;
  RxString tempAgendaStatus = status[0].obs;
  RxString tempContentsIssuedBy = ''.obs;
  RxString tempTodoStatus = status[0].obs;
  RxString tempTodoResponsible = ''.obs;
  RxString tempTodoDueData = ''.obs;


  final formKey = GlobalKey<FormState>();
  var selectedValues = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    meetingMinuteId = calIdWithMakingTime();
    // addingAgenda('SW 변경 검토');
    // addingAgenda('HW 설계 검토');
    // addingAgenda('FMEA 계획 검토');
  }

  String calIdWithMakingTime() {
    return DateTime.now().toString().split(' ')[0].split('-')[0] +
        DateTime.now().toString().split(' ')[0].split('-')[1] +
        DateTime.now().toString().split(' ')[0].split('-')[2];
  }

  void editingSelectedValues(Set<int> changedValues) {
    selectedValues.clear();
    selectedValues.addAll(changedValues);
  }

  void addingAgenda(
      String agendaString, String agendaStatus, String issuedTime) {
    meetingContentsModel.add(
      AgendaModel(
          agendaID: meetingMinuteId + '-' + agendaModelCount.toString(),
          agendaString: agendaString,
          contentsModels: [],
          todoModels: [],
          agendaStatus: agendaStatus,
          issuedTime: issuedTime),
    );
    agendaModelCount++;
  }

  void editingAgenda(
      int number, String agendaTitle, String issuedTime, String agendaStatus) {
    meetingContentsModel[number] = meetingContentsModel[number].copyWith(
        agendaString: agendaTitle,
        issuedTime: issuedTime,
        agendaStatus: agendaStatus);
  }

  void removingAgenda(int number) {
    meetingContentsModel.removeAt(number);
  }

  void addingContents(int number, ContentsModel content) {
    AgendaModel dummyModel = meetingContentsModel[number];
    dummyModel.contentsModels.add(content);
    meetingContentsModel[number] = meetingContentsModel[number].copyWith(
      contentsModels: dummyModel.contentsModels
    );
    meetingContentsModel[number].contentCount++;
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
    meetingContentsModel[number].todoCount++;
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
