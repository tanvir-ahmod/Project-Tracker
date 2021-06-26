import 'dart:async';

import 'package:flutterapp/data/model/Task.dart';
import 'package:flutterapp/data/model/response/base_response.dart';
import 'package:flutterapp/database/databaseHelper.dart';
import 'package:flutterapp/helpers/Constants.dart';
import 'package:flutterapp/network/api_service.dart';
import 'package:sqflite/sqflite.dart';

class TaskDao extends ApiService {
  final _dbHelper = DatabaseHelper.instance;

  @override
  Future<BaseResponse> insert(Task task) async {
    Database? db = await _dbHelper.database;
    var status = await db!.insert(DatabaseHelper.table, task.toDataBaseJson());
    var baseResponse = BaseResponse(responseCode: 0, responseMessage: "");
    if (status == 1) {
      baseResponse = BaseResponse(
          responseCode: Constants.RESPONSE_OK,
          responseMessage: "Inserted Successfully");
    }
    return Future.value(baseResponse);
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
