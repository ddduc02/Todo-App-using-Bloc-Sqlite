import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_app/models/user.dart';

class UserHelper {
  static const String DB_NAME = 'todo.db';
  static const String TABLE_USER = 'user';
  static const int VERSION = 1;
  static Database? _db;

  Database? get db => _db;

  UserHelper._private() {
    init();
  }

  static final UserHelper instance = UserHelper._private();

  init() async {
    _db = await openDatabase(
      join(await getDatabasesPath(), DB_NAME),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $TABLE_USER(id TEXT PRIMARY KEY, isLoggedIn bool, username TEXT, password TEXT)',
        );
      },
      version: VERSION,
    );
  }

  Future<void> insertUser(User user) async {
    final db = UserHelper.instance.db;
    await db?.insert(TABLE_USER, user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateUser(User user) async {
    final db = UserHelper.instance.db;

    await db?.update(
      TABLE_USER,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<User?> getUsers(String userName, String password) async {
    final db = UserHelper.instance.db;

    var res = await db!.rawQuery("SELECT * FROM $TABLE_USER WHERE "
        "username = '$userName' AND "
        "password = '$password'");
    for (int i = 0; i < res.length; i++) {
      if (userName == res[i]['username'] && password == res[i]['password']) {
        return User.fromMap(res.first);
      }
    }
    return null;
  }
}
