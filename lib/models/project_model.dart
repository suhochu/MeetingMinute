import 'package:objectbox/objectbox.dart';

@Entity()
class ProjectModel {
  ProjectModel({
    required this.projectName,
    required this.teamName,
    this.id = 0,
  });

  int id;
  String projectName;
  String teamName;
  List<String> meetingPlace = [];

  @Backlink()
  final peoples = ToMany<People>();

  @Backlink()
  final meetings = ToMany<Meetings>();


}

@Entity()
class People {
  People({
    required this.name,
    required this.email,
    required this.team,
  });

  int id = 0;
  String name;
  String email;
  String team;

  final project = ToOne<ProjectModel>();

  People.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        team = json['team'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'team': team,
      };
}

@Entity()
class Meetings {
  Meetings({
    required this.meetingName,
    required this.meetingTiming,
  });

  int id = 0;
  String meetingName;
  String meetingTiming;

  final project = ToOne<ProjectModel>();

  Meetings.fromJson(Map<String, dynamic> json)
      : meetingName = json['meetingName'],
        meetingTiming = json['meetingTiming'];

  Map<String, dynamic> toJson() => {
    'meetingName': meetingName,
    'meetingTiming': meetingTiming,
  };
}
