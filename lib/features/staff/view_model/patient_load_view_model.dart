import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/services/database/database_service.dart';
import 'package:stacking_cone_prototype/services/database/models/patient_model.dart';

class PatientLoadViewModel extends AsyncNotifier<List<PatientModel>> {
  List<PatientModel> patientList = [];

  Future<List<PatientModel>> loadPatientList() async {
    List<PatientModel> patientData = await DatabaseService.getPatientIdListDB();
    print(patientData);

    for (var item in patientData) {
      PatientModel patientData = PatientModel(
        id: item.id,
        userName: item.userName,
        gender: item.gender,
        birth: item.birth,
        age: item.age,
        diagnosis: item.diagnosis,
        diagnosisDate: item.diagnosisDate,
        surgeryDate: item.surgeryDate,
        medication: item.medication,
      );
      patientList.add(patientData);
    }

    return patientList;
  }

  @override
  FutureOr<List<PatientModel>> build() async {
    await loadPatientList();
    return patientList;
  }
}

final patientLoadViewModel =
    AsyncNotifierProvider<PatientLoadViewModel, List<PatientModel>>(
  () {
    return PatientLoadViewModel();
  },
);
