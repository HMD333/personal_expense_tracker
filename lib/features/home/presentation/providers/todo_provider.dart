import '../../../../core/database/sqflite_database.dart';
import '../../../../core/models/todo_model.dart';
import '../../../../core/tables/todo_table.dart';

class TodoProvider {
  final _db = SqfliteDatabase.db;

  Future<TodoModel> addTodo(TodoModel todo) async {
    todo.id = await _db.insert(TodoTable.todo, todo.toMap());
    return todo;
  }

  Future<TodoModel?> getTodo(int id) async {
    List<Map> maps = await _db.query(
      TodoTable.todo,
      where: '${TodoTable.id} = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isNotEmpty) return TodoModel.fromMap(maps.first);
    return null;
  }

  Future<int> updateTodo(TodoModel todo) async {
    return await _db.update(
      TodoTable.todo,
      todo.toMap(),
      where: '${TodoTable.id} = ?',
      whereArgs: [todo.id],
    );
  }

  Future<int> changeStatus(int id, bool isDone) async {
    print(
        "Changing status for Todo with ID: $id to ${isDone ? 'Done' : 'Undone'}");
    return await _db.update(
      TodoTable.todo,
      {TodoTable.done: isDone ? 1 : 0},
      where: '${TodoTable.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTodo(int id) async {
    return await _db.delete(
      TodoTable.todo,
      where: '${TodoTable.id} = ?',
      whereArgs: [id],
    );
  }

  Future<List<TodoModel>> getTodos() async {
    List<Map> list = await _db.query(TodoTable.todo);
    return list.map((a) => TodoModel.fromMap(a)).toList();
  }
}
