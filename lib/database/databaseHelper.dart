import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "TodoItemDB.db";
  static final _databaseVersion = 1;
  static final table = 'todoItems';

  static final columnId = '_id';
  static final columnTask = 'task';

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, _databaseName);
    return openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $table ($columnId INTEGER PRIMARY KEY,$columnTask TEXT NOT NULL)');
  }

  /*Future<List<Map<String, dynamic>>> queryOneRow(int id) async {
    Database db = await instance.database;
    return await db.query(table, where: '$columnId = ?', whereArgs: [id]);
  }*/


}
