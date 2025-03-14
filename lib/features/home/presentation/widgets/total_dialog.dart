import 'package:flutter/material.dart';
import '../../../../core/models/total_model.dart'; // Adjust the import based on your structure
import '../providers/expense_provider.dart'; // Adjust the import based on your structure
import '../../../../core/utils/messenger.dart'; // Adjust the import based on your structure

class TotalDialog {
  final BuildContext context;
  final ExpenseProvider provider;

  TotalDialog({required this.context, required this.provider});

  Future<void> showUpdateTotalDialog(String action) async {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Enter Amount to $action'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: 'Amount'),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              double amount = double.tryParse(controller.text) ?? 0.0;
              if (action == 'Add') {
                await _addToTotal(amount);
              } else {
                await _subtractFromTotal(amount);
              }
              Navigator.of(context).pop();
            },
            child: Text(action),
          ),
        ],
      ),
    );
  }

  Future<void> _addToTotal(double amount) async {
    TotalModel totalModel = TotalModel(
      amount: amount,
      date: DateTime.now(),
    );

    await provider.adjustTotal(totalModel.amount); // Update total by adding
    showSuccessSnackBar(
        context, 'Added \$${amount.toStringAsFixed(2)} to total.');
  }

  Future<void> _subtractFromTotal(double amount) async {
    TotalModel totalModel = TotalModel(
      amount: -amount, // Use negative amount for subtraction
      date: DateTime.now(),
    );

    await provider
        .adjustTotal(totalModel.amount); // Update total by subtracting
    showSuccessSnackBar(
        context, 'Subtracted \$${amount.toStringAsFixed(2)} from total.');
  }
}
