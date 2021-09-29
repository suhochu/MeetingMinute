import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetingminutes52/models/contents_model.dart';
import 'package:meetingminutes52/models/models.dart';

class MeetingTodoPage extends GetView<MeetingMinuteController> {

  final List<String?> combinedList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: _todoListBuilder(),
        ),
      ),
    );
  }

  List<Widget> _todoListBuilder() {


    List<TodoModel> todoList = todoListCombine();
    List<Widget> todoCardList = [];

    todoCardList = todoList.map((value) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  side: BorderSide(color: Color(0xff795548))),
              elevation: 1,
              margin: const EdgeInsets.all(2),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Text('${value.todoString}', style:  TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w400),),
                ),
              )
          ),
          SizedBox(height: 5,),
        ],
      );
    }).toList();
    return todoCardList;
  }

  List<TodoModel> todoListCombine() {
    combinedList.clear();
    List<TodoModel> todoList = [];
    for(int i = 0; i < controller.meetingContentsModel.length; i++) {
      controller.meetingContentsModel[i].todoModels.forEach((element) {
        todoList.add(element);
      });
    }
    return todoList;
  }

}
