class ProjectModel {
  ProjectModel({required this.projectName, required this.teamName});

  String projectName;
  String teamName;
  List<People> peoples = [];
  List<Meetings> meetings = [];
  List<String> meetingPlace = [];
}

class People {
  People({
    required this.name,
    required this.email,
    required this.team,
  });

  String name;
  String email;
  String team;
}

class Meetings {
  Meetings({
    required this.meetingName,
    required this.meetingTiming,
  });

  String meetingName;
  String meetingTiming;
}
