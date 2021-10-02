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
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w400)),
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
                      _addingTodosMethod(index);
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
            ..._todoExpansions(index),
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
    String agendaId = controller.meetingMinuteId +
        '-' +
        controller.agendaModelCount.toString();

    Get.bottomSheet(
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('아젠다 추가',
                  textAlign: TextAlign.center,
                  style: bottomSheetTitleTextStyle()),
              const SizedBox(height: 20),
              RichText(
                  text: TextSpan(children: [
                TextSpan(text: 'ID : ', style: bottomSheetSubTitleTextStyle()),
                TextSpan(text: agendaId, style: bottomSheetContentsTextStyle())
              ])),
              const SizedBox(height: 15),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: 'ISSUED TIME : ',
                    style: bottomSheetSubTitleTextStyle()),
                TextSpan(
                    text: currentTime(true),
                    style: bottomSheetContentsTextStyle())
              ])),
              BottomSheetStatusWidget(index: -1),
              Text('Agenda : ', style: bottomSheetSubTitleTextStyle()),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 15.0),
                child: TextField(
                  controller: _agendaController,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.center,
                  decoration: textFormFieldInputStyle(
                      '아젠다 #${index + 1} 를 입력하세요', null),
                  style: const TextStyle(color: Color(0xff5D4037)),
                  maxLines: 2,
                  maxLength: 40,
                ),
              ),
              ElevatedButton(
                child: const Text('완료'),
                style: ElevatedButton.styleFrom(
                    primary: const Color(0xffFF5722),
                    minimumSize: const Size(70, 35),
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w400)),
                onPressed: () {
                  if (_agendaController.text != '') {
                    controller.addingAgenda(
                        _agendaController.text,
                        controller.newAgendaStatus.toString(),
                        currentTime(false));
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
                TextSpan(
                    text: agenda.agendaID,
                    style: bottomSheetContentsTextStyle())
              ])),
              const SizedBox(height: 15),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: 'ISSUED TIME : ',
                    style: bottomSheetSubTitleTextStyle()),
                TextSpan(
                    text: agenda.issuedTime,
                    style: bottomSheetContentsTextStyle())
              ])),
              BottomSheetStatusWidget(
                index: index,
              ),
              Text('Agenda : ', style: bottomSheetSubTitleTextStyle()),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 15.0),
                child: TextField(
                  controller: _agendaController,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintStyle:
                        const TextStyle(fontSize: 16, color: Color(0xffD7CCC8)),
                    fillColor: const Color(0xffD7CCC8).withOpacity(0.1),
                    filled: true,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color(0xff795548).withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xff5D4037), width: 2),
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
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w400)),
                onPressed: () {
                  if (_agendaController.text != agenda.agendaString ||
                      controller.newAgendaStatus.toString() !=
                          agenda.agendaStatus) {
                    controller.editingAgenda(
                        index,
                        _agendaController.text,
                        currentTime(false),
                        controller.newAgendaStatus.toString());
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
      middleText:
          '"${controller.meetingContentsModel[index].agendaString}"를 삭제 합니까?',
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
                const SizedBox(
                  height: 6,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                            color: Color(0xffFFFFFF), fontSize: 14),
                      ),
                      backgroundColor: Colors.green,
                      radius: 10.0,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      controller.meetingContentsModel[number]
                          .contentsModels[index].contentsString,
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(
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
    var agenda = controller.meetingContentsModel[number];
    String contentsId = agenda.agendaID + '-' + 'CT' + agenda.contentCount.toString();

    Get.bottomSheet(
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                '컨텐츠 추가',
                textAlign: TextAlign.center,
                style: bottomSheetTitleTextStyle(),
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
                    TextSpan(
                        text: 'ISSUED TIME : ',
                        style: bottomSheetSubTitleTextStyle()),
                    TextSpan(
                        text: currentTime(true),
                        style: bottomSheetContentsTextStyle())
                  ])),
              const SizedBox(height: 15),
              BottomSheetIssuedByWidget(number: -1, index: -1,),
              const SizedBox(height: 15),
              Text('Agenda : ', style: bottomSheetSubTitleTextStyle()),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 15.0),
                child: TextField(
                  controller: _contentsController,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.center,
                  decoration: textFormFieldInputStyle('새로운 컨텐츠를 입력하세요', null),
                  style: const TextStyle(color: Color(0xff5D4037)),
                  maxLines: 2,
                  maxLength: 100,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                child: const Text('완료'),
                style: ElevatedButton.styleFrom(
                    primary: const Color(0xffFF5722),
                    minimumSize: const Size(70, 35),
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w400)),
                onPressed: () {
                  model.ContentsModel content = model.ContentsModel(
                      contentsID: contentsId,
                          // controller.meetingContentsModel[number].agendaID +
                          //     controller.meetingContentsModel[number]
                          //         .contentsCountReturn(),
                      contentsString: _contentsController.text,
                      issuedBy: controller.tempSelectedValues.toString(),
                      issuedDate: currentTime(false));
                  controller.addingContents(number, content);
                  _contentsController.clear();
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

  void _editingContentsMethod(int number, int index) {
    _contentsController.text = controller
        .meetingContentsModel[number].contentsModels[index].contentsString;
    print(controller.meetingContentsModel[number].contentsModels[index].contentsID);
    print(controller.meetingContentsModel[number].contentsModels[index].issuedBy);
    print(controller.meetingContentsModel[number].contentsModels[index].issuedDate);
    Get.bottomSheet(
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                '컨텐츠 수정',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _contentsController,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintStyle:
                      const TextStyle(fontSize: 16, color: Color(0xffD7CCC8)),
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
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                child: const Text('완료'),
                style: ElevatedButton.styleFrom(
                    primary: const Color(0xffFF5722),
                    minimumSize: const Size(70, 35),
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w400)),
                onPressed: () {
                  // model.ContentsModel content = model.ContentsModel(
                  //     contentsID: controller.meetingContentsModel[number]
                  //         .contentsModels[index].contentsString,
                  //     contentsString: _contentsController.text);
                  // controller.editingContent(number, index, content);
                  _contentsController.clear();
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

  Future<bool?> _removeContentsMethod(int number, int index) async {
    return await Get.defaultDialog<bool>(
      title: '컨텐츠 지움 확인',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      middleText:
          '"${controller.meetingContentsModel[number].contentsModels[index]}"를 삭제 합니까?',
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
                const SizedBox(
                  height: 6,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                            color: Color(0xffFFFFFF), fontSize: 14),
                      ),
                      backgroundColor: Colors.blue,
                      radius: 10.0,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      controller.meetingContentsModel[number].todoModels[index]
                          .todoString,
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 16),
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
    return todoList;
  }

  void _addingTodosMethod(int number) {
    _todoController.clear();
    Get.bottomSheet(
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Todo 추가',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _todoController,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.center,
                decoration: textFormFieldInputStyle('신규 Todo 를 입력하세요', null),
                style: const TextStyle(color: Color(0xff5D4037)),
                maxLines: 2,
                maxLength: 40,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                child: const Text('완료'),
                style: ElevatedButton.styleFrom(
                    primary: const Color(0xffFF5722),
                    minimumSize: const Size(70, 35),
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w400)),
                onPressed: () {
                  model.TodoModel todo = model.TodoModel(
                      todoID: controller.meetingContentsModel[number].agendaID +
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

  void _editingTodosMethod(int number, int index) {
    _todoController.text =
        controller.meetingContentsModel[number].todoModels[index].todoString;
    Get.bottomSheet(
      SingleChildScrollView(
        child: SizedBox(
          height: Get.size.height * 0.3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Todo 수정',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _todoController,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintStyle:
                        const TextStyle(fontSize: 16, color: Color(0xffD7CCC8)),
                    fillColor: const Color(0xffD7CCC8).withOpacity(0.1),
                    filled: true,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color(0xff795548).withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xff5D4037), width: 2),
                    ),
                  ),
                  style: const TextStyle(color: Color(0xff5D4037)),
                  maxLines: 2,
                  maxLength: 40,
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('완료'),
                  style: ElevatedButton.styleFrom(
                      primary: const Color(0xffFF5722),
                      minimumSize: const Size(70, 35),
                      textStyle: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w400)),
                  onPressed: () {
                    model.TodoModel todo = model.TodoModel(
                        todoID: controller.meetingContentsModel[number]
                            .todoModels[index].todoID,
                        todoString: _todoController.text);
                    controller.editingTodos(number, index, todo);
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
      middleText:
          '"${controller.meetingContentsModel[number].todoModels[index]}"를 삭제 합니까?',
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
}
