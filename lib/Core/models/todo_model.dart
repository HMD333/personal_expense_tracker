import '../tables/todo_table.dart';

class TodoModel {
  TodoModel({
    this.id,
    required this.title,
    required this.description,
    this.done = false,
  });

  int? id;
  final String title;
  final String description;
  final bool done;

  factory TodoModel.fromMap(Map<dynamic, dynamic> map) => TodoModel(
        id: map[TodoTable.id],
        title: map[TodoTable.title],
        description: map[TodoTable.description],
        done: map[TodoTable.done] == 1,
      );

  Map<String, Object?> toMap() => {
        if (id != null) TodoTable.id: id,
        TodoTable.title: title,
        TodoTable.description: description,
        TodoTable.done: done ? 1 : 0,
      };
}
