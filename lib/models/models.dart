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
  String agendaListString = '';

  @Backlink()
  var agendaList = ToMany<AgendaModel>();

  MeetingMinute copyWith({
    String? meetingMinuteId,
    String? projectName,
    String? meetingTitle,
    String? meetingTime,
    String? meetingPlace,
    String? meetingModerator,
    String? meetings,
    List<String>? meetingAttendants,
    List<String>? selectedAttendantInt,
    List<String>? peopleList,
  }) {
    return MeetingMinute(
      meetingMinuteId: meetingMinuteId ?? this.meetingMinuteId,
      projectName: projectName ?? this.projectName,
      meetingTitle: meetingTitle ?? this.meetingTitle,
      meetingTime: meetingTime ?? this.meetingTime,
      meetingPlace: meetingPlace ?? this.meetingPlace,
      meetingAttendants: meetingAttendants ?? this.meetingAttendants,
      meetingModerator: meetingModerator ?? this.meetingModerator,
      selectedAttendantInt: selectedAttendantInt ?? this.selectedAttendantInt,
      peopleList: peopleList ?? this.peopleList,
      meetings: meetings ?? this.meetings,
    );
  }
}

@Entity()
class AgendaModel {
  AgendaModel(
      {this.id = 0,
      required this.agendaID,
      required this.agendaString,
      required this.agendaStatus,
      required this.issuedTime});

  int id;
  String agendaID = '';
  String agendaStatus = '';
  String issuedTime = '';
  String agendaString = '';

  var meetingMinute = ToOne<MeetingMinute>();

  @Backlink()
  var contentsModels = ToMany<ContentsModel>();

  @Backlink()
  var todoModels = ToMany<TodoModel>();

  factory AgendaModel.fromJson(Map<String, dynamic> jsonData) {
    return AgendaModel(
        agendaID: jsonData['agendaID'],
        agendaString: jsonData['agendaString'],
        agendaStatus: jsonData['agendaStatus'],
        issuedTime: jsonData['issuedTime']);
  }

  Map<String, dynamic> toJson() {
    return{
      'agendaID' : agendaID,
      'agendaString' : agendaStatus,
      'agendaStatus' : issuedTime,
      'issuedTime' : agendaString,
    };
  }

  AgendaModel copyWith({
    String? agendaID,
    String? issuedTime,
    String? agendaString,
    String? agendaStatus,
  }) {
    return AgendaModel(
      agendaID: agendaID ?? this.agendaID,
      issuedTime: issuedTime ?? this.issuedTime,
      agendaString: agendaString ?? this.agendaString,
      agendaStatus: agendaStatus ?? this.agendaStatus,
    );
  }
}

@Entity()
class ContentsModel {
  ContentsModel({
    this.id = 0,
    required this.contentsID,
    required this.contentsString,
    required this.issuedBy,
    required this.issuedDate,
  });

  int id;
  String contentsID = '';
  String contentsString = '';
  String issuedBy;
  String issuedDate;

  var agendaModel = ToOne<AgendaModel>();

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

@Entity()
class TodoModel {
  TodoModel({
    this.id = 0,
    required this.todoID,
    required this.todoString,
    required this.issuedTime,
    required this.dueDate,
    required this.responsible,
    required this.todoStatus,
    required this.intDueDate,
  });

  int id;
  String todoID = '';
  String todoString = '';
  String issuedTime = '';
  String dueDate = '';
  String responsible = '';
  String todoStatus = '';
  int intDueDate = 0;

  var agendaModel = ToOne<AgendaModel>();

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
