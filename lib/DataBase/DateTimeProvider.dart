


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeControl extends ChangeNotifier{
  DateTime pickedDate= DateTime.now();
  TimeOfDay pickedTime=TimeOfDay.now();
  DateTime todotime = new DateTime.now();

  Future<String> pickDate(BuildContext context) async {
    DateTime date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().add(Duration(days: -365)),
        lastDate: DateTime.now().add(Duration(days: 365)));
    if (date != null) {
        pickedDate = date;
    }
    dateTime();
    notifyListeners();
  }

  Future pickTime(BuildContext context) async {
    TimeOfDay timepick = await showTimePicker(
        context: context, initialTime: new TimeOfDay.now());
    if (timepick != null) {
        pickedTime = timepick;
    }
    dateTime();
    notifyListeners();
  }
  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.Hm();
    return format.format(dt);
  }
  void dateTime() {
    todotime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day,
        pickedTime.hour, pickedTime.minute);
  }
}