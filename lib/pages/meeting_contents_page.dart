import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetingminutes52/components/textFieldStyle.dart';
import 'package:meetingminutes52/models/contents_model.dart';
import 'package:meetingminutes52/models/models.dart';
import 'package:meetingminutes52/theme/style.dart';

class MeetingContentsPage extends GetView<MeetingMinuteController> {
  final TextEditingController _agendaController = TextEditingController();
  final TextEditingController _contentsController = TextEditingController();
  final TextEditingController _todoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: Get.size.width * 0.95,
            child: Obx(() {
              return Column(
                children: _agendaListBuilder(),
              );
            }),
          ),
        ),
      ),
    );
  }

  Padding _newAgendaAddingButtonWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: _agendaCardWidget(
        widget: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            '아젠다 추가',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xffFFFFFF),
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        color: Color(0xff795548),
      ),
    );
  }

  Widget _agendaCardWidget({required Widget widget, required Color color}) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: BorderSide(color: Color(0xff795548))),
      elevation: 1,
      margin: const EdgeInsets.all(2),
      color: color,
      child: Center(
        child: widget,
      ),
    );
  }

  List<Widget> _agendaListBuilder() {
    List<Widget> cardList = [];
    cardList = List.generate(
      controller.meetingContentsModel.length + 1,
      (index) {
        if (index == controller.meetingContentsModel.length) {
          return GestureDetector(
            child: _newAgendaAddingButtonWidget(),
            onTap: () => _addingAgendaMethod(index), //Adding Contents
          );
        } else {
          return _agendaExpansion(index);
        }
      },
    );

    return cardList;
  }

  ExpansionTile _agendaExpansion(int index) {
    return ExpansionTile(
      childrenPadding: const EdgeInsets.symmetric(vertical: 5),
      title: _agendaCardWidget(
        widget: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 4),
                GestureDetector(
                  child: Text(
                      '${index + 1}. ${controller.meetingContentsModel[index].agendaString}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                  onTap: () => _editingAgendaMethod(index), // Editing Contents
                  onLongPress: () async {
                    bool? deleteParameter = await _removeAgendaMethod(index);
                    if (deleteParameter!) {
                      controller.removingAgenda(index); //Remove Contents
                    }
                  },
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    smallTextStyle(
                      context: 'Initiated',
                      color: Colors.red,
                    ),
                    smallTextStyle(
                      context: DateTime.now().toString().split(' ')[0],
                    ),
                    smallTextStyle(
                      context: '컨텐츠',
                      color: Colors.green,
                      onTap: () {
                        _addingContentsMethod(index);
                      },
                    ),
                    smallTextStyle(
                      context: 'Todo',
                      color: Colors.blueAccent,
                      onTap: () {
                        _addingTodosMethod(index);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        color: Color(0xffFFFFFF),
      ),
      initiallyExpanded: true,
      tilePadding: EdgeInsets.all(0),
      collapsedBackgroundColor: Colors.transparent,
      children: [
        Column(children: [
          ..._contentsExpansions(index),
          SizedBox(
            height: 5,
          ),
        ]),
        Column(
          children: [
            ..._todoExpansions(index),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ],
    );
  }

  void _addingAgendaMethod(int index) {
    _agendaController.clear();
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  '아젠다 추가',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _agendaController,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.center,
                  decoration: textFormFieldInputSytle(
                      '아젠다 #${index + 1} 를 입력하세요', null),
                  style: TextStyle(color: Color(0xff5D4037)),
                  maxLines: 2,
                  maxLength: 40,
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text('완료'),
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xffFF5722),
                      minimumSize: Size(70, 35),
                      textStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                  onPressed: () {
                    controller.addingAgenda(_agendaController.text);
                    _agendaController.clear();
                    print(_agendaController.text);
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      isDismissible: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(35),
        side: BorderSide(
          width: 1,
          color: Color(0xff5D4037),
        ),
      ),
      enableDrag: true,
    );
  }

  void _editingAgendaMethod(int index) {
    _agendaController.text =
        controller.meetingContentsModel[index].agendaString;
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  '아젠다 수정',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _agendaController,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintStyle:
                        TextStyle(fontSize: 16, color: Color(0xffD7CCC8)),
                    fillColor: Color(0xffD7CCC8).withOpacity(0.1),
                    filled: true,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff795548).withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xff5D4037), width: 2),
                    ),
                  ),
                  style: TextStyle(color: Color(0xff5D4037)),
                  maxLines: 2,
                  maxLength: 40,
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text('완료'),
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xffFF5722),
                      minimumSize: Size(70, 35),
                      textStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                  onPressed: () {
                    controller.editingAgenda(index, _agendaController.text);
                    _agendaController.clear();
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      isDismissible: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(35),
        side: BorderSide(
          width: 1,
          color: Color(0xff5D4037),
        ),
      ),
      enableDrag: true,
    );
  }

  Future<bool?> _removeAgendaMethod(int index) async {
    return await Get.defaultDialog<bool>(
      title: '아젠다 지움 확인',
      titleStyle: TextStyle(fontWeight: FontWeight.bold),
      middleText:
          '"${controller.meetingContentsModel[index].agendaString}"를 삭제 합니까?',
      backgroundColor: Color(0xff795548),
      textCancel: '아니오',
      textConfirm: '예',
      barrierDismissible: false,
      radius: 50,
      onCancel: () {
        Get.back(result: false);
      },
      onConfirm: () {
        Get.back(result: true);
      },
    );
  }

  List<Widget> _contentsExpansions(int number) {
    List<Widget> contentsList = List.generate(
        controller.meetingContentsModel[number].contentsModels.length, (index) {
      return GestureDetector(
          onTap: () {
            _editingContentsMethod(number, index);
          },
          onLongPress: () async {
            bool? deleteParameter = await _removeContentsMethod(number, index);
            if (deleteParameter!) {
              controller.removingContents(number, index);
            }
          },
          child: Container(
            color: Colors.green.withOpacity(0.1),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 6,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      child: Text(
                        '${index + 1}',
                        style:
                            TextStyle(color: Color(0xffFFFFFF), fontSize: 14),
                      ),
                      backgroundColor: Colors.green,
                      radius: 10.0,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      '${controller.meetingContentsModel[number].contentsModels[index].contentsString}',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(
                  height: 6,
                ),
                Container(
                  height: 1,
                  color: Colors.green,
                ),
              ],
            ),
          ));
    });
    return contentsList;
  }

  void _addingContentsMethod(int number) {
    _contentsController.clear();
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  '컨텐츠 추가',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _contentsController,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.center,
                  decoration: textFormFieldInputSytle('새로운 컨텐츠를 입력하세요', null),
                  style: TextStyle(color: Color(0xff5D4037)),
                  maxLines: 2,
                  maxLength: 100,
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text('완료'),
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xffFF5722),
                      minimumSize: Size(70, 35),
                      textStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                  onPressed: () {
                    ContentsModel content = ContentsModel(
                        contentsID:
                            controller.meetingContentsModel[number].agendaID +
                                controller.meetingContentsModel[number]
                                    .contentsCountReturn(),
                        contentsString: _contentsController.text);
                    controller.addingContents(number, content);
                    _contentsController.clear();
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      isDismissible: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(35),
        side: BorderSide(
          width: 1,
          color: Color(0xff5D4037),
        ),
      ),
      enableDrag: true,
    );
  }

  void _editingContentsMethod(int number, int index) {
    _contentsController.text = controller
        .meetingContentsModel[number].contentsModels[index].contentsString;
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  '컨텐츠 수정',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _contentsController,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintStyle:
                        TextStyle(fontSize: 16, color: Color(0xffD7CCC8)),
                    fillColor: Color(0xffD7CCC8).withOpacity(0.1),
                    filled: true,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff795548).withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xff5D4037), width: 2),
                    ),
                  ),
                  style: TextStyle(color: Color(0xff5D4037)),
                  maxLines: 2,
                  maxLength: 40,
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text('완료'),
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xffFF5722),
                      minimumSize: Size(70, 35),
                      textStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                  onPressed: () {
                    ContentsModel content = ContentsModel(
                        contentsID: controller.meetingContentsModel[number]
                            .contentsModels[index].contentsString,
                        contentsString: _contentsController.text);
                    controller.editingContent(number, index, content);
                    _contentsController.clear();
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      isDismissible: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(35),
        side: BorderSide(
          width: 1,
          color: Color(0xff5D4037),
        ),
      ),
      enableDrag: true,
    );
  }

  Future<bool?> _removeContentsMethod(int number, int index) async {
    return await Get.defaultDialog<bool>(
      title: '컨텐츠 지움 확인',
      titleStyle: TextStyle(fontWeight: FontWeight.bold),
      middleText:
          '"${controller.meetingContentsModel[number].contentsModels[index]}"를 삭제 합니까?',
      backgroundColor: Color(0xff795548),
      textCancel: '아니오',
      textConfirm: '예',
      barrierDismissible: false,
      radius: 50,
      onCancel: () {
        Get.back(result: false);
      },
      onConfirm: () {
        Get.back(result: true);
      },
    );
  }

  List<Widget> _todoExpansions(int number) {
    List<Widget> todoList = List.generate(
        controller.meetingContentsModel[number].todoModels.length, (index) {
      return GestureDetector(
          onTap: () {
            _editingTodosMethod(number, index);
          },
          onLongPress: () async {
            bool? deleteParameter = await _removingTodosMethod(number, index);
            if (deleteParameter!) {
              controller.removingTodos(number, index);
            }
          },
          child: Container(
            color: Colors.blue.withOpacity(0.1),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 6,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      child: Text(
                        '${index + 1}',
                        style:
                            TextStyle(color: Color(0xffFFFFFF), fontSize: 14),
                      ),
                      backgroundColor: Colors.blue,
                      radius: 10.0,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      '${controller.meetingContentsModel[number].todoModels[index].todoString}',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(
                  height: 6,
                ),
                Container(
                  height: 1,
                  color: Colors.blue,
                ),
              ],
            ),
          ));
    });
    return todoList;
  }

  void _addingTodosMethod(int number) {
    _todoController.clear();
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Todo 추가',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _todoController,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.center,
                  decoration: textFormFieldInputSytle('신규 Todo 를 입력하세요', null),
                  style: TextStyle(color: Color(0xff5D4037)),
                  maxLines: 2,
                  maxLength: 40,
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text('완료'),
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xffFF5722),
                      minimumSize: Size(70, 35),
                      textStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                  onPressed: () {
                    TodoModel todo = TodoModel(
                        todoID:
                            controller.meetingContentsModel[number].agendaID +
                                controller.meetingContentsModel[number]
                                    .todoCountReturn(),
                        todoString: _todoController.text);
                    controller.addingTodo(number, todo);
                    _todoController.clear();
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      isDismissible: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(35),
        side: BorderSide(
          width: 1,
          color: Color(0xff5D4037),
        ),
      ),
      enableDrag: true,
    );
  }

  void _editingTodosMethod(int number, int index) {
    _todoController.text =
        controller.meetingContentsModel[number].todoModels[index].todoString;
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          height: Get.size.height * 0.3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Todo 수정',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _todoController,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintStyle:
                        TextStyle(fontSize: 16, color: Color(0xffD7CCC8)),
                    fillColor: Color(0xffD7CCC8).withOpacity(0.1),
                    filled: true,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff795548).withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xff5D4037), width: 2),
                    ),
                  ),
                  style: TextStyle(color: Color(0xff5D4037)),
                  maxLines: 2,
                  maxLength: 40,
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text('완료'),
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xffFF5722),
                      minimumSize: Size(70, 35),
                      textStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                  onPressed: () {
                    TodoModel todo = TodoModel(
                        todoID: controller.meetingContentsModel[number]
                            .todoModels[index].todoID,
                        todoString: _todoController.text);
                    controller.editingTodos(
                        number, index, todo);
                    _todoController.clear();
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      isDismissible: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(35),
        side: BorderSide(
          width: 1,
          color: Color(0xff5D4037),
        ),
      ),
      enableDrag: true,
    );
  }

  Future<bool?> _removingTodosMethod(int number, int index) async {
    return await Get.defaultDialog<bool>(
      title: 'Todo 지움 확인',
      titleStyle: TextStyle(fontWeight: FontWeight.bold),
      middleText:
          '"${controller.meetingContentsModel[number].todoModels[index]}"를 삭제 합니까?',
      backgroundColor: Color(0xff795548),
      textCancel: '아니오',
      textConfirm: '예',
      barrierDismissible: false,
      radius: 50,
      onCancel: () {
        Get.back(result: false);
      },
      onConfirm: () {
        Get.back(result: true);
      },
    );
  }
}
