import 'package:get/get.dart';
import 'package:meetingminutes52/models/project_model.dart';

class MeetingSourceController extends GetxController {

  RxList<ProjectModel> projects = <ProjectModel>[].obs;

  void removingProject(int index) {}

  void removingPeople(int number, int index) {
    ProjectModel dummyModel = projects[number];
    dummyModel.peoples.removeAt(index);
    projects[number] = dummyModel;
  }

  void addingPeople(int number, People newPeople) {
    ProjectModel dummyModel = projects[number];
    dummyModel.peoples.add(newPeople);
    projects[number] = dummyModel;
  }

}