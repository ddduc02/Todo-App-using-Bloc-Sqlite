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

  Future<List<Task>> getAllTasks(String userId, int dayOfWeek) async {
    final db = TaskHelper.instance.db;
    int dayOfWeek2 = (dayOfWeek + 1) % 7;
    var res = await db!.rawQuery(
        "SELECT * FROM $TABLE_TASK WHERE userId = '$userId' AND isCompleted = 0 AND strftime('%w', dueDate) = '$dayOfWeek2'");
    List<Task> tasks = [];
    print("check res $res");
    for (var taskMap in res) {
      print(Task.fromMap(taskMap).dueDate);
      tasks.add(Task.fromMap(taskMap));
    }
    return tasks;
  }

  Future<double> getAllTasksByDay(String userId, String date) async {
    final db = TaskHelper.instance.db;
    var res = await db!.rawQuery(
        "SELECT * FROM $TABLE_TASK WHERE userId = '$userId' AND DATE(dueDate) = DATE('$date')");
    var res2 = await db!.rawQuery(
        "SELECT * FROM $TABLE_TASK WHERE userId = '$userId' AND isCompleted = 0 AND DATE(dueDate) = DATE('$date')");
    List<Task> allTask = [];
    List<Task> unCompletedTask = [];
    print("check res1 $res");
    print("check res2 $res2");

    for (var taskMap in res) {
      print(Task.fromMap(taskMap).dueDate);
      allTask.add(Task.fromMap(taskMap));
    }

    for (var taskMap in res2) {
      print(Task.fromMap(taskMap).dueDate);
      unCompletedTask.add(Task.fromMap(taskMap));
    }
    double percentage = 0.0;
    if (allTask.length > 0) {
      percentage = (1 - unCompletedTask.length / allTask.length) * 100;
    }
    return percentage;
  }
}
