import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacking_cone_prototype/services/database/database_service.dart';
import 'package:stacking_cone_prototype/services/database/models/patient_model.dart';

class SelectedPatientViewModel extends AsyncNotifier<PatientModel> {
  PatientModel selectedPatient = PatientModel(
    id: -1,
    userName: "Add Patient",
    gender: 0,
    birth: "1999.05.10",
    age: 0,
    img: 'assets/images/man.png',
    diagnosis: '',
    diagnosisDate: '',
    surgeryDate: '',
    medication: '',
  );

  //view에서 선택한 유저를 바꾸는 경우 다시 set할 때 사용.
  void setSelectedPatient(PatientModel patient) {
    Logger().i("Change Selected User : ${patient.userName} -> ${patient.id}");
    selectedPatient = patient;
    state = AsyncData(patient); // 상태 업데이트
  }

  //sharedpreference로 가져온 userid로 db에서 PatientModel 가져올 때 사용.
  Future<PatientModel> getSavedPatientDB(userid) async {
    var result = await DatabaseService.getSelectedPatientDB(userid);
    if (result.isNotEmpty) {
      selectedPatient = result[0];
    }
    return selectedPatient;
  }

  // db에서 다시 꺼내오지않고 여기에 저장되어 있는 selectedUser를 view에서 사용.
  PatientModel getSelectedPatient() {
    return selectedPatient;
  }

  // AsyncNotifier의 build() 메서드에서 초기 상태를 비동기적으로 로드
  @override
  Future<PatientModel> build() async {
    state = const AsyncLoading(); // 로딩 상태 설정
    try {
      // 기본적으로 사용자가 저장되어 있는 경우 로드
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? savedPatientId = prefs.getInt('selectedPatientId') ?? 1;
      PatientModel patient = await getSavedPatientDB(savedPatientId);
      state = AsyncData(patient); // 성공 시 데이터 설정
      return patient;
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace); // 오류 처리
      rethrow;
    }
  }
}

final SelectedPatientViewModelProvider =
    AsyncNotifierProvider<SelectedPatientViewModel, PatientModel>(() {
  return SelectedPatientViewModel();
});
