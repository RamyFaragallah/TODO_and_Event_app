import 'package:flutter/material.dart';
import 'package:flutter_app/CustomWidgets/CustomButton.dart';
import 'package:flutter_app/CustomWidgets/CustomDateTimePicker.dart';
import 'package:flutter_app/DataBase/DateTimeProvider.dart';
import 'package:flutter_app/DataBase/database.dart';
import 'package:flutter_app/Models/todo.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddTaskAlert extends StatefulWidget {
  @override
  _AddTaskAlertState createState() => _AddTaskAlertState();
}

class _AddTaskAlertState extends State<AddTaskAlert> {


  final TextEditingController _txtcontroller = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    var Dateprovider = Provider.of<DateTimeControl>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "Add Task",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: _txtcontroller,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          hintText: "Task "),
                    ),
                  ),
                  CustomDateTimePicker(
                          (){Dateprovider.pickDate(context);},
                      "${new DateFormat.yMMMd().format(Dateprovider.pickedDate)}",
                          (){Dateprovider.pickTime(context);},
                      Dateprovider.  formatTimeOfDay(Dateprovider.pickedTime)),
                  Padding(
                    padding: EdgeInsets.fromLTRB(25, 10, 15, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        CustomButton(
                          txt: "Cancel",
                          txtColor: Theme.of(context).accentColor,
                          color: Colors.white,
                          borderColor: Theme.of(context).accentColor,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        Consumer<Database>(
                          builder: (context, databse, widget) {
                            return CustomButton(
                              txt: "Add",
                              txtColor: Colors.white,
                              color: Theme.of(context).accentColor,
                              onPressed: () {
                                if (_txtcontroller.text.length > 0) {
                                  databse
                                      .insertTodoEntries(new TodoData(
                                          id: null,
                                          date: Dateprovider.todotime,
                                          time: DateTime(
                                            Dateprovider.todotime.year,
                                            Dateprovider.todotime.month,
                                            Dateprovider.todotime.day,
                                          ),
                                          task: _txtcontroller.text,
                                          description: "",
                                          isFinish: false,
                                          todoType: TodoType.TYPE_TASK.index))
                                      .whenComplete(() {
                                    Navigator.of(context).pop();
                                  }).catchError((error) {
                                    print(error.toString);
                                  });
                                }
                              },
                              borderColor: Colors.white,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
