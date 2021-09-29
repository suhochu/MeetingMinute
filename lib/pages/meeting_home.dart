import 'package:flutter/material.dart';
import 'package:meetingminutes52/pages/meeting_contents_page.dart';
import 'package:meetingminutes52/pages/meeting_minute_page.dart';
import 'package:meetingminutes52/pages/meeting_todo_page.dart';

class MeetingHomePage extends StatefulWidget {
  const MeetingHomePage({Key? key}) : super(key: key);

  @override
  _MeetingHomePageState createState() => _MeetingHomePageState();
}

class _MeetingHomePageState extends State<MeetingHomePage> {

  int _selectedIndex = 0;
  List<String> _appBarTitle = ['기본 정보', '회의 내용', '해야 할일'];

  final List<Widget> _meetingPages = [
    MeetingMinutePage(),
    MeetingContentsPage(),
    MeetingTodoPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: meetingMinutePageAppBar(),
      drawer: meetingMinuteDrawer(),
      body: meetingMinuteBody(),
      bottomNavigationBar: meetingBottomNavi(),

    );
  }

  AppBar meetingMinutePageAppBar() {
    return AppBar(
      iconTheme: IconThemeData(color: Color(0xff5D4037)),
      actions: [
        IconButton(
          icon: Icon(Icons.save),
          onPressed: (){},
        ),
        IconButton(
          icon: Icon(Icons.file_upload),
          onPressed: (){},
        ),
        IconButton(
          icon: Icon(Icons.link),
          onPressed: (){},
        ),

      ],
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        _appBarTitle[_selectedIndex],
        style: TextStyle(
            fontSize: 20,
            color: Color(0xff5D4037),
            fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      // centerTitle: true,
    );
  }

  Drawer meetingMinuteDrawer() {
    return Drawer(
      child: Container(
        color: Color(0xff795548),
      ),
    );
  }

  Widget meetingMinuteBody() {
    return _meetingPages[_selectedIndex];
  }

  BottomNavigationBar meetingBottomNavi() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color(0xff795548),
      selectedItemColor: Color(0xffFFFFFF),
      unselectedItemColor: Color(0xffD7CCC8).withOpacity(0.5),
      selectedFontSize: 14,
      unselectedFontSize: 14,
      currentIndex: _selectedIndex,
      onTap: (int index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          label: '기본 정보',
          icon: Icon(Icons.info),
        ),
        BottomNavigationBarItem(
          label: '회의 내용',
          icon: Icon(Icons.question_answer),
        ),
        BottomNavigationBarItem(
          label: '해야 할일',
          icon: Icon(Icons.engineering),
        ),
      ],
    );
  }
}
