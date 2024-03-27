import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static late Database _database;

  static Future<Database?> get database async {
    _database = await initDB();
    return database;
  }

  static initDB() async {
    Logger().i(await getDatabasesPath());
    String path = join(await getDatabasesPath(), 'HonestBalance.db');

    //리셋하고 싶을때 주석 지우고 다시시작
    // await deleteDatabase(path);

    //db가 존재하지 않으면 onCreate 함수 실행되어 table 생성
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(
          "CREATE TABLE Records(id INTEGER PRIMARY KEY AUTOINCREMENT, )");
    }, onUpgrade: (db, oldVersion, newVersion) {});
  }
}
