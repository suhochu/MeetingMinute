// List<String> peoples = ['추수호', '이기동', '전준영', '주환엽', '조성환'];
List<String> meetings = ['아키텍처 디자인 리뷰', '프로젝트 회의', '브레인스토밍', '평가 결과 검토'];
List<String> meetingPlace = ['모비스온 화상회의', '팀즈 화상회의', '의장동 401회의실', '의장동 402회의실'];


class MeetingMinute {
  String meetingMinuteId;
  int agendaModelCount = 1;

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
  String issuedTime = '';
  String agendaString = '';
  int contentCount = 1;
  int todoCount = 1;
  List<ContentsModel> contentsModels;
  List<TodoModel> todoModels;
  String agendaStatus = '';

  String todoCountReturn() {
    todoCount++;
    return todoCount.toString();
  }

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
