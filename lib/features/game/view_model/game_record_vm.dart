import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/services/database/database_service.dart';
import 'package:stacking_cone_prototype/services/database/models/game_record_model.dart';

class GameReocrdViewModel extends AsyncNotifier<List<GameRecordModel>> {
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

  @override
  Future<List<GameRecordModel>> build() async {
    return recordList;
  }
}

final gameRecordProvider =
    AsyncNotifierProvider<GameReocrdViewModel, List<GameRecordModel>>(() {
  return GameReocrdViewModel();
});
