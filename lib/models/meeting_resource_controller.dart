import 'package:get/get.dart';
import 'package:meetingminutes52/models/project_model.dart';
import 'package:meetingminutes52/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class MeetingSourceController extends GetxController {
  RxList<ProjectModel> projects = <ProjectModel>[].obs;
  List<String> projectTeamList = [];

  late Store _store;
  Box<ProjectModel>? projectBox;

  bool hasBeenInitialized = false;
  bool hasBeenUpdated = false;
  bool notYetSaved = false;

  @override
  void onInit() {
    super.onInit();
    getApplicationDocumentsDirectory().then((dir) {
      try {
        _store = Store(
          getObjectBoxModel(),
          directory: join(dir.path, 'meeting_Resource'),
        );

        projectBox = _store.box<ProjectModel>();
        hasBeenInitialized = true;
      } catch (e) {
        Get.defaultDialog(middleText: '데이터를 읽어 오지 못했습니다.');
        hasBeenInitialized = false;
      } // todo 이 코드를 테스트 해봐야 함
      if (hasBeenInitialized) {
        List<ProjectModel> initialProjectModelList = projectBox!.getAll();
      if (initialProjectModelList.isNotEmpty) {
        projects.value = initialProjectModelList;
        updateProjectNameStringList();
      }
      }
    });
  }

  void addingProject(ProjectModel newProject) {
    projects.add(newProject);
    updateProjectNameStringList();
    hasBeenUpdated = true;
    notYetSaved = true;
  }

  void editingProject(int number, String newProjectName, String newTeamName) {
    ProjectModel dummyModel = projects[number];
    dummyModel.projectName = newProjectName;
    dummyModel.teamName = newTeamName;
    projects[number] = dummyModel;
    updateProjectNameStringList();
    hasBeenUpdated = true;
    notYetSaved = true;
  }

  void removingProject(int number) {
    projects.removeAt(number);
    updateProjectNameStringList();
    hasBeenUpdated = true;
    notYetSaved = true;
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
    hasBeenUpdated = true;
    notYetSaved = true;
  }

  void editingPeople(int number, int index, People newPeople) {
    ProjectModel dummyModel = projects[number];
    dummyModel.peoples[index] = newPeople;
    projects[number] = dummyModel;
    hasBeenUpdated = true;
    notYetSaved = true;
  }

  void removingPeople(int number, int index) {
    ProjectModel dummyModel = projects[number];
    dummyModel.peoples.removeAt(index);
    projects[number] = dummyModel;
    hasBeenUpdated = true;
    notYetSaved = true;
  }

  void addingMeetingPlace(int number, String text) {
    ProjectModel dummyModel = projects[number];
    dummyModel.meetingPlace.add(text);
    projects[number] = dummyModel;
    hasBeenUpdated = true;
    notYetSaved = true;
  }

  void editingMeetingPlace(int number, int index, String text) {
    ProjectModel dummyModel = projects[number];
    dummyModel.meetingPlace[index] = text;
    projects[number] = dummyModel;
    hasBeenUpdated = true;
    notYetSaved = true;
  }

  void removingMeetingPlace(int number, int index) {
    ProjectModel dummyModel = projects[number];
    dummyModel.meetingPlace.removeAt(index);
    projects[number] = dummyModel;
    hasBeenUpdated = true;
    notYetSaved = true;
  }

  void addingMeetings(int number, Meetings newMeeting) {
    ProjectModel dummyModel = projects[number];
    dummyModel.meetings.add(newMeeting);
    projects[number] = dummyModel;
    hasBeenUpdated = true;
    notYetSaved = true;
  }

  void editingMeetings(int number, int index, Meetings newMeetings) {
    ProjectModel dummyModel = projects[number];
    dummyModel.meetings[index] = newMeetings;
    projects[number] = dummyModel;
    hasBeenUpdated = true;
    notYetSaved = true;
  }

  void removingMeetings(int number, int index) {
    ProjectModel dummyModel = projects[number];
    dummyModel.meetings.removeAt(index);
    projects[number] = dummyModel;
    hasBeenUpdated = true;
    notYetSaved = true;
  }

  void saveToDB() {
    List<int> id = projectBox!.putMany(projects);
    print('id is $id');
    hasBeenUpdated = false;
  }

  void deleteDB() {
    projectBox!.removeAll();
    projectTeamList.clear();
    projects.clear();
  }

  void showDB() {
    List<ProjectModel> temp = projectBox!.getAll();
    for (int i = 0; i < temp.length; i++) {
      print('projectName is : ${temp[i].projectName}');
      print('project Id is ${temp[i].id}');
      for (int j = 0; j < temp[i].peoples.length; j++) {
        print(temp[i].peoples[j].name);
      }
      for (int k = 0; k < temp[i].meetings.length; k++) {
        print(temp[i].meetings[k].meetingName);
      }
      for (int l = 0; l < temp[i].meetingPlace.length; l++) {
        print(temp[i].meetingPlace[l]);
      }
    }
  }
}
