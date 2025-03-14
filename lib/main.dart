import 'package:flutter/material.dart';
import 'core/database/sqflite_database.dart';
import 'features/home/presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SqfliteDatabase.initialize();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Expense Tracker',
      home: HomeScreen(),
      debugShowCheckedModeBanner: false, // Optional
    );
  }
}
