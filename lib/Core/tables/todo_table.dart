class TodoTable {
  static String get todo => 'todo';

  static String get id => 'id';
  static String get title => 'title';
  static String get description => 'description';
  static String get done => 'done';

  static String get create => '''
      CREATE TABLE IF NOT EXISTS `$todo` (
            `$id` INTEGER PRIMARY KEY,
            `$title` TEXT NOT NULL,
            `$description` TEXT NOT NULL,
            `$done` INTEGER NOT NULL
       )''';
}
