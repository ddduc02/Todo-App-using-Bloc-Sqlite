import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_app/models/user.dart';

class DataBaseHelper {
  static const String DB_NAME = 'todo.db';
  static const String TABLE_USER = 'user'; // Thay đổi tên bảng thành "user"
  static const int VERSION = 1;
  static Database? _db;

  Database? get db => _db;

  DataBaseHelper._internal() {
    init();
  }

  static final DataBaseHelper instance = DataBaseHelper._internal();

  init() async {
    _db = await openDatabase(
      join(await getDatabasesPath(), DB_NAME),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE $TABLE_USER(id INTEGER PRIMARY KEY, username TEXT, password TEXT)',
        );
      },
      version: VERSION,
    );
  }

  Future<void> insertUser(User user) async {
    final db = DataBaseHelper.instance.db;
    await db?.insert(TABLE_USER, user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<bool> getUsers(String userName, String password) async {
    final db = DataBaseHelper.instance.db;

    var res = await db!.rawQuery("SELECT * FROM $TABLE_USER WHERE "
        "username = '$userName' AND "
        "password = '$password'");
    for (int i = 0; i < res.length; i++) {
      if (userName == res[i]['username'] && password == res[i]['password']) {
        return true;
      }
    }
    return false;
  }
}
