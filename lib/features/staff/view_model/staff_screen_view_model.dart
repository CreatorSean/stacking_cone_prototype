import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/services/database/database_service.dart';
import 'package:stacking_cone_prototype/services/database/models/patient_model.dart';

class StaffScreenViewModel extends AsyncNotifier<List<PatientModel>> {
  List<PatientModel> userList = [];

  Future<void> getUserList() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // print("Get User List View Model");
      userList = await DatabaseService.getPatientIdListDB();
      return userList;
    });
  }

  Future<void> insertUser(PatientModel patient) async {
    await AsyncValue.guard(() async {
      // Logger().d("Setting View Model : User insert ${user.userName}");
      DatabaseService.insertDB(patient, "Patients");
    });
    await getUserList();
  }

  Future<void> deleteUser(PatientModel patient) async {
    await AsyncValue.guard(() async {
      // Logger().d("Setting View Model : User delete ${user.userName}");
      DatabaseService.deleteDB(patient, "Patients");
    });
    await getUserList();
  }

  Future<void> updateUser(PatientModel patient) async {
    await AsyncValue.guard(() async {
      // Logger().d("Setting View Model : User delete ${user.userName}");
      DatabaseService.updatePatientDB(patient);
    });
    await getUserList();
  }

  @override
  Future<List<PatientModel>> build() async {
    await getUserList();
    // Logger().i("$StaffScreenViewModel build");
    return userList;
  }
}

final StaffScreenViewModelProvider =
    AsyncNotifierProvider<StaffScreenViewModel, List<PatientModel>>(() {
  return StaffScreenViewModel();
});
