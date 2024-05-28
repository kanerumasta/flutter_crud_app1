import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'contacts.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE contacts(id INTEGER PRIMARY KEY, firstname TEXT, lastname TEXT, email TEXT, phone TEXT, image BLOB NULL)",
        );
      },
      version: 1,
    );
  }
}
