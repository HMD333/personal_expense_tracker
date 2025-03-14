import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/Core/models/total_model.dart';
import 'package:personal_expense_tracker/core/utils/messenger.dart';
import '../../../../core/models/expense_model.dart';
import '../providers/expense_provider.dart';
import '../widgets/manage_expense_dialog.dart';
import '../widgets/expense_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ExpenseProvider _provider = ExpenseProvider();
  List<ExpenseModel> _data = [];
  String? _error;
  bool _isLoading = true;
  double _currentTotal = 0.0; // Track the current total

  Future<void> _fetchExpenses() async {
    try {
      _data = await _provider.getExpenses();
      _currentTotal = await _provider.getCurrentTotal(); // Fetch current total
    } catch (e) {
      _error = e.toString();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchExpenses();
  }

  void _showTotalDialog(String action) {
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
              await _addToTotal(amount);

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

    await _provider.adjustTotal(totalModel.amount); // Update total by adding
    _fetchExpenses();
    showSuccessSnackBar(
        context, 'Added \$${amount.toStringAsFixed(2)} to total.');
  }

  void _editExpense(ExpenseModel expense) {
    showDialog(
      context: context,
      builder: (_) => ManageExpenseDialog(expense: expense),
    ).then((value) {
      if (value != null) {
        _fetchExpenses(); // Refresh the list and total
        showSuccessSnackBar(context, 'Expense updated successfully.');
      }
    });
  }

  void _addExpense() {
    showDialog(
      context: context,
      builder: (_) =>
          ManageExpenseDialog(expense: null), // Passing null for a new expense
    ).then((value) {
      if (value != null) {
        _fetchExpenses(); // Refresh the list and total
        showSuccessSnackBar(context, 'Expense added successfully.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () => _addExpense(),
            icon: const Icon(Icons.add_circle_rounded),
          )
        ],
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _error != null
                ? Text('Error: $_error')
                : _data.isNotEmpty
                    ? Column(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              itemBuilder: (_, i) {
                                final expense = _data[i];
                                return ExpenseTile(
                                  index: i,
                                  expense: expense,
                                  onDelete: () async {
                                    await _provider.deleteExpense(expense.id!);
                                    await _fetchExpenses(); // Refresh the list and total
                                    showSuccessSnackBar(
                                      context,
                                      '${expense.category} deleted successfully',
                                    );
                                  },
                                  onEdit: () => _editExpense(expense),
                                );
                              },
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 8),
                              itemCount: _data.length,
                            ),
                          )
                        ],
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.attach_money,
                              size: 100, color: Colors.grey),
                          const SizedBox(height: 24),
                          const Text('There are no expenses recorded yet.'),
                          const SizedBox(height: 16),
                          TextButton.icon(
                            onPressed: () => _addExpense(),
                            label: const Text('Add first expense'),
                            icon: const Icon(Icons.add_circle_rounded),
                          ),
                        ],
                      ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: \$${_currentTotal.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                onPressed: () => _showTotalDialog('Add'),
                child: const Text('Update Total'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
