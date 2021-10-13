import 'package:get/get.dart';
import 'package:meetingminutes52/models/project_model.dart';

class MeetingSourceController extends GetxController {
  RxList<ProjectModel> projects = <ProjectModel>[].obs;
  RxInt selectedIndex = 0.obs;
  List<String> projectTeamList = [];

  void addingProject(ProjectModel newProject) {
    projects.add(newProject);
    updateProjectNameStringList();
  }

  void editingProject(int number, ProjectModel newProject) {
    projects[number] = newProject;
    updateProjectNameStringList();
  }

  void removingProject(int number) {
    projects.removeAt(number);
    updateProjectNameStringList();
  }

  void updateProjectNameStringList() {
    projectTeamList.clear();
    for (var value in projects) {
      projectTeamList.add(value.projectName);
    }
  }

  void addingPeople(int number, People newPeople) {
    ProjectModel dummyModel = projects[number];
    dummyModel.peoples.add(newPeople);
    projects[number] = dummyModel;
  }

  void editingPeople(int number, int index, People newPeople) {
    ProjectModel dummyModel = projects[number];
    dummyModel.peoples[index] = newPeople;
    projects[number] = dummyModel;
  }

  void removingPeople(int number, int index) {
    ProjectModel dummyModel = projects[number];
    dummyModel.peoples.removeAt(index);
    projects[number] = dummyModel;
  }

  void addingMeetingPlace(int number, String text) {
    ProjectModel dummyModel = projects[number];
    dummyModel.meetingPlace.add(text);
    projects[number] = dummyModel;
  }

  void editingMeetingPlace(int number, int index, String text) {
    ProjectModel dummyModel = projects[number];
    dummyModel.meetingPlace[index] = text;
    projects[number] = dummyModel;
  }

  void removingMeetingPlace(int number, int index) {
    ProjectModel dummyModel = projects[number];
    dummyModel.meetingPlace.removeAt(index);
    projects[number] = dummyModel;
  }

  void addingMeetings(int number, Meetings newMeeting) {
    ProjectModel dummyModel = projects[number];
    dummyModel.meetings.add(newMeeting);
    projects[number] = dummyModel;
  }

  void editingMeetings(int number, int index, Meetings newMeetings) {
    ProjectModel dummyModel = projects[number];
    dummyModel.meetings[index] = newMeetings;
    projects[number] = dummyModel;
  }

  void removingMeetings(int number, int index) {
    ProjectModel dummyModel = projects[number];
    dummyModel.meetings.removeAt(index);
    projects[number] = dummyModel;
  }
}
