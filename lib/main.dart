import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetingminutes52/components/bindings.dart';
import 'package:meetingminutes52/home.dart';
import 'package:meetingminutes52/theme/style.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // final UsedTargetPlatform _usedTargetPlatform = UsedTargetPlatform();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
        Locale('en', 'US'),
      ],
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      theme: selectedTheme(0),
      home: const Home(),
    );
  }

  ThemeData selectedTheme(int selected) {
    Map<String, Color> selectedColors = colorSetting[selected];

    return ThemeData(
      primaryColor: selectedColors['PRIMARY_COLOR'],
      accentColor: selectedColors['ACCENT_COLOR'],
      primaryColorDark: selectedColors['DARK_PRIMARY_COLOR'],
      primaryColorLight: selectedColors['LIGHT_PRIMARY_COLOR'],
      dividerColor: selectedColors['DIVIDER_COLOR'],
      // Text Theme 에 대한건 나중에 설정
    );
  }
}
