import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/services/database/database_service.dart';
import 'package:stacking_cone_prototype/services/database/models/patient_model.dart';

class DbScreenViewModel extends AsyncNotifier<List<PatientModel>> {
  List<PatientModel> patientList = [];

  Future<void> getPatientList() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      patientList = await DatabaseService.getPatientIdListDB();
      return patientList;
    });
  }

  @override
  Future<List<PatientModel>> build() async {
    await getPatientList();
    // Logger().i("$DbScreenViewModel build");
    return patientList;
  }
}

final dbScreenViewModelProvider =
    AsyncNotifierProvider<DbScreenViewModel, List<PatientModel>>(() {
  return DbScreenViewModel();
});
