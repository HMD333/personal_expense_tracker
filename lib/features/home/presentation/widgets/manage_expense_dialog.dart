import 'package:flutter/material.dart';
import '../../../../core/models/expense_model.dart'; // Change to your Expense model
import '../../../../core/utils/navigations.dart';
import '../../../../core/utils/validations.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../providers/expense_provider.dart'; // Change to your Expense provider

class ManageExpenseDialog extends StatefulWidget {
  const ManageExpenseDialog({super.key, this.expense});

  final ExpenseModel? expense; // Update to use ExpenseModel

  @override
  State<ManageExpenseDialog> createState() => _ManageExpenseDialogState();
}

class _ManageExpenseDialogState extends State<ManageExpenseDialog> {
  late final TextEditingController _amountController;
  late final TextEditingController _categoryController;
  late final TextEditingController _notesController;
  final _provider = ExpenseProvider(); // Update to use ExpenseProvider
  final _formKey = GlobalKey<FormState>();
  late final bool _isEdit;

  @override
  void initState() {
    super.initState();
    final expense = widget.expense;
    if (expense != null) {
      _amountController =
          TextEditingController(text: expense.amount.toString());
      _categoryController = TextEditingController(text: expense.category);
      _notesController = TextEditingController(text: expense.notes);
      _isEdit = true;
    } else {
      _amountController = TextEditingController();
      _categoryController = TextEditingController();
      _notesController = TextEditingController();
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
                _isEdit ? 'Edit Expense' : 'Add Expense',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _amountController,
                label: 'Amount',
                keyboardType: TextInputType.number,
                validator: requiredValidator, // Ensure to validate the amount
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _categoryController,
                label: 'Category',
                keyboardType: TextInputType.text,
                validator: requiredValidator,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _notesController,
                label: 'Notes',
                keyboardType: TextInputType.text,
                validator: null, // Notes can be optional
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.green, // Change color for expenses
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Parse the amount and check if it's valid
                        final amount = double.tryParse(_amountController.text);
                        if (amount == null) {
                          // Show an error message if the amount is not valid
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please enter a valid amount.')),
                          );
                          return; // Exit the method if the amount is invalid
                        }

                        final expense = ExpenseModel(
                          id: widget.expense?.id, // Keep the same ID if editing
                          amount: amount, // Use the validated amount
                          category: _categoryController.text,
                          date: DateTime
                              .now(), // Set to the current date or allow user to pick
                          notes: _notesController.text,
                        );

                        if (_isEdit) {
                          await _provider.updateExpense(
                              expense); // Update existing expense
                        } else {
                          await _provider
                              .addExpense(expense); // Add new expense
                        }

                        pop(context, _amountController.text);
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
