import 'package:flutter/material.dart';
import '../../../../core/models/expense_model.dart'; // Change to your Expense model

class ExpenseTile extends StatelessWidget {
  const ExpenseTile({
    super.key,
    required this.index,
    required this.expense,
    required this.onDelete,
    required this.onEdit,
  });

  final int index;
  final ExpenseModel expense; // Update to use ExpenseModel
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.green.withOpacity(.05), // Change color for expenses
      leading: Text('\$${expense.amount.toStringAsFixed(2)}'), // Display amount
      title: Text(
        expense.category, // Change to display category
        style: null,
      ),
      subtitle: Text(
        expense.notes, // Display notes
        style: null,
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
        ],
      ),
    );
  }
}
