import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetingminutes52/models/meeting_minute_controller.dart';

class MeetingOpen extends GetView<MeetingMinuteController> {
  const MeetingOpen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final meetingMinutes = controller.openMeetingMinute();
    int contentsLength = meetingMinutes.length;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color(0xff5D4037)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Meeting Minute Open',
          style: TextStyle(
              fontSize: 20,
              color: Color(0xff5D4037),
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      body: contentsLength == 0
          ? const Center(
              child: Text('표시할 내용이 없습니다.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: contentsLength,
              itemBuilder: (BuildContext context, int index) {
                print('id is : ${meetingMinutes[index].id}');
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller
                            .selectedMeetingMinute(meetingMinutes[index].id);
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  meetingMinuteOpenBox('ID : ',
                                      meetingMinutes[index].meetingMinuteId),
                                  meetingMinuteOpenBox('회의제목 : ',
                                      meetingMinutes[index].meetingTitle),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  meetingMinuteOpenBox('PROJECT : ',
                                      meetingMinutes[index].projectName),
                                  meetingMinuteOpenBox('회의시간 : ',
                                      meetingMinutes[index].meetingTime),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  meetingMinuteOpenBox('회의종류 : ',
                                      meetingMinutes[index].meetings),
                                  meetingMinuteOpenBox('회의주관 : ',
                                      meetingMinutes[index].meetingModerator),
                                ],
                              ),
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                          // color: const Color(0xffD7CCC8),
                          border: Border.all(
                            width: 1.0,
                            color: const Color(0xff5D4037),
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                    Container(
                      height: 5,
                    )
                  ],
                );
              },
            ),
    );
  }

  Text meetingMinuteOpenBox(String txt_1, String txt_2) => Text.rich(
        TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: txt_1,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Color(0xff757575),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextSpan(
              text: '$txt_2 ,',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xff5D4037),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
}
