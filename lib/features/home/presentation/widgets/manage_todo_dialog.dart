import 'package:flutter/material.dart';
import '../../../../core/models/todo_model.dart';
import '../../../../core/utils/navigations.dart';
import '../../../../core/utils/validations.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../providers/todo_provider.dart';

class ManageTodoDialog extends StatefulWidget {
  const ManageTodoDialog({super.key, this.todo});

  final TodoModel? todo;

  @override
  State<ManageTodoDialog> createState() => _ManageTodoDialogState();
}

class _ManageTodoDialogState extends State<ManageTodoDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  final _provider = TodoProvider();
  final _formKey = GlobalKey<FormState>();
  late final bool _isEdit;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      _titleController = TextEditingController(text: todo.title);
      _descriptionController = TextEditingController(text: todo.description);
      _isEdit = true;
    } else {
      _titleController = TextEditingController();
      _descriptionController = TextEditingController();
      _isEdit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _isEdit ? 'Edit ${widget.todo?.title}' : 'Add Todo',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _titleController,
                label: 'Title',
                validator: requiredValidator,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _descriptionController,
                label: 'Description',
                validator: requiredValidator,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final todo = TodoModel(
                          id: widget.todo
                              ?.id, // Add this to keep the same ID if editing
                          title: _titleController.text,
                          description: _descriptionController.text,
                        );

                        if (_isEdit) {
                          await _provider
                              .updateTodo(todo); // Update existing Todo
                        } else {
                          await _provider.addTodo(todo); // Add new Todo
                        }

                        pop(context, _titleController.text);
                      }
                    },
                    child: const Text('Save'),
                  ),
                  OutlinedButton(
                    onPressed: () => pop(context),
                    child: const Text('Cancel'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
