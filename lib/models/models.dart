class MeetingMinute {

  MeetingMinute({
    required this.projectName,
    required this.meetingMinuteId,
    required this.meetingTitle,
    required this.meetingTime,
    required this.meetingPlace,
    required this.meetingAttendants,
    required this.meetingModerator,
    required this.meetings,
    required this.agendaList,
  });

  String meetingMinuteId;
  String projectName;
  String meetingTitle;
  String meetingTime;
  String meetingPlace;
  String meetingAttendants;
  String meetingModerator;
  String meetings;
  List<AgendaModel> agendaList = [];
}

class AgendaModel {
  AgendaModel(
      {required this.agendaID,
      required this.agendaString,
      required this.contentsModels,
      required this.todoModels,
      required this.agendaStatus,
      required this.issuedTime});

  String agendaID = '';
  String agendaStatus = '';
  String issuedTime = '';
  String agendaString = '';
  List<ContentsModel> contentsModels = [];
  List<TodoModel> todoModels = [];

  AgendaModel copyWith({
    String? agendaID,
    String? issuedTime,
    String? agendaString,
    List<ContentsModel>? contentsModels,
    List<TodoModel>? todoModels,
    String? agendaStatus,
  }) {
    return AgendaModel(
      agendaID: agendaID ?? this.agendaID,
      issuedTime: issuedTime ?? this.issuedTime,
      agendaString: agendaString ?? this.agendaString,
      contentsModels: contentsModels ?? this.contentsModels,
      todoModels: todoModels ?? this.todoModels,
      agendaStatus: agendaStatus ?? this.agendaStatus,
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
}
