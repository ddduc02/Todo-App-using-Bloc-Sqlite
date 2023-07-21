import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_app/models/task.dart';

class TaskHelper {
  static const String DB_NAME = "todo2.db";
  static const String TABLE_TASK = "task";
  static const int VERSION = 1;
  static Database? _db;

  Database? get db => _db;

  TaskHelper._private() {
    init();
  }

  static final TaskHelper instance = TaskHelper._private();

  init() async {
    _db = await openDatabase(
      join(await getDatabasesPath(), DB_NAME),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE $TABLE_TASK(taskId TEXT PRIMARY KEY, title TEXT, description String, dueDate DATETIME, isCompleted INTEGER, userId TEXT, FOREIGN KEY (userId) REFERENCES user(id))');
      },
      version: VERSION,
    );
  }

  Future<bool> isTableExists(String tableName) async {
    var tables = await db!
        .query('sqlite_master', where: 'name = ?', whereArgs: [tableName]);
    return tables.isNotEmpty;
  }

  Future<void> insertTask(Task task) async {
    final db = TaskHelper.instance.db;
    await db?.insert(TABLE_TASK, task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateTask(Task task) async {
    final db = TaskHelper.instance.db;
    await db?.update(TABLE_TASK, task.toMap(),
        where: 'taskId = ?', whereArgs: [task.taskId]);
  }

  Future<void> deleteTask(Task task) async {
    final db = TaskHelper.instance.db;
    await db?.delete(TABLE_TASK, where: 'taskId = ?', whereArgs: [task.taskId]);
  }

  Future<List<Task>> getAllTasks(String userId) async {
    final db = TaskHelper.instance.db;
    var res = await db!.rawQuery(
        "SELECT * FROM $TABLE_TASK WHERE userId = '$userId' AND isCompleted = 0");
    List<Task> tasks = [];
    for (var taskMap in res) {
      tasks.add(Task.fromMap(taskMap));
    }
    return tasks;
  }
}
