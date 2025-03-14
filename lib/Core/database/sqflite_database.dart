import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../tables/expense_table.dart';
import '../tables/totals_table.dart';

class SqfliteDatabase {
  static late final Database db;

  // Initialize the database
  static Future<void> initialize() async {
    String path = await _getDbPath();
    db = await openDatabase(path, onCreate: _onCreate, version: 1);
  }

  // Create tables when the database is created
  static Future<void> _onCreate(Database db, int version) async {
    print('Database created and tables initialized');
    await db.execute(ExpenseTable.create); // Create the expenses table
    await db.execute(TotalsTable.create); // Create the totals table
    // insertTotal(0.0);
  }

  // Get the database path
  static Future<String> _getDbPath() async {
    String databasePath = await getDatabasesPath();
    return join(databasePath, 'expense_tracker.db'); // Consistent database name
  }

  // Delete the entire database
  static Future<void> deleteDb() async {
    String path = await _getDbPath();
    await deleteDatabase(path);
  }
}
