import 'package:get/get.dart';
import 'package:meetingminutes52/models/contents_model.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MeetingMinuteController());
  }
}
