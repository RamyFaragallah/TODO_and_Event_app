import 'package:flutter/material.dart';
import 'package:flutter_app/Alerts/CustomTodoAlert.dart';
import 'package:flutter_app/DataBase/database.dart';
import 'package:flutter_app/Models/todo.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  Database provider;

  Widget build(BuildContext context) {
    provider = Provider.of<Database>(context);

    return StreamProvider.value(
        value: provider.gettodo(
            provider.filter,
            TodoType.TYPE_EVENT.index,
            DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            )),
        child: Consumer<List<TodoData>>(builder: (context, snapshot, child) {
          if (snapshot != null) {
            return ListView.builder(
                itemCount: snapshot.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onLongPress: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadiusDirectional.circular(12)),
                              child: CustomTodoAlert(
                                snapshot[index],
                                "WARNNING",
                                "Cancel",
                                "Delete",
                                () {
                                  Navigator.of(context).pop();
                                },
                                () {
                                  provider
                                      .deleteTodoEntries(snapshot[index].id)
                                      .whenComplete(() {
                                    Navigator.of(context).pop();
                                  }).catchError((error) {
                                    print(error.toString());
                                  });
                                },
                              ),
                            );
                          });
                    },
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadiusDirectional.circular(12)),
                                child: CustomTodoAlert(
                                  snapshot[index],
                                  "Confirm",
                                  "Cancel",
                                  snapshot[index].isFinish ? "Undo" : "Done",
                                  () {
                                    Navigator.of(context).pop();
                                  },
                                  () {
                                    snapshot[index].isFinish
                                        ? provider
                                            .updatetodo(
                                                snapshot[index].id, false)
                                            .whenComplete(() {
                                            Navigator.of(context).pop();
                                          }).catchError((error) {
                                            print(error.toString());
                                          })
                                        : provider
                                            .updatetodo(
                                                snapshot[index].id, true)
                                            .whenComplete(() {
                                            Navigator.of(context).pop();
                                          }).catchError((error) {
                                            print(error.toString());
                                          });
                                  },
                                ));
                          });
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 50, 8.0),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              snapshot[index].isFinish
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Text(
                              "${new DateFormat.Hm().format(snapshot[index].date)}",
                              style: TextStyle(
                                  color: snapshot[index].isFinish
                                      ? Colors.black54
                                      : Colors.black,
                                  fontStyle: snapshot[index].isFinish
                                      ? FontStyle.italic
                                      : FontStyle.normal),
                            ),
                          ),
                          Expanded(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              elevation: 7,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          "${snapshot[index].task}",
                                          style: TextStyle(
                                              color: snapshot[index].isFinish
                                                  ? Colors.black54
                                                  : Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontStyle:
                                                  snapshot[index].isFinish
                                                      ? FontStyle.italic
                                                      : FontStyle.normal,
                                              fontSize: 18),
                                        )),
                                    Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text("${snapshot[index].description}",style: TextStyle(
                                          fontStyle:
                                          snapshot[index].isFinish
                                              ? FontStyle.italic
                                              : FontStyle.normal,
                                        ),)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }));
  }
}
