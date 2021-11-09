import 'package:get/get.dart';
import 'package:meetingminutes52/models/meeting_minute_controller.dart';
import 'package:meetingminutes52/models/meeting_resource_controller.dart';
import 'package:meetingminutes52/models/user_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MeetingMinuteController());
    Get.put(MeetingSourceController());
    Get.put(UserController());

  }
}
