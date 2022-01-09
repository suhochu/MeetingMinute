import 'package:objectbox/objectbox.dart';

@Entity()
class MeetingMinute {
  MeetingMinute({
    this.id = 0,
    required this.projectName,
    required this.meetingMinuteId,
    required this.meetingTitle,
    required this.meetingTime,
    required this.meetingPlace,
    required this.meetingAttendants,
    required this.meetingModerator,
    required this.meetings,
    required this.selectedAttendantInt,
    required this.peopleList,
    required this.agendaListToString,
    required this.todoCount,
  });

  int id;
  String meetingMinuteId; //meetingMinuteId
  String projectName; //projectTeamCtrl
  String meetingTitle; //meetingTitleCtrl
  String meetingTime; //meetingDateCtrl
  String meetings; //meetingsCtrl
  String meetingPlace; //meetingPlaceCtrl
  String meetingModerator; //meetingModeratorCtrl
  List<String> meetingAttendants; //meetingAttendants
  List<String> selectedAttendantInt; //selectedAttendantInt
  List<String> peopleList; //peopleList
  List<AgendaModel> agendaList = [];
  List<String> agendaListToString = [];
  int todoCount = 0;

  MeetingMinute copyWith({
    String? meetingMinuteId,
    String? projectName,
    String? meetingTitle,
    String? meetingTime,
    String? meetings,
    String? meetingPlace,
    String? meetingModerator,
    List<String>? meetingAttendants,
    List<String>? selectedAttendantInt,
    List<String>? peopleList,
    List<String>? agendaListToString,
    int? todoCount,
  }) {
    return MeetingMinute(
      meetingMinuteId: meetingMinuteId ?? this.meetingMinuteId,
      projectName: projectName ?? this.projectName,
      meetingTitle: meetingTitle ?? this.meetingTitle,
      meetingTime: meetingTime ?? this.meetingTime,
      meetings: meetings ?? this.meetings,
      meetingPlace: meetingPlace ?? this.meetingPlace,
      meetingModerator: meetingModerator ?? this.meetingModerator,
      meetingAttendants: meetingAttendants ?? this.meetingAttendants,
      selectedAttendantInt: selectedAttendantInt ?? this.selectedAttendantInt,
      peopleList: peopleList ?? this.peopleList,
      agendaListToString: agendaListToString ?? this.agendaListToString,
      todoCount: todoCount ?? this.todoCount,
    );
  }
}

class AgendaModel {
  AgendaModel(
      {
      required this.agendaID,
      required this.agendaString,
      required this.agendaStatus,
      required this.issuedTime,
      required this.contentsModelsString,
      required this.todoModelsString});

  String agendaID = '';
  String agendaStatus = '';
  String issuedTime = '';
  String agendaString = '';
  String contentsModelsString = '';
  List<ContentsModel> contentsModels = [];
  String todoModelsString = '';
  List<TodoModel> todoModels = [];

  factory AgendaModel.fromJson(Map<String, dynamic> jsonData) {
    return AgendaModel(
        agendaID: jsonData['agendaID'],
        agendaString: jsonData['agendaString'],
        agendaStatus: jsonData['agendaStatus'],
        issuedTime: jsonData['issuedTime'],
        contentsModelsString: jsonData['contentsList'] ?? '',
        todoModelsString: jsonData['todosList'] ?? '');

  }

  Map<String, dynamic> toJson() {
    return{
      'agendaID' : agendaID,
      'agendaString' : agendaString,
      'agendaStatus' : agendaStatus,
      'issuedTime' : issuedTime,
      'contentsList' : contentsModelsString,
      'todosList' : todoModelsString,
    };
  }

  AgendaModel copyWith({
    String? agendaID,
    String? issuedTime,
    String? agendaString,
    String? agendaStatus,
    String? contentsModelsString,
    String? todoModelsString,
  }) {
    return AgendaModel(
      agendaID: agendaID ?? this.agendaID,
      issuedTime: issuedTime ?? this.issuedTime,
      agendaString: agendaString ?? this.agendaString,
      agendaStatus: agendaStatus ?? this.agendaStatus,
      contentsModelsString: contentsModelsString ?? this.contentsModelsString,
      todoModelsString: todoModelsString ?? this.todoModelsString,
    );
  }

}

class ContentsModel {
  ContentsModel({
    required this.contentsID,
    required this.contentsString,
    required this.issuedBy,
    required this.issuedDate,
  });

  String contentsID = '';
  String contentsString = '';
  String issuedBy;
  String issuedDate;


  factory ContentsModel.fromJson(Map<String, dynamic> jsonData){

    return ContentsModel(
        contentsID: jsonData['contentsID'],
        contentsString: jsonData['contentsString'],
        issuedBy: jsonData['issuedBy'],
        issuedDate: jsonData['issuedDate'],
    );

  }

  Map<String, dynamic> toJson() {
    return{
      'contentsID': contentsID,
      'contentsString': contentsString,
      'issuedBy': issuedBy,
      'issuedDate': issuedDate,
    };
  }
}

class TodoModel {
  TodoModel({
    required this.todoID,
    required this.todoString,
    required this.issuedTime,
    required this.dueDate,
    required this.responsible,
    required this.todoStatus,
    required this.intDueDate,
  });

  String todoID = '';
  String todoString = '';
  String issuedTime = '';
  String dueDate = '';
  String responsible = '';
  String todoStatus = '';
  int intDueDate = 0;

  factory TodoModel.fromJson(Map<String, dynamic> jsonData){
    return TodoModel(
        todoID:jsonData['todoID'],
        todoString:jsonData['todoString'],
        issuedTime:jsonData['issuedTime'],
        dueDate:jsonData['dueDate'],
        responsible:jsonData['responsible'],
        todoStatus:jsonData['todoStatus'],
        intDueDate:jsonData['intDueDate'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'todoID' : todoID,
      'todoString' : todoString,
      'issuedTime' : issuedTime,
      'dueDate' : dueDate,
      'responsible' : responsible,
      'todoStatus' : todoStatus,
      'intDueDate' : intDueDate,
    };
  }
}
