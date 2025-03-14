class TotalModel {
  int? id; // Nullable to allow for uninitialized state
  final double amount;
  final DateTime date; // Store the date as a DateTime object

  TotalModel({
    this.id, // This can be set after object creation
    required this.amount,
    required this.date,
  });

  // Convert the TotalModel instance to a Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'date': date.toIso8601String(), // Convert DateTime to ISO 8601 string
    };
  }

  // Create a TotalModel instance from a Map (usually from a database query)
  static TotalModel fromMap(Map<String, dynamic> map) {
    return TotalModel(
      id: map['id'],
      amount: map['amount'],
      date: DateTime.parse(map['date']), // Convert string back to DateTime
    );
  }
}
