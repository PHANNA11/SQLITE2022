import 'package:path/path.dart';
import 'package:project_sqlite_2022/model/userdata.dart';
import 'package:sqflite/sqflite.dart';

String table = 'user';

class ConnectionDB {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'tododatabase.db'),
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE $table(id INTEGER PRIMARY KEY, name TEXT, password TEXT,pic BLOB)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertUser(User user) async {
    final db = await initializeDB();
    await db.insert(table, user.tomap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    print('Function Insert');
  }

  Future<List<User>> getUser() async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.query(table);
    return queryResult.map((e) => User.toJson(e)).toList();
    //queryResult.map((e) => todo.fromMap(e)).toList();
  }

  Future<void> updateUser(User user) async {
    final db = await initializeDB();
    await db.update(table, user.tomap(), where: 'id=?', whereArgs: [user.id]);
  }

  Future<void> deleteUser(int id) async {
    final db = await initializeDB();
    await db.delete(table, where: 'id=?', whereArgs: [id]);
  }
}
