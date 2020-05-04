import 'package:flutter/material.dart';
import 'package:flutter_app/Models/todo.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'database.g.dart';

@UseMoor(tables: [
  Todo
], queries: {
  '_getByType':
  'SELECT * FROM todo WHERE todo_type = ? order by is_finish, date, time',
  '_completeTask': 'UPDATE todo SET is_finish = 1 WHERE id = ?',
  '_update': 'UPDATE todo SET is_finish = ? WHERE id = ?',
  '_deleteTask': 'DELETE FROM todo WHERE id = ?',
  '_getByDay':'SELECT * FROM todo WHERE time=? AND todo_type = ? '
})
class Database  extends _$Database with ChangeNotifier {

  Database()
      : super(FlutterQueryExecutor.inDatabaseFolder(path: 'todos_file.sqlite'));

  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => 1;
  var filter="All";
  setfilter(String Filter){
    filter=Filter;
    notifyListeners();
  }
  Stream<List<TodoData>> gettodo(String filterby,int type,DateTime time){
    switch (filterby){
      case "All":
        return watchGetByType(type);
        break;
      case "Today":
        return watchGetByDay(time, type);
        break;
      default :
        return watchGetByType(type);


    }
  }

  Future insertTodoEntries(TodoData entry) {
    return transaction((tx) async {
      await tx.into(todo).insert(entry);
    });
  }
  Future updatetodo(int id,bool done) {
    return transaction((tx) async {
      await _update(done,id);
    });
  }
  Future deleteTodoEntries(int id) {
    return transaction((tx) async {
      await _deleteTask(id);
    });
  }

}
