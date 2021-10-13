import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetingminutes52/models/meeting_minute_controller.dart';
import 'package:meetingminutes52/models/models.dart';
import 'package:meetingminutes52/theme/color_style.dart';

class MeetingTodoPage extends GetView<MeetingMinuteController> {
  const MeetingTodoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: _todoListBuilder(context),
        ),
      ),
    );
  }

  List<Widget> _todoListBuilder(BuildContext ctx) {
    List<TodoModel> todoList = todoListCombine();
    todoList.sort((a, b) => a.intDueDate.compareTo(b.intDueDate));
    List<Widget> todoCardList = [];
    todoCardList = todoList.map((value) {
      return Column(
        children: [
          GestureDetector(
            onTap: (){},
            child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0), side: const BorderSide(color: Color(0xff795548))),
                elevation: 1,
                margin: const EdgeInsets.all(2),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      IntrinsicWidth(
                        child: Column(
                          children: [
                            SizedBox(
                              width: 120,
                                child: Text(value.dueDate, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400), textAlign: TextAlign.center)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(value.todoStatus, style: TextStyle(fontSize: 12, color: selectColor(value.todoStatus)), textAlign: TextAlign.center),
                                Text(value.responsible, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300, fontStyle: FontStyle.italic), textAlign: TextAlign.center),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15,),
                      Expanded(child: Text(value.todoString, style: const TextStyle(fontSize: 14), textAlign: TextAlign.start, overflow: TextOverflow.ellipsis,)),
                    ],
                  ),
                )),
          ),
          const SizedBox(height: 10,),
        ],
      );
    }).toList();
    return todoCardList;
  }

  List<TodoModel> todoListCombine() {
    List<TodoModel> todoList = [];
    for (int i = 0; i < controller.meetingContentsModel.length; i++) {
      for (var element in controller.meetingContentsModel[i].todoModels) {
        todoList.add(element);
      }
    }

    return todoList;
  }
}
