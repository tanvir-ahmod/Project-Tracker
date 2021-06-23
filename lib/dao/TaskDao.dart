import 'dart:async';

import 'package:flutterapp/data/model/Task.dart';
import 'package:flutterapp/database/databaseHelper.dart';
import 'package:sqflite/sqflite.dart';

class TaskDao {
  final _dbHelper = DatabaseHelper.instance;

  Future<int> insert(Task task) async {
    Database? db = await _dbHelper.database;
    return await db!.insert(DatabaseHelper.table, task.toDataBaseJson());
  }

  Future<List<Task>> fetchAllTasks() async {
    Database? db = await _dbHelper.database;
    List<Map<String, Object?>>? result = await db?.query(DatabaseHelper.table);
    List<Task> tasks = result!.isNotEmpty
        ? result.map((item) => Task.fromDatabaseToJson(item)).toList()
        : [];
    return tasks;
  }

  Future<int> deleteRowByID(int? id) async {
    Database? db = await _dbHelper.database;
    return await db!.delete(DatabaseHelper.table,
        where: '${DatabaseHelper.columnId} = ?', whereArgs: [id]);
  }
}
