import 'package:flutter/material.dart';

Future<String> yearMonthDayTimePicker(BuildContext context) async {
  final year = DateTime.now().year;
  String hour, min;

  final DateTime? dateTime = await showDatePicker(
      context: context,
      locale: const Locale('ko', 'KR'),
      selectableDayPredicate: (DateTime day) {
        return day.isAfter(DateTime.now()) || DateTime.now().day == day.day;
      },
      initialDate: DateTime.now(),
      firstDate: DateTime(year),
      lastDate: DateTime(year + 10),
      helpText: '회의 날짜를 입력하세요',
      confirmText: '예약',
      fieldLabelText: '회의 날짜',
      fieldHintText: '연. 월. 일.',
      errorFormatText: '연. 월. 일. 형태로 입력하세요',
      errorInvalidText: '범위 내의 날짜를 입력하세요',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xffFF5722),
              onPrimary: Color(0xffD7CCC8),
              surface: Color(0xFF182233),
              onSurface: Color(0xffFFFFFF),
            ),
            dialogBackgroundColor: const Color(0xFF182233),
          ),
          child: child!,
        );
      });
  if (dateTime != null) {
    final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        helpText: '회의 시간를 입력하세요',
        confirmText: '예약',
        cancelText: '취소',
        initialTime: const TimeOfDay(hour: 12, minute: 0),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.dark(
                primary: Color(0xffFF5722),
                onPrimary: Color(0xffD7CCC8),
                surface: Color(0xFF182233),
                onSurface: Color(0xffFFFFFF),
              ),
              dialogBackgroundColor: const Color(0xFF182233),
              timePickerTheme: const TimePickerThemeData(
                hourMinuteColor: Color(0xFF182233),
                helpTextStyle: TextStyle(color: Color(0xffFFFFFF), fontSize: 11),
                dayPeriodColor: Color(0xFF182233),
              ),
            ),
            child: child!,
          );
        });

    if (pickedTime != null) {
      if (pickedTime.hour < 10) {
        hour = '0' + pickedTime.hour.toString();
      } else {
        hour = pickedTime.hour.toString();
      }

      if (pickedTime.minute < 10) {
        min = '0' + pickedTime.minute.toString();
      } else {
        min = pickedTime.minute.toString();
      }

      return dateTime.toString().split(' ')[0].split('-')[0] + '-' +
          dateTime.toString().split(' ')[0].split('-')[1] + '-' +
          dateTime.toString().split(' ')[0].split('-')[2] + '  ' +
          hour + ':' + min;
    }
  }
  return '';
}

String currentTime(bool selection) {
  if (selection) {
    return '${DateTime.now().toString().split(' ')[0].split('-')[0]}년 '
        '${DateTime.now().toString().split(' ')[0].split('-')[1]}월 '
        '${DateTime.now().toString().split(' ')[0].split('-')[2]}일 '
        '${DateTime.now().toString().split(' ')[1].split(':')[0]}시 ${DateTime.now().toString().split(' ')[1].split(':')[1]}분';
  } else {
    return DateTime.now().toString().split(' ')[0].split('-')[0] +
        '-' +
        DateTime.now().toString().split(' ')[0].split('-')[1] +
        '-' +
        DateTime.now().toString().split(' ')[0].split('-')[2] +
        '  ' +
        DateTime.now().toString().split(' ')[1].split(':')[0] +
        ':' +
        DateTime.now().toString().split(' ')[1].split(':')[1];
  }
}

int dueDateStringToInt(String value) {
  if(value == '') return 0;
  String date = value.split('  ')[0].split('-')[0] +
      value.split('  ')[0].split('-')[1] +
      value.split('  ')[0].split('-')[2] +
      value.split('  ')[1].split(':')[0] +
      value.split('  ')[1].split(':')[1];
  return int.parse(date);
}
