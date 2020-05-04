import 'package:flutter/material.dart';
import 'package:flutter_app/Alerts/CustomTodoAlert.dart';
import 'package:flutter_app/DataBase/database.dart';
import 'package:flutter_app/Models/todo.dart';
import 'package:provider/provider.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  Database provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<Database>(context);

    return StreamProvider.value(
        value: provider.gettodo(
            provider.filter,
            TodoType.TYPE_TASK.index,
            DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            )),
        child: Consumer<List<TodoData>>(builder: (context, snapshot, child) {
          if (snapshot != null) {
            return ListView.builder(
              itemBuilder: (context, index) {
                return _task(snapshot[index]);
              },
              itemCount: snapshot.length,
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }));
  }

  Widget _task(TodoData task) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.circular(12)),
                  child: CustomTodoAlert(
                    task,
                    "Confirm",
                    "Cancel",
                    task.isFinish ? "Undo" : "Done",
                    () {
                      Navigator.of(context).pop();
                    },
                    () {
                      task.isFinish
                          ? provider
                              .updatetodo(task.id, false)
                              .whenComplete(() {
                              Navigator.of(context).pop();
                            }).catchError((error) {
                              print(error.toString());
                            })
                          : provider.updatetodo(task.id, true).whenComplete(() {
                              Navigator.of(context).pop();
                            }).catchError((error) {
                              print(error.toString());
                            });
                    },
                  ));
            });
      },
      onLongPress: () {
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.circular(12)),
                child: CustomTodoAlert(
                  task,
                  "WARNNING",
                  "Cancel",
                  "Delete",
                  () {
                    Navigator.of(context).pop();
                  },
                  () {
                    provider.deleteTodoEntries(task.id).whenComplete(() {
                      Navigator.of(context).pop();
                    }).catchError((error) {
                      print(error.toString());
                    });
                  },
                ),
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20, bottom: 12, top: 12),
        child: Row(
          children: <Widget>[
            task.isFinish
                ? Icon(
                    Icons.radio_button_checked,
                    color: Theme.of(context).accentColor,
                    size: 20,
                  )
                : Icon(
                    Icons.radio_button_unchecked,
                    color: Theme.of(context).accentColor,
                    size: 20,
                  ),
            SizedBox(
              width: 20,
            ),
            Text(
              task.task,
              style: TextStyle(
                  color: task.isFinish ? Colors.black54 : Colors.black,
                  fontStyle:
                      task.isFinish ? FontStyle.italic : FontStyle.normal),
            )
          ],
        ),
      ),
    );
  }
}
