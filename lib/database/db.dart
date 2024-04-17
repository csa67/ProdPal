import 'package:flutter/widgets.dart';
import 'package:hci/model/Task.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;

  // Ensure widgets are initialized if this is the first time this class is accessed.
  DatabaseHelper._privateConstructor() {
    WidgetsFlutterBinding.ensureInitialized();
  }

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    // Only create the database if it doesn't already exist.
    if (_database != null) return _database!;
    // Lazily instantiate the db the first time it is accessed.
    _database = await _initDatabase();
    return _database!;
  }

  // Open the database and create it if it doesn't exist.
  _initDatabase() async {
    String path = join(await getDatabasesPath(), 'tasklist.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // SQL code to create the database table.
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE taskslist(
            id TEXT PRIMARY KEY,
            title TEXT,
            description TEXT,
            date TEXT,
            startTime TEXT,
            endTime TEXT,
            tag TEXT,
            priority INTEGER,
            isCompleted INTEGER
          )
          ''');
  }

  Future<void> insertTask(Task task) async {
    final db = await database;
    await db.insert(
      'taskslist',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Task>> getTasks(DateTime forDate, {bool? completed}) async {
    final db = await database;
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedDate = formatter.format(forDate);

    String whereClause = "date(date) = ?";
    List<dynamic> whereArgs = [formattedDate];

    // Modify the query to optionally filter by the `isCompleted` status
    if (completed != null) {
      whereClause += " AND isCompleted = ?";
      whereArgs.add(completed ? 1 : 0);
    }

    final List<Map<String, dynamic>> taskMaps = await db.query(
      'taskslist',
      where: whereClause,
      whereArgs: whereArgs,
    );

    return List.generate(taskMaps.length, (i) {
      return Task.fromMap(taskMaps[i]);
    });
  }


  Future<void> deleteTask(String taskId) async {
    final db = await database;
    await db.delete(
      'taskslist',
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }

Future<void> updateTaskCompletion(String taskId, bool isCompleted) async {
  final db = await database;
  try {
    int count = await db.update(
      'taskslist',
      {'isCompleted': isCompleted ? 1 : 0},
      where: 'id = ?',
      whereArgs: [taskId],
    );
    if (count == 0) {
      print("No task updated: Check if task ID $taskId exists.");
    } else {
      print("$count task(s) marked as completed.");
    }
  } catch (e) {
    print("Error updating task: $e");
  }
}


}
// Future<List<Task>> getCompletedTasks(bool isDone) async{
//   final db = await database;
//
//   final List<Map<>
// }


// Future<List<Task>> getTasks() async {
//   final db = await database;
//   final List<Map<String, dynamic>> taskMaps = await db.query('taskslist');
//
//   return List.generate(taskMaps.length, (i) {
//     return Task.fromMap(taskMaps[i]);
//   });
// }

