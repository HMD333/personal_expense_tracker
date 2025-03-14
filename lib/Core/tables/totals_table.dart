class TotalsTable {
  static String get total => 'totals';

  static String get id => 'id';
  static String get amount => 'amount';
  static String get date => 'date';

  static String get create => '''
      CREATE TABLE IF NOT EXISTS `$total` (
            `$id` INTEGER PRIMARY KEY,
            `$amount` REAL NOT NULL,
            `$date` DATETIME NOT NULL
       )''';
}
