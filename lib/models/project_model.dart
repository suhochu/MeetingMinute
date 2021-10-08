class ProjectModel {
  ProjectModel({required this.projectName, required this.teamName});

  String projectName;
  String teamName;
  List<People> peoples = [];
  List<String> meetings = [];
  List<String> meetingPlace = [];
}

class People {
  People({
    required this.name,
    required this.email,
    required this.organization,
  });

  String name;
  String email;
  String organization;
}
