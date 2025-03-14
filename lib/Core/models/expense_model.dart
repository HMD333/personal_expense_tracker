class ExpenseModel {
  int? id; // Changed from final to a normal int
  final double amount;
  final String category;
  final DateTime date; // Changed from String to DateTime
  final String notes;

  ExpenseModel({
    this.id, // Now you can set this after object creation
    required this.amount,
    required this.category,
    required this.date,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }

  static ExpenseModel fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      id: map['id'],
      amount: map['amount'],
      category: map['category'],
      date: DateTime.parse(map['date']),
      notes: map['notes'],
    );
  }
}
