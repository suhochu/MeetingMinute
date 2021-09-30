import 'package:flutter/material.dart';
import 'package:meetingminutes52/pages/login_page.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LoginPage(),
    );
  }
}


// 플렛폼 관련 코드는 추후에 작성
// enum MyPlatform {
//   Android,
//   IOS,
//   Web,
// }
//
// class UsedTargetPlatform {
//
//   MyPlatform _myPlatform = MyPlatform.Android;
//
//   int _userColor = 0; // Colors 선택 Param
//
//   Widget usedPlatform() {
//     if (Platform.isAndroid) {
//       _myPlatform = MyPlatform.Android;
//       return GetMaterialApp(
//         debugShowCheckedModeBanner: false,
//         theme: selectedTheme(_userColor),
//         home: Home(),
//       );
//     } else if (Platform.isIOS) {
//       _myPlatform = MyPlatform.IOS;
//       return GetCupertinoApp();
//     } else if (kIsWeb) {
//       _myPlatform = MyPlatform.Web;
//       return GetMaterialApp();
//       // 플랫폼이 웹일 경우는 사용자의 선택에 따라서 Android 혹은 IOS 디자인중 선택 가능하도록 설계
//     } else {
//       return GetMaterialApp();
//       // 지원하지 않는 플랫폼인 경우는 경고가 필요함
//     }
//   }
