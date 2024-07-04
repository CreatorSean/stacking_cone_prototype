import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stacking_cone_prototype/services/database/models/game_record_model.dart';
import 'package:stacking_cone_prototype/services/database/models/patient_model.dart';

class DatabaseService {
  static late Database _database;

  static Future<Database?> get database async {
    _database = await initDB();
    return _database;
  }

  static initDB() async {
    Logger().i(await getDatabasesPath());
    String path = join(await getDatabasesPath(), 'StackingCone.db');

    //데이터 베이스를 리셋하고 싶을때 주석 지우고 다시시작
    await deleteDatabase(path);

    //db가 존재하지 않으면 onCreate 함수 실행되어 table 생성
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(
          "CREATE TABLE GameRecords(id INTEGER PRIMARY KEY AUTOINCREMENT, totalCone INTEGER, answerCone INTEGER, wrongCone INTEGER, totalTime INTEGER)");
      await db.execute(
          "CREATE TABLE Patients(id INTEGER PRIMARY KEY AUTOINCREMENT,  userName TEXT, gender INTEGER, birth TEXT,  diagnosis TEXT, diagnosisDate TEXT, surgeryDate TEXT, medication TEXT, memo TEXT, age INT NOT NULL)");
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

  // ========================= update Train Record DB ==============================
  static Future<void> updatenRecordDB(GameRecordModel record) async {
    final db = await database;
    Logger().i('Update DB: ${record.id}');
    await db!.update(
      "GameRecords",
      record.toMap(),
      where: "id = ?",
      whereArgs: [record.id],
    );
  }

  ///DB에서 모든 데이터를 불러와서 하나씩 모델 생성하고, 모두 List로 반환
  static Future<List<GameRecordModel>> getGameRecordsListDB() async {
    final db = await database;
    Logger().i('Get GameRecordsList DB');

    final List<Map<String, dynamic>> maps = await db!.query('GameRecords');

    return List.generate(maps.length, (index) {
      return GameRecordModel(
        id: maps[index]["id"],
        totalCone: maps[index]["totalCone"],
        answerCone: maps[index]["answerCone"],
        wrongCong: maps[index]["wrongCone"],
        totalTime: maps[index]["totalTime"],
      );
    });
  }

  ///DB에서 모든 데이터를 불러와서 하나씩 모델 생성하고, 모두 List로 반환
  static Future<List<PatientModel>> getSelectedPatientDB(patientId) async {
    final db = await database;
    Logger().i('Get SelectedPatient DB : $patientId');
    final List<Map<String, dynamic>> maps = await db!.query(
      'Patients',
      where: 'id = ?',
      whereArgs: [patientId],
    );
    return List.generate(maps.length, (index) {
      return PatientModel(
        id: maps[index]["id"],
        userName: maps[index]["userName"],
        gender: maps[index]["gender"],
        birth: maps[index]["birth"],
        memo: maps[index]["memo"],
        diagnosis: maps[index]["diagnosis"],
        diagnosisDate: maps[index]["diagnosisDate"],
        surgeryDate: maps[index]["surgeryDate"],
        medication: maps[index]["medication"],
        age: maps[index]["age"],
      );
    });
  }

// ========================= update DB ==============================
  static Future<void> updatePatientDB(PatientModel patient) async {
    final db = await database;
    Logger().i('Update DB: ${patient.userName}');
    await db!.update(
      "Users",
      patient.toMap(),
      where: "id = ?",
      whereArgs: [patient.id],
    );
  }

  ///DB에서 모든 데이터를 불러와서 하나씩 모델 생성하고, 모두 List로 반환
  static Future<List<PatientModel>> getPatientIdListDB() async {
    final db = await database;
    Logger().i('Get PatientList DB');

    final List<Map<String, dynamic>> maps = await db!.query('Patients');

    return List.generate(maps.length, (index) {
      return PatientModel(
        id: maps[index]["id"],
        userName: maps[index]["userName"],
        gender: maps[index]["gender"],
        birth: maps[index]["birth"],
        memo: maps[index]["memo"],
        diagnosis: maps[index]["diagnosis"],
        diagnosisDate: maps[index]["diagnosisDate"],
        surgeryDate: maps[index]["surgeryDate"],
        medication: maps[index]["medication"],
        age: maps[index]["age"],
      );
    });
  }
}
