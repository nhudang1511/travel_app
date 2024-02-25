import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/user_model.dart';

class DBProvider {
  static const table = 'user';
  static const id = 'id';
  static const email = 'email';
  static const password = 'password';
  static const phone = 'phone';
  static const name = 'name';
  static const country = 'country';
  static Database? db;

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'Demo.db');
    db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $id INTEGER PRIMARY KEY AUTOINCREMENT,
        $name TEXT,
        $password TEXT,
        $email TEXT,
        $phone INTEGER,
        $country TEXT
      )
      ''');
  }
}

class DBOP {
  static newUser(User newUser) async {
    Database db = await DBProvider().initDB();
    final result = await db.rawInsert(
        'INSERT INTO ${DBProvider.table} (${DBProvider.name},'
            ' ${DBProvider.password},  ${DBProvider.email},  '
            '${DBProvider.phone},  ${DBProvider.country}) VALUES(?, ?, ?, ?, ?)',
        [newUser.name, newUser.password, newUser.email, newUser.phone, newUser.country]);
    return result;
  }

  static getClient() async {
    final db = await DBProvider().initDB();
    var res = await db?.query(DBProvider.table);
    print('res: $res');
    if (res != null && res.isNotEmpty) {
      var resMap = res.first; // Lấy phần tử đầu tiên trong danh sách
      return resMap.isNotEmpty ? resMap : null;
    } else {
      return null;
    }
  }

  static Future<User?> getLogin(String email, String password) async {
    final db = await DBProvider().initDB();
    var res = await db?.query(DBProvider.table,
        where: '${DBProvider.email} = ? AND ${DBProvider.password} = ?',
        whereArgs: [email, password]);
    print('res: $res');
    if (res != null && res.isNotEmpty) {
      var resMap = res.first; // Lấy phần tử đầu tiên trong danh sách
      return resMap.isNotEmpty ? resMap : null;
    } else {
      return null;
    }
  }

  static deleteAll() async {
    final db = await DBProvider().initDB();
    db.rawDelete("Delete from ${DBProvider.table}");
  }
}
