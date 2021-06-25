import 'dart:async';

import 'package:flutterapp/data/model/Task.dart';
import 'package:flutterapp/data/model/request/login_request.dart';
import 'package:flutterapp/data/model/request/registration_request.dart';
import 'package:flutterapp/data/model/response/get_all_to_do_item_response.dart';
import 'package:flutterapp/data/model/response/login_response.dart';
import 'package:flutterapp/data/model/response/registration_response.dart';
import 'package:flutterapp/database/databaseHelper.dart';
import 'package:flutterapp/network/api_service.dart';
import 'package:sqflite/sqflite.dart';

class TaskDao extends ApiService{
  final _dbHelper = DatabaseHelper.instance;

  @override
  Future<int> insert(Task task) async {
    Database? db = await _dbHelper.database;
    return await db!.insert(DatabaseHelper.table, task.toDataBaseJson());
  }

  @override
  Future<List<Task>> fetchAllTasks() async {
    Database? db = await _dbHelper.database;
    List<Map<String, Object?>>? result = await db?.query(DatabaseHelper.table);
    List<Task> tasks = result!.isNotEmpty
        ? result.map((item) => Task.fromDatabaseToJson(item)).toList()
        : [];
    return tasks;
  }

  @override
  Future<int> deleteRowByID(int? id) async {
    Database? db = await _dbHelper.database;
    return await db!.delete(DatabaseHelper.table,
        where: '${DatabaseHelper.columnId} = ?', whereArgs: [id]);
  }
}
