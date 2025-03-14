import 'package:personal_expense_tracker/Core/tables/totals_table.dart';
import '../../../../core/database/sqflite_database.dart';
import '../../../../core/models/expense_model.dart';
import '../../../../core/models/total_model.dart';
import '../../../../core/tables/expense_table.dart';

class ExpenseProvider {
  final _db = SqfliteDatabase.db;

  // Add an expense
  Future<ExpenseModel> addExpense(ExpenseModel expense) async {
    // Assign the ID from the insertExpense method
    expense.id = await insertExpense(expense);

    // Adjust the total after inserting
    await adjustTotal(-expense.amount);

    return expense;
  }

  // Get an expense by ID
  Future<ExpenseModel?> getExpense(int id) async {
    List<Map<String, dynamic>> maps = await _db.query(
      ExpenseTable.expense,
      where: '${ExpenseTable.id} = ?',
      whereArgs: [id],
      limit: 1,
    );
    return maps.isNotEmpty ? ExpenseModel.fromMap(maps.first) : null;
  }

  // Update an expense
  Future<int> updateExpense(ExpenseModel updatedExpense) async {
    final existingExpense = await getExpense(updatedExpense.id!);
    if (existingExpense == null) {
      return 0; // Expense not found
    }

    // Calculate the difference in amounts
    await adjustTotal(existingExpense.amount);
    await _db.update(
      ExpenseTable.expense,
      updatedExpense.toMap(),
      where: '${ExpenseTable.id} = ?',
      whereArgs: [updatedExpense.id],
    );

    // Adjust total
    await adjustTotal(-updatedExpense.amount);
    return 1; // Return success
  }

  // Delete an expense
  Future<int> deleteExpense(int id) async {
    final expense = await getExpense(id);
    if (expense != null) {
      await _db.delete(
        ExpenseTable.expense,
        where: '${ExpenseTable.id} = ?',
        whereArgs: [id],
      );
      await adjustTotal(expense.amount); // Adjust total
    }
    return 1; // Return the number of deleted records
  }

  // Get all expenses
  Future<List<ExpenseModel>> getExpenses() async {
    List<Map<String, dynamic>> list = await _db.query(ExpenseTable.expense);
    return list.map((a) => ExpenseModel.fromMap(a)).toList();
  }

  // Adjust the total amount in the totals table
  Future<void> adjustTotal(double amount) async {
    final currentTotal = await getCurrentTotal();
    await updateTotal(currentTotal + amount); // Update total
  }

  // Get the current total from the totals table
  Future<double> getCurrentTotal() async {
    final List<Map<String, dynamic>> result = await _db.query(
      TotalsTable.total,
      limit: 1,
      orderBy: '${TotalsTable.id} DESC', // Get the latest total
    );

    return result.isNotEmpty
        ? result.first[TotalsTable.amount]
        : insertTotal(0.0); // Return current total or 0
  }

  // Update the total amount in the totals table
  Future<void> updateTotal(double newTotal) async {
    TotalModel totalModel = TotalModel(
      id: 1,
      amount: newTotal,
      date: DateTime.now(),
    );

    await _db.update(
      TotalsTable.total,
      totalModel.toMap(),
      where: '${TotalsTable.id} = ?',
      whereArgs: [totalModel.id],
    );
  }

  Future<double> insertTotal(double amount) async {
    await _db.insert(
      TotalsTable.total,
      {
        'amount': amount,
        'date': DateTime.now().toIso8601String(),
      },
    );
    return amount;
  }

  // Insert a new expense
  Future<int> insertExpense(ExpenseModel expense) async {
    return await _db.insert(ExpenseTable.expense, expense.toMap());
  }
}
