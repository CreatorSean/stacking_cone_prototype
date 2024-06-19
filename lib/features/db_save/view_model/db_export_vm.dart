import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stacking_cone_prototype/services/database/database_service.dart';
import 'package:stacking_cone_prototype/services/database/models/game_record_model.dart';

class DbExportViewModel extends AsyncNotifier<List<GameRecordModel>> {
  List<GameRecordModel> recordList = [];
  late Timer? timer;

  Future<void> getRecordList() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // print("Get User List View Model");
      recordList = await DatabaseService.getGameRecordsListDB();
      return recordList;
    });
  }

  Future<void> insertRecord(GameRecordModel record) async {
    await AsyncValue.guard(() async {
      // Logger().d("Setting View Model : User insert ${user.userName}");
      DatabaseService.insertDB(record, "GameRecords");
    });
    await getRecordList();
  }

  Future<void> deleteRecord(GameRecordModel record) async {
    await AsyncValue.guard(() async {
      // Logger().d("Setting View Model : User delete ${user.userName}");
      DatabaseService.deleteDB(record, "GameRecords");
    });
    await getRecordList();
  }

  Future<void> updateRecord(GameRecordModel record) async {
    await AsyncValue.guard(() async {
      // Logger().d("Setting View Model : User delete ${user.userName}");
      DatabaseService.updatenRecordDB(record);
    });
    await getRecordList();
  }

  Future<String> getDatabasePath(String dbName) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, dbName);
    return path;
  }

  Future<void> copyDatabaseToExternalStorage() async {
    // 데이터베이스 경로 가져오기
    String dbPath = await getDatabasePath("GameRecords");

    // 외부 스토리지 디렉토리 가져오기
    Directory? externalDirectory = await getExternalStorageDirectory();
    String backupPath = join(externalDirectory!.path, "GameRecords");

    // 데이터베이스 파일 복사
    File sourceFile = File(dbPath);
    File backupFile = File(backupPath);

    if (await sourceFile.exists()) {
      await backupFile.writeAsBytes(await sourceFile.readAsBytes());
      print('데이터베이스 백업 완료: $backupPath');
    } else {
      print('데이터베이스가 존재하지 않습니다.');
    }
  }

  @override
  Future<List<GameRecordModel>> build() async {
    return recordList;
  }
}

final dbExportProvider =
    AsyncNotifierProvider<DbExportViewModel, List<GameRecordModel>>(() {
  return DbExportViewModel();
});
