import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:stacking_cone_prototype/services/database/database_service.dart';
import 'package:stacking_cone_prototype/services/database/models/patient_model.dart';

class SelectedPatientViewModel extends AsyncNotifier<PatientModel> {
  PatientModel selectedPatient = PatientModel(
    id: -1,
    userName: "노시헌",
    gender: 0,
    birth: "1999.05.10",
    age: 25,
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
  }

  //sharedprefernce로 가져온 userid로 db에서 PatientModel 가져올 때 사용.
  Future<PatientModel> getSavedPatientDB(userid) async {
    await DatabaseService.getSelectedPatientDB(userid)
        .then((value) => {if (value.isNotEmpty) selectedPatient = value[0]});
    return selectedPatient;
  }

  // db에서 다시 꺼내오지않고 여기에 저장되어 있는 selectedUser를 view에서 사용.
  PatientModel getSelectedPatient() {
    return selectedPatient;
  }

  @override
  FutureOr<PatientModel> build() {
    getSelectedPatient();
    return selectedPatient;
  }
}

final SelectedPatientViewModelProvider =
    AsyncNotifierProvider<SelectedPatientViewModel, PatientModel>(() {
  return SelectedPatientViewModel();
});
