import 'package:get/get.dart';
import 'package:meetingminutes52/models/user_model.dart';
import 'package:meetingminutes52/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class UserController extends GetxController {

  Rx<User> user = User(
    name: '세젤예쭈',
    email: 'cstarimage@naver.com',
    password: 'dlwndud',
    imagePath: 'assets/images/princessjju.png',
  ).obs;
  // todo: object box 와 연결 필요
  late Store _store;
  Box<User>? userBox;
  bool hasBeenInitialized = false;
  String imagePath = "";

  change({
    required String name,
    required String email,
    required String password,
    required String imagePath,
  }) {
    user.update((val){
      val!.name = name;
      val.email = email;
      val.password = password;
      val.imagePath = imagePath;
    });
  }


  @override
  void onInit() {
    super.onInit();
    getApplicationDocumentsDirectory().then((dir) {
      try {
        _store = Store(
          getObjectBoxModel(),
          directory: join(dir.path, 'objectbox'),
        );

        userBox = _store.box<User>();
        hasBeenInitialized = true;
      } catch (e) {
        print(e);
        hasBeenInitialized = false;
      }
      if (hasBeenInitialized) {
        // user = userBox!.get(0)!;
      }
    });
  }

  void editingUserName(String name) {
    change(name: name, email: user.value.email, password: user.value.password, imagePath: user.value.imagePath);
  }

  void editingUseEmail(String email) {
    change(name: user.value.name, email: email, password: user.value.password, imagePath: user.value.imagePath);
  }

  void updateProfileImage(String imagePath) {
    change(name: user.value.name, email: user.value.email, password: user.value.password, imagePath: imagePath);
  }

}