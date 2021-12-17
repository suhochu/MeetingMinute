import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetingminutes52/components/buttons.dart';
import 'package:meetingminutes52/components/custom_card.dart';
import 'package:meetingminutes52/components/textfield_style.dart';
import 'package:meetingminutes52/components/time_component.dart';
import 'package:meetingminutes52/models/meeting_minute_controller.dart';
import 'package:meetingminutes52/models/models.dart' as model;
import 'package:meetingminutes52/theme/color_style.dart';
import 'package:meetingminutes52/theme/text_style.dart';

class MeetingContentsPage extends GetView<MeetingMinuteController> {

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

  List<Widget> _agendaListBuilder(BuildContext ctx) {
    List<Widget> cardList = [];
    cardList = List.generate(
      controller.meetingAgendasModel.length + 1,
      (index) {
        if (index == controller.meetingAgendasModel.length) {
          return GestureDetector(
            child: addingButtonWidget('아젠다 추가'),
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
    var agenda = controller.meetingAgendasModel[index];
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
                    onTap: () => _addingTodosMethod(ctx, index),
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
    controller.agendaController.clear();
    // String agendaId = controller.meetingMinute.meetingMinuteId + '-' + (controller.meetingAgendasModel.length + 1).toString();
    String agendaId = controller.meetingMinuteId + '-' + (controller.meetingAgendasModel.length + 1).toString();

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
                TextSpan(text: currentTime(false), style: bottomSheetContentsTextStyle())
              ])),
              BottomSheetAgendaStatusWidget(number: -1),
              Text('Agenda : ', style: bottomSheetSubTitleTextStyle()),
              bottomSheetTextField(controller.agendaController, '아젠다 #${index + 1} 를 입력하세요', null, 1, 40),
              completeButton(
                () {
                  if (controller.agendaController.text != '') {
                    controller.addingAgenda(
                        controller.agendaController.text, controller.tempAgendaStatus.toString(), currentTime(false));
                  }
                  controller.agendaController.clear();
                  Get.back();
                },
              ),
              const SizedBox(height: 20),
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
    var agenda = controller.meetingAgendasModel[index];
    controller.agendaController.text = agenda.agendaString;
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
                  controller: controller.agendaController,
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
                  maxLines: 1,
                  maxLength: 40,
                ),
              ),
              const SizedBox(height: 20),
              completeButton(
                () {
                  if (controller.agendaController.text != agenda.agendaString ||
                      controller.tempAgendaStatus.toString() != agenda.agendaStatus) {
                    controller.editingAgenda(
                        index, controller.agendaController.text, currentTime(false), controller.tempAgendaStatus.toString());
                  }
                  controller.agendaController.clear();
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
      middleText: '"${controller.meetingAgendasModel[index].agendaString}"를 삭제 합니까?',
      backgroundColor: const Color(0xff795548),
      textCancel: '아니오',
      textConfirm: '예',
      barrierDismissible: false,
      radius: 50,
      onCancel: () => Get.back(result: false),
      onConfirm: () => Get.back(result: true),
    );
  }

  List<Widget> _contentsExpansions(int number) {
    var contents = controller.meetingAgendasModel[number].contentsModels;
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
                        RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: 'Issued by ${contents[index].issuedBy}',
                                  style: const TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: Colors.black)),
                              const TextSpan(text: ' At '),
                              TextSpan(
                                  text: contents[index].issuedDate,
                                  style: const TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: Colors.black)),

                            ])),
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
    controller.contentsController.clear();
    var agenda = controller.meetingAgendasModel[number];
    String contentsId = agenda.agendaID + '-' + 'CT' + (agenda.contentsModels.length + 1).toString();

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
                TextSpan(text: currentTime(false), style: bottomSheetContentsTextStyle())
              ])),
              BottomSheetContentsIssuedByWidget(
                number: -1,
                index: -1,
              ),
              Text('Content : ', style: bottomSheetSubTitleTextStyle()),
              bottomSheetTextField(controller.contentsController, '새로운 컨텐츠를 입력하세요', null, 2, 100),
              const SizedBox(height: 20),
              completeButton(
                () {
                  if (controller.contentsController.text != '') {
                    model.ContentsModel content = model.ContentsModel(
                        contentsID: contentsId,
                        contentsString: controller.contentsController.text,
                        issuedBy: controller.tempContentsIssuedBy.toString(),
                        issuedDate: currentTime(false));
                    controller.addingContents(number, content);
                    controller.contentsController.clear();
                  }
                  Get.back();
                },
              ),
              const SizedBox(height: 20),
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
    controller.contentsController.text = controller.meetingAgendasModel[number].contentsModels[index].contentsString;
    var editingContent = controller.meetingAgendasModel[number].contentsModels[index];

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
                  '컨텐츠 수정',
                  textAlign: TextAlign.center,
                  style: bottomSheetTitleTextStyle(),
                ),
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
              Text('Content : ', style: bottomSheetSubTitleTextStyle()),
              bottomSheetTextField(controller.contentsController, '컨텐츠를 입력하세요', null, 2, 100),
              const SizedBox(
                height: 20,
              ),
              completeButton(
                () {
                  if (controller.contentsController.text != '' ||
                      controller.tempContentsIssuedBy.toString() != editingContent.issuedBy) {
                    model.ContentsModel content = model.ContentsModel(
                      contentsID: editingContent.contentsID,
                      contentsString: controller.contentsController.text,
                      issuedDate: currentTime(false),
                      issuedBy: controller.tempContentsIssuedBy.toString(),
                    );
                    controller.editingContent(number, index, content);
                  }
                  controller.contentsController.clear();
                  Get.back();
                },
              ),
              const SizedBox(height: 20),
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
    return await Get.defaultDialog<bool>(
      title: '컨텐츠 지움 확인',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      middleText: '"${controller.meetingAgendasModel[number].contentsModels[index].contentsString}"를 삭제 합니까?',
      backgroundColor: const Color(0xff795548),
      textCancel: '아니오',
      textConfirm: '예',
      barrierDismissible: false,
      radius: 50,
      onCancel: () => Get.back(result: false),
      onConfirm: () => Get.back(result: true),
    );
  }

  List<Widget> _todoExpansions(BuildContext ctx, int number) {
    var todos = controller.meetingAgendasModel[number].todoModels;
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
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
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
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.meetingAgendasModel[number].todoModels[index].todoString,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 16),
                        ),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: 'Resp. : ${todos[index].responsible}',
                              style: const TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: Colors.black)),
                          const TextSpan(text: ' / '),
                          TextSpan(
                              text: 'DueDate : ${todos[index].dueDate}',
                              style: const TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: Colors.black)),
                          const TextSpan(text: ' / '),
                          TextSpan(
                              text: todos[index].todoStatus.toString(),
                              style: TextStyle(
                                  fontSize: 10,
                                  fontStyle: FontStyle.italic,
                                  color: selectColor(todos[index].todoStatus.toString()))),
                        ])),
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
    controller.todoController.clear();
    controller.tempTodoDueData.value = '';
    var todos = controller.meetingAgendasModel[number];
    String todoId = todos.agendaID + '-' + 'TD' + (todos.todoModels.length + 1).toString();

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
                TextSpan(text: currentTime(false), style: bottomSheetContentsTextStyle())
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
              bottomSheetTextField(controller.todoController, '신규 Todo 를 입력하세요', null, 2, 100),
              const SizedBox(height: 20),
              completeButton(
                () {
                  // dueDateStringToInt(controller.tempTodoDueData.toString());
                  if (controller.todoController.text != '') {
                    model.TodoModel todo = model.TodoModel(
                      todoID: todoId,
                      todoString: controller.todoController.text,
                      issuedTime: currentTime(false),
                      responsible: controller.tempTodoResponsible.toString(),
                      dueDate: controller.tempTodoDueData.toString(),
                      todoStatus: controller.tempTodoStatus.toString(),
                      intDueDate: dueDateStringToInt(controller.tempTodoDueData.toString()),
                    );
                    controller.addingTodo(number, todo);
                    controller.todoController.clear();
                  }
                  Get.back();
                },
              ),
              const SizedBox(height: 20),
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
    controller.todoController.text = controller.meetingAgendasModel[number].todoModels[index].todoString;
    var todos = controller.meetingAgendasModel[number].todoModels[index];
    controller.tempTodoDueData.value = '';
    if (todos.dueDate != '') {
      controller.tempTodoDueData.value = todos.dueDate;
    }

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
                bottomSheetTextField(controller.todoController, 'Todo 를 입력하세요', null, 2, 100),
                const SizedBox(height: 20),
                completeButton(() {
                  //수정에 대한 조건문 작성 필요
                  model.TodoModel todo = model.TodoModel(
                    todoID: todos.todoID,
                    issuedTime: currentTime(false),
                    responsible: controller.tempTodoResponsible.toString(),
                    dueDate: controller.tempTodoDueData.toString(),
                    todoStatus: controller.tempTodoStatus.toString(),
                    todoString: controller.todoController.text,
                    intDueDate: dueDateStringToInt(controller.tempTodoDueData.toString()),
                  );
                  controller.editingTodos(number, index, todo);
                  controller.todoController.clear();
                  Get.back();
                }),
                const SizedBox(height: 20),
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
          )),
      enableDrag: true,
    );
  }

  Future<bool?> _removingTodosMethod(int number, int index) async {
    return await Get.defaultDialog<bool>(
      title: 'Todo 지움 확인',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      middleText: '"${controller.meetingAgendasModel[number].todoModels[index].todoString}"를 삭제 합니까?',
      backgroundColor: const Color(0xff795548),
      textCancel: '아니오',
      textConfirm: '예',
      barrierDismissible: false,
      radius: 50,
      onCancel: () => Get.back(result: false),
      onConfirm: () => Get.back(result: true),
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
