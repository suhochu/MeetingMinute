import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetingminutes52/models/models.dart';

class MeetingMinuteController extends GetxController {
  String meetingMinuteId = '';
  String meetingTitle = '';
  String meetingTime = '';
  String meetingPlace = '';
  String meetingAttendants = '';
  String meetingModerator = '';
  String meetings = '';
  RxList<AgendaModel> meetingContentsModel = <AgendaModel>[].obs;
  int agendaModelCount = 1;

  final formKey = GlobalKey<FormState>();
  var selectedValues = Set<int>().obs;

  @override
  void onInit() {
    super.onInit();
    meetingMinuteId = calIdWithMakingTime();
    print('meetingMinuteId is $meetingMinuteId');
    addingAgenda('SW 변경 검토');
    addingAgenda('HW 설계 검토');
    addingAgenda('FMEA 계획 검토');
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

  void addingAgenda(String agendaString) {
    meetingContentsModel.add(
      AgendaModel(
        agendaID: meetingMinuteId + agendaModelCount.toString(),
        agendaString: agendaString,
        contentsModels: [],
        todoModels: [],
      ),
    );
    agendaModelCount++;
  }

  void editingAgenda(int number, String agendaTitle) {
    AgendaModel dummyModel = meetingContentsModel[number];
    dummyModel.agendaString = agendaTitle;
    meetingContentsModel[number] = dummyModel;
  }

  void removingAgenda(int number) {
    meetingContentsModel.removeAt(number);
  }

  String agendaIdReturn(int number){
    return  meetingMinuteId + meetingContentsModel[number].agendaID;
  }

  void addingContents(int number, ContentsModel content) {
    AgendaModel dummyModel = meetingContentsModel[number];
    dummyModel.contentsModels.add(content);
    meetingContentsModel[number] = dummyModel;
  }

  void editingContent(int number, int index, ContentsModel content) {
    AgendaModel dummyModel = meetingContentsModel[number];
    dummyModel.contentsModels[index] = content;
    meetingContentsModel[number] = dummyModel;
  }

  void removingContents(int number, int index) {
    AgendaModel dummyModel = meetingContentsModel[number];
    dummyModel.contentsModels.removeAt(index);
    meetingContentsModel[index] = dummyModel;
  }

  void addingTodo(int number, TodoModel todo) {
    AgendaModel dummyModel = meetingContentsModel[number];
    dummyModel.todoModels.add(todo);
    meetingContentsModel[number] = dummyModel;
  }

  void editingTodos(int number, int index, TodoModel todo) {
    AgendaModel dummyModel = meetingContentsModel[number];
    dummyModel.todoModels[index] = todo;
    meetingContentsModel[number] = dummyModel;
  }

  void removingTodos(int number, int index) {
    AgendaModel dummyModel = meetingContentsModel[number];
    dummyModel.todoModels.removeAt(index);
    meetingContentsModel[index] = dummyModel;
  }
}
