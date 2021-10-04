import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetingminutes52/components/buttons.dart';
import 'package:meetingminutes52/components/custom_card.dart';
import 'package:meetingminutes52/components/textfield_style.dart';
import 'package:meetingminutes52/components/time_component.dart';
import 'package:meetingminutes52/models/contents_model.dart';
import 'package:meetingminutes52/models/models.dart' as model;
import 'package:meetingminutes52/theme/color_style.dart';
import 'package:meetingminutes52/theme/text_style.dart';

class MeetingContentsPage extends GetView<MeetingMinuteController> {
  final TextEditingController _agendaController = TextEditingController();
  final TextEditingController _contentsController = TextEditingController();
  final TextEditingController _todoController = TextEditingController();

  MeetingContentsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: Get.size.width * 0.95,
            child: Obx(() {
              return Column(
                children: _agendaListBuilder(context),
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
      child: agendaCardWidget(
        widget: const Padding(
          padding: EdgeInsets.all(5.0),
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
        color: const Color(0xff795548),
      ),
    );
  }

  List<Widget> _agendaListBuilder(BuildContext ctx) {
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
          return _agendaExpansion(ctx, index);
        }
      },
    );

    return cardList;
  }

  ExpansionTile _agendaExpansion(BuildContext ctx, int index) {
    var agenda = controller.meetingContentsModel[index];
    return ExpansionTile(
      childrenPadding: const EdgeInsets.symmetric(vertical: 5),
      title: agendaCardWidget(
        widget: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 4),
              GestureDetector(
                child: Text('${index + 1}. ${agenda.agendaString}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                onTap: () => _editingAgendaMethod(index), // Editing Contents
                onLongPress: () async {
                  bool? deleteParameter = await _removeAgendaMethod(index);
                  if (deleteParameter!) {
                    controller.removingAgenda(index); //Remove Contents
                  }
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  smallTextStyleInsideAgenda(
                    context: agenda.agendaStatus,
                    color: selectColor(agenda.agendaStatus),
                  ),
                  smallTextStyleInsideAgenda(
                    context: agenda.issuedTime,
                    color: const Color(0xff212121),
                  ),
                  smallTextStyleInsideAgenda(
                    context: '컨텐츠',
                    color: Colors.blue,
                    onTap: () {
                      _addingContentsMethod(index);
                    },
                  ),
                  smallTextStyleInsideAgenda(
                    context: 'Todo',
                    color: const Color(0xffFF5722),
                    onTap: () {
                      _addingTodosMethod(ctx, index);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        color: const Color(0xffFFFFFF),
      ),
      initiallyExpanded: true,
      tilePadding: const EdgeInsets.all(0),
      collapsedBackgroundColor: Colors.transparent,
      children: [
        Column(children: [
          ..._contentsExpansions(index),
          const SizedBox(
            height: 5,
          ),
        ]),
        Column(
          children: [
            ..._todoExpansions(ctx, index),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ],
    );
  }

  void _addingAgendaMethod(int index) {
    _agendaController.clear();
    String agendaId = controller.meetingMinuteId + '-' + controller.agendaModelCount.toString();

    Get.bottomSheet(
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('아젠다 추가', textAlign: TextAlign.center, style: bottomSheetTitleTextStyle()),
              const SizedBox(height: 20),
              RichText(
                  text: TextSpan(children: [
                TextSpan(text: 'ID : ', style: bottomSheetSubTitleTextStyle()),
                TextSpan(text: agendaId, style: bottomSheetContentsTextStyle())
              ])),
              const SizedBox(height: 15),
              RichText(
                  text: TextSpan(children: [
                TextSpan(text: 'ISSUED TIME : ', style: bottomSheetSubTitleTextStyle()),
                TextSpan(text: currentTime(true), style: bottomSheetContentsTextStyle())
              ])),
              BottomSheetAgendaStatusWidget(number: -1),
              Text('Agenda : ', style: bottomSheetSubTitleTextStyle()),
              contentsTextField(_agendaController, '아젠다 #${index + 1} 를 입력하세요', null),
              ElevatedButton(
                child: const Text('완료'),
                style: ElevatedButton.styleFrom(
                    primary: const Color(0xffFF5722),
                    minimumSize: const Size(70, 35),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                onPressed: () {
                  if (_agendaController.text != '') {
                    controller.addingAgenda(
                        _agendaController.text, controller.tempAgendaStatus.toString(), currentTime(false));
                  }
                  _agendaController.clear();
                  Get.back();
                },
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
      isDismissible: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(35),
        side: const BorderSide(
          width: 1,
          color: Color(0xff5D4037),
        ),
      ),
      enableDrag: true,
    );
  }

  void _editingAgendaMethod(int index) {
    var agenda = controller.meetingContentsModel[index];
    _agendaController.text = agenda.agendaString;
    Get.bottomSheet(
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                '아젠다 수정',
                textAlign: TextAlign.center,
                style: bottomSheetTitleTextStyle(),
              ),
              const SizedBox(height: 20),
              RichText(
                  text: TextSpan(children: [
                TextSpan(text: 'ID : ', style: bottomSheetSubTitleTextStyle()),
                TextSpan(text: agenda.agendaID, style: bottomSheetContentsTextStyle())
              ])),
              const SizedBox(height: 15),
              RichText(
                  text: TextSpan(children: [
                TextSpan(text: 'ISSUED TIME : ', style: bottomSheetSubTitleTextStyle()),
                TextSpan(text: agenda.issuedTime, style: bottomSheetContentsTextStyle())
              ])),
              BottomSheetAgendaStatusWidget(number: index),
              Text('Agenda : ', style: bottomSheetSubTitleTextStyle()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
                child: TextField(
                  controller: _agendaController,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(fontSize: 16, color: Color(0xffD7CCC8)),
                    fillColor: const Color(0xffD7CCC8).withOpacity(0.1),
                    filled: true,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color(0xff795548).withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff5D4037), width: 2),
                    ),
                  ),
                  style: const TextStyle(color: Color(0xff5D4037)),
                  maxLines: 2,
                  maxLength: 40,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('완료'),
                style: ElevatedButton.styleFrom(
                    primary: const Color(0xffFF5722),
                    minimumSize: const Size(70, 35),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                onPressed: () {
                  if (_agendaController.text != agenda.agendaString ||
                      controller.tempAgendaStatus.toString() != agenda.agendaStatus) {
                    controller.editingAgenda(
                        index, _agendaController.text, currentTime(false), controller.tempAgendaStatus.toString());
                  }
                  _agendaController.clear();
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
      isDismissible: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(35),
        side: const BorderSide(
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
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      middleText: '"${controller.meetingContentsModel[index].agendaString}"를 삭제 합니까?',
      backgroundColor: const Color(0xff795548),
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
    var contents = controller.meetingContentsModel[number].contentsModels;
    List<Widget> contentsList = List.generate(contents.length, (index) {
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
            color: Colors.blue.withOpacity(0.1),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 6,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(color: Color(0xffFFFFFF), fontSize: 14),
                      ),
                      backgroundColor: Colors.blue,
                      radius: 10.0,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contents[index].contentsString,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              contents[index].issuedDate,
                              textAlign: TextAlign.left,
                              style: const TextStyle(fontSize: 10, fontStyle: FontStyle.italic),
                            ),
                            Text(
                              'issued by ${contents[index].issuedBy}',
                              textAlign: TextAlign.left,
                              style: const TextStyle(fontSize: 10, fontStyle: FontStyle.italic),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(
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
    return contentsList;
  }

  void _addingContentsMethod(int number) {
    _contentsController.clear();
    var agenda = controller.meetingContentsModel[number];
    String contentsId = agenda.agendaID + '-' + 'CT' + agenda.contentCount.toString();

    Get.bottomSheet(
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  '컨텐츠 추가',
                  style: bottomSheetTitleTextStyle(),
                ),
              ),
              const SizedBox(height: 20),
              RichText(
                  text: TextSpan(children: [
                TextSpan(text: 'ID : ', style: bottomSheetSubTitleTextStyle()),
                TextSpan(text: contentsId, style: bottomSheetContentsTextStyle())
              ])),
              const SizedBox(height: 15),
              RichText(
                  text: TextSpan(children: [
                TextSpan(text: 'ISSUED TIME : ', style: bottomSheetSubTitleTextStyle()),
                TextSpan(text: currentTime(true), style: bottomSheetContentsTextStyle())
              ])),
              BottomSheetContentsIssuedByWidget(
                number: -1,
                index: -1,
              ),
              Text('Agenda : ', style: bottomSheetSubTitleTextStyle()),
              contentsTextField(_contentsController, '새로운 컨텐츠를 입력하세요', null),
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                  child: const Text('완료'),
                  style: ElevatedButton.styleFrom(
                      primary: const Color(0xffFF5722),
                      minimumSize: const Size(70, 35),
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                  onPressed: () {
                    if (_contentsController.text != '') {
                      model.ContentsModel content = model.ContentsModel(
                          contentsID: contentsId,
                          contentsString: _contentsController.text,
                          issuedBy: controller.tempContentsIssuedBy.toString(),
                          issuedDate: currentTime(false));
                      controller.addingContents(number, content);
                      _contentsController.clear();
                    }
                    Get.back();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      isDismissible: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(35),
        side: const BorderSide(
          width: 1,
          color: Color(0xff5D4037),
        ),
      ),
      enableDrag: true,
    );
  }

  void _editingContentsMethod(int number, int index) {
    _contentsController.text = controller.meetingContentsModel[number].contentsModels[index].contentsString;
    var editingContent = controller.meetingContentsModel[number].contentsModels[index];

    Get.bottomSheet(
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '컨텐츠 수정',
                textAlign: TextAlign.center,
                style: bottomSheetTitleTextStyle(),
              ),
              const SizedBox(height: 20),
              RichText(
                  text: TextSpan(children: [
                TextSpan(text: 'ID : ', style: bottomSheetSubTitleTextStyle()),
                TextSpan(text: editingContent.contentsID, style: bottomSheetContentsTextStyle())
              ])),
              const SizedBox(height: 15),
              RichText(
                  text: TextSpan(children: [
                TextSpan(text: 'ISSUED TIME : ', style: bottomSheetSubTitleTextStyle()),
                TextSpan(text: editingContent.issuedDate, style: bottomSheetContentsTextStyle())
              ])),
              BottomSheetContentsIssuedByWidget(
                number: number,
                index: index,
              ),
              Text('Agenda : ', style: bottomSheetSubTitleTextStyle()),
              contentsTextField(_contentsController, '컨텐츠를 입력하세요', null),
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                  child: const Text('완료'),
                  style: ElevatedButton.styleFrom(
                      primary: const Color(0xffFF5722),
                      minimumSize: const Size(70, 35),
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                  onPressed: () {
                    if (_contentsController.text != '' ||
                        controller.tempContentsIssuedBy.toString() != editingContent.issuedBy) {
                      model.ContentsModel content = model.ContentsModel(
                        contentsID: editingContent.contentsID,
                        contentsString: _contentsController.text,
                        issuedDate: currentTime(false),
                        issuedBy: controller.tempContentsIssuedBy.toString(),
                      );
                      controller.editingContent(number, index, content);
                    }
                    _contentsController.clear();
                    Get.back();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      isDismissible: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(35),
        side: const BorderSide(
          width: 1,
          color: Color(0xff5D4037),
        ),
      ),
      enableDrag: true,
    );
  }

  Future<bool?> _removeContentsMethod(int number, int index) async {
    var contents = controller.meetingContentsModel[number].contentsModels[index];
    return await Get.defaultDialog<bool>(
      title: '컨텐츠 지움 확인',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      middleText: '"${contents.contentsString}"를 삭제 합니까?',
      backgroundColor: const Color(0xff795548),
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

  List<Widget> _todoExpansions(BuildContext ctx, int number) {
    var todos = controller.meetingContentsModel[number].todoModels;
    List<Widget> todoList = List.generate(todos.length, (index) {
      return GestureDetector(
          onTap: () {
            _editingTodosMethod(ctx, number, index);
          },
          onLongPress: () async {
            bool? deleteParameter = await _removingTodosMethod(number, index);
            if (deleteParameter!) {
              controller.removingTodos(number, index);
            }
          },
          child: Container(
            color: const Color(0xffFF5722).withOpacity(0.1),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    CircleAvatar(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(color: Color(0xffFFFFFF), fontSize: 14),
                      ),
                      backgroundColor: const Color(0xffFF5722).withOpacity(0.7),
                      radius: 10.0,
                    ),
                const SizedBox(
                  width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.meetingContentsModel[number].todoModels[index].todoString,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Responsible : ${todos[index].responsible},  Due-Date : ${todos[index].dueDate}',
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 10, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                Container(
                  height: 1,
                  color: const Color(0xffFF5722).withOpacity(0.7),
                ),


          ])));
    });
    return todoList;
  }

  void _addingTodosMethod(BuildContext ctx, int number) {
    _todoController.clear();
    controller.tempTodoDueData.value = '';
    var todos = controller.meetingContentsModel[number];
    String todoId = todos.agendaID + '-' + 'TD' + todos.todoCount.toString();

    Get.bottomSheet(
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  'Todo 추가',
                  style: bottomSheetTitleTextStyle(),
                ),
              ),
              const SizedBox(height: 20),
              RichText(
                  text: TextSpan(children: [
                TextSpan(text: 'ID : ', style: bottomSheetSubTitleTextStyle()),
                TextSpan(text: todoId, style: bottomSheetContentsTextStyle())
              ])),
              const SizedBox(height: 15),
              RichText(
                  text: TextSpan(children: [
                TextSpan(text: 'ISSUED TIME : ', style: bottomSheetSubTitleTextStyle()),
                TextSpan(text: currentTime(true), style: bottomSheetContentsTextStyle())
              ])),
              BottomSheetTodoResponsibleWidget(
                number: -1,
                index: -1,
              ),
              dueDateTimeWidget(ctx),
              BottomSheetTodoEditingWidget(
                number: -1,
                index: -1,
              ),
              Text('Todo : ', style: bottomSheetSubTitleTextStyle()),
              contentsTextField(_todoController, '신규 Todo 를 입력하세요', null),
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                  child: const Text('완료'),
                  style: ElevatedButton.styleFrom(
                      primary: const Color(0xffFF5722),
                      minimumSize: const Size(70, 35),
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                  onPressed: () {
                    if (_todoController.text != '') {
                      model.TodoModel todo = model.TodoModel(
                        todoID: todoId,
                        todoString: _todoController.text,
                        issuedTime: currentTime(false),
                        responsible: controller.tempTodoResponsible.toString(),
                        dueDate: controller.tempTodoDueData.toString(),
                        todoStatus: controller.tempTodoStatus.toString(),
                      );
                      controller.addingTodo(number, todo);
                      _todoController.clear();
                    }
                    Get.back();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      isDismissible: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(35),
        side: const BorderSide(
          width: 1,
          color: Color(0xff5D4037),
        ),
      ),
      enableDrag: true,
    );
  }

  void _editingTodosMethod(BuildContext ctx, int number, int index) {
    _todoController.text = controller.meetingContentsModel[number].todoModels[index].todoString;
    var todos = controller.meetingContentsModel[number].todoModels[index];

    Get.bottomSheet(
      SingleChildScrollView(
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Todo 수정',
                    style: bottomSheetTitleTextStyle(),
                  ),
                ),
                const SizedBox(height: 20),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(text: 'ID : ', style: bottomSheetSubTitleTextStyle()),
                  TextSpan(text: todos.todoID, style: bottomSheetContentsTextStyle())
                ])),
                const SizedBox(height: 15),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(text: 'ISSUED TIME : ', style: bottomSheetSubTitleTextStyle()),
                  TextSpan(text: todos.issuedTime, style: bottomSheetContentsTextStyle())
                ])),
                BottomSheetTodoResponsibleWidget(
                  number: number,
                  index: index,
                ),
                dueDateTimeWidget(ctx),
                BottomSheetTodoEditingWidget(
                  number: number,
                  index: index,
                ),
                Text('Todo : ', style: bottomSheetSubTitleTextStyle()),
                contentsTextField(_todoController, 'Todo 를 입력하세요', null),
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    child: const Text('완료'),
                    style: ElevatedButton.styleFrom(
                        primary: const Color(0xffFF5722),
                        minimumSize: const Size(70, 35),
                        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                    onPressed: () {
                      model.TodoModel todo = model.TodoModel(
                          todoID: todos.todoID,
                          issuedTime: currentTime(false),
                          responsible: controller.tempTodoResponsible.toString(),
                          dueDate: controller.tempTodoDueData.toString(),
                          todoStatus: controller.tempTodoStatus.toString(),
                          todoString: _todoController.text);
                      controller.editingTodos(number, index, todo);
                      _todoController.clear();
                      Get.back();
                    },
                  ),
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
        side: const BorderSide(
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
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      middleText: '"${controller.meetingContentsModel[number].todoModels[index].todoString}"를 삭제 합니까?',
      backgroundColor: const Color(0xff795548),
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

  Widget dueDateTimeWidget(BuildContext ctx) {
    return Row(children: [
      Obx(
        () => RichText(
          text: TextSpan(children: [
            TextSpan(text: 'Due Date : ', style: bottomSheetSubTitleTextStyle()),
            TextSpan(text: controller.tempTodoDueData.toString(), style: bottomSheetContentsTextStyle())
          ]),
        ),
      ),
      GestureDetector(
        onTap: () async {
          controller.tempTodoDueData.value = await yearMonthDayTimePicker(ctx);
        },
        child: const Icon(
          Icons.date_range,
          color: Color(0xff5D4037),
          size: 30,
        ),
      ),
    ]);
  }
}
