class ExpenseTable {
  static String get expense => 'expenses';

  static String get id => 'id';
  static String get amount => 'amount';
  static String get category => 'category';
  static String get date => 'date';
  static String get notes => 'notes';
  static String get createdAt => 'created_at';

  static String get create => '''
      CREATE TABLE IF NOT EXISTS `$expense` (
            `$id` INTEGER PRIMARY KEY,
            `$amount` REAL NOT NULL,
            `$category` TEXT NOT NULL,
            `$date` DATETIME NOT NULL,
            `$notes` TEXT,
            `$createdAt` DATETIME DEFAULT CURRENT_TIMESTAMP
       )''';
}
