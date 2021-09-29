List<String> peoples = ['추수호', '이기동', '전준영', '주환엽', '조성환'];
List<String> meetings = ['아키텍처 디자인 리뷰', '프로젝트 회의', '브레인스토밍', '평가 결과 검토'];
List<String> meetingPlace = [
  '모비스온 화상회의',
  '팀즈 화상회의',
  '의장동 401회의실',
  '의장동 402회의실'
];
List<String> agendaList = [
  'SW 변경 검토',
  'HW 설계 검토',
  'FMEA 계획 검토',
  '사이버 시큐리티 적용 검토',
];

enum Status { ISSUED, PROCESSING, DELAYED, DONE, DEPRECATED }

class AgendaModel {
  AgendaModel(
      {required this.agendaID,
      required this.agendaString,
      required this.contentsModels,
      required this.todoModels});

  String agendaID = '';
  String issuedDate = '${DateTime.now().toString().split(' ')[0]}';
  String agendaString;
  int contentCount = 0;
  int todoCount = 0;
  List<ContentsModel> contentsModels;
  List<TodoModel> todoModels;
  Status agendaStatus = Status.ISSUED;

  String contentsCountReturn() {
    contentCount++;
    return contentCount.toString();
  }

  String todoCountReturn() {
    todoCount++;
    return todoCount.toString();
  }
}

class ContentsModel {
  ContentsModel({
    required this.contentsID,
    required this.contentsString,
  });

  String contentsID = '';
  String contentsString = '';
  String? issuedBy;
  String? issuedDate;
}

class TodoModel {
  TodoModel({required this.todoID, required this.todoString});

  String todoID = '';
  String todoString = '';
  String? dueDate = '';
  String? responsible = '';
  Status todoStatus = Status.ISSUED;
}
