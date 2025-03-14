import 'package:flutter/material.dart';
import '../../../../core/models/todo_model.dart';

class TodoTile extends StatelessWidget {
  const TodoTile({
    super.key,
    required this.index,
    required this.todo,
    required this.onDelete,
    required this.onEdit,
    required this.onChangeStatus,
  });

  final int index;
  final TodoModel todo;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final ValueChanged<bool?> onChangeStatus;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.purple.withOpacity(.05),
      leading: Text('${index + 1}'),
      title: Text(
        todo.title,
        style: todo.done
            ? const TextStyle(
                color: Colors.grey,
                decoration: TextDecoration.lineThrough,
                decorationColor: Colors.grey,
              )
            : null,
      ),
      subtitle: Text(
        todo.description,
        style: todo.done
            ? const TextStyle(
                color: Colors.grey,
                decoration: TextDecoration.lineThrough,
                decorationColor: Colors.grey,
              )
            : null,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onDelete,
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: Colors.red,
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(
              Icons.mode_edit_outline_rounded,
              color: Colors.blue,
            ),
          ),
          Checkbox(
            value: todo.done,
            onChanged: (bool? value) {
              // Ensure the state is updated correctly and notify parent widget
              onChangeStatus(value);
            },
          )
        ],
      ),
    );
  }
}
