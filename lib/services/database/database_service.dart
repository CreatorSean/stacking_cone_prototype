import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stacking_cone_prototype/services/database/models/game_record_model.dart';

class DatabaseService {
  static late Database _database;

  static Future<Database?> get database async {
    _database = await initDB();
    return _database;
  }

  static initDB() async {
    Logger().i(await getDatabasesPath());
    String path = join(await getDatabasesPath(), 'HonestBalance.db');

    //리셋하고 싶을때 주석 지우고 다시시작
    // await deleteDatabase(path);

    //db가 존재하지 않으면 onCreate 함수 실행되어 table 생성
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(
          "CREATE TABLE GameRecords(id INTEGER PRIMARY KEY AUTOINCREMENT, totalCone INTEGER, answerCone INTEGER, totalTime INTEGER)");
    }, onUpgrade: (db, oldVersion, newVersion) {});
  }

  // ========================= insert DB ==============================
  static void insertDB(model, String tablename) async {
    final db = await database;
    Logger().i('Insert $tablename DB');

    await db!.insert(
      tablename,
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// ========================= delete DB ==============================
  static Future<void> deleteDB(model, String tablename) async {
    final db = await database;
    Logger().i('Delete DB');

    await db!.delete(
      tablename,
      where: "id = ?",
      whereArgs: [model.id],
    );
  }

  // ========================= update DB ==============================
  static Future<void> updateUserDB(GameRecordModel record) async {
    final db = await database;
    Logger().i('Update DB: ${record.id}');
    await db!.update(
      "Users",
      record.toMap(),
      where: "id = ?",
      whereArgs: [record.id],
    );
  }

  ///DB에서 모든 데이터를 불러와서 하나씩 모델 생성하고, 모두 List로 반환
  static Future<List<GameRecordModel>> getUserListDB() async {
    final db = await database;
    Logger().i('Get UserList DB');

    final List<Map<String, dynamic>> maps = await db!.query('Users');

    return List.generate(maps.length, (index) {
      return GameRecordModel(
        id: maps[index]["id"],
        totalCone: maps[index]["totalCone"],
        answerCone: maps[index]["answerCone"],
        totalTime: maps[index]["totalTime"],
      );
    });
  }
}
