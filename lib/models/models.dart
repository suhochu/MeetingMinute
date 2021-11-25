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
  });

  int id;
  String meetingMinuteId;
  String projectName;
  String meetingTitle;
  String meetingTime;
  String meetingPlace;
  List<String> meetingAttendants;
  String meetingModerator;
  String meetings;

  @Backlink()
  final agendaList = ToMany<AgendaModel>();

  String? jsonAgendaModel;
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

  final meetingMinute = ToOne<MeetingMinute>();

  @Backlink()
  final contentsModels = ToMany<ContentsModel>();

  @Backlink()
  final todoModels = ToMany<TodoModel>();

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

  final agendaModel = ToOne<AgendaModel>();
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

  final agendaModel = ToOne<AgendaModel>();
}
