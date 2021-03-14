import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class MySqliteConnection {
  static Database? _db;
  static MySqliteConnection _instance = MySqliteConnection.__internal();

  MySqliteConnection.__internal();


  factory MySqliteConnection() {
    return _instance;
  }

  Future<Database> _openConnection() async {
    String? dbPath = await getDatabasesPath();
    String? resolvePath = join(dbPath!, 'appdb.db');


    return await openDatabase(
      resolvePath,
      version: 10,
      onCreate: this.onCreate
    );
  }


  Future<Database> get getConnection async {
    if (_db == null) {
      _db = await _openConnection();
    }

    return _db!;
  }


  Future<void> onCreate(Database db, int version) async {
    /**
     * Create all definition tables here.
     */
    await db.execute(
      """
      CREATE TABLE herbs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        photo VARCHAR(222) DEFAULT NULL,
        title VARCHAR(222),
        description TEXT,
        created TIMESTEMP DEFAULT CURRENT_TIMESTAMP,
        updated DATETIME DEFAULT NULL
      );
      """
    );
  }

}
