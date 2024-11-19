import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/features/staff/widgets/showErrorSnack.dart';
import 'package:stacking_cone_prototype/services/database/database_service.dart';
import 'package:stacking_cone_prototype/services/database/models/patient_model.dart';

class StaffScreenViewModel extends AsyncNotifier<List<PatientModel>> {
  List<PatientModel> patientList = [];

  Future<void> getPatientList() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      patientList = await DatabaseService.getPatientIdListDB();
      return patientList;
    });
  }

  Future<void> insertUser(PatientModel patient) async {
    await AsyncValue.guard(() async {
      // Logger().d("Setting View Model : User insert ${user.userName}");
      DatabaseService.insertDB(patient, "Patients");
    });
    await getPatientList();
  }

  int getUserAge(String birth) {
    int nowYear = DateTime.now().year;
    int nowMonth = DateTime.now().month;
    int nowDay = DateTime.now().day;

    int userYear = int.parse(birth.split(".")[0]);
    int userMonth = int.parse(birth.split(".")[1]);
    int userDay = int.parse(birth.split(".")[2]);

    int userAge = nowYear - userYear;
    if (nowMonth < userMonth) {
      userAge--;
    }

    if (nowMonth == userMonth) {
      if (nowDay < userDay) {
        userAge--;
      }
    }
    return userAge;
  }

  Future<void> insertPatient(BuildContext context) async {
    state = const AsyncValue.loading();
    final form = ref.read(registrationForm);
    final age = getUserAge(form["birth"]);
    String img;
    if (form["gender"] == 1) {
      img = "assets/images/woman.png";
    } else {
      img = "assets/images/man.png";
    }
    PatientModel patient = PatientModel(
      id: null,
      userName: form["userName"],
      gender: form["gender"],
      birth: form["birth"],
      age: age,
      diagnosis: form["diagnosis"],
      diagnosisDate: form["diagnosisDate"],
      surgeryDate: form["surgeryDate"],
      medication: form["medication"],
      img: img,
    );
    await AsyncValue.guard(() async {
      // Logger().d("Setting View Model : User insert ${user.userName}");
      DatabaseService.insertDB(patient, "Patients");
    });
    await getPatientList();
    if (state.hasError) {
      showErrorSnack(context, "모든 항목을 입력해주세요!.");
    } else {
      //Navigator.pop(context);
      //context.goNamed(MainScaffold.routeName);
    }
  }

  Future<void> deletePatient(PatientModel patient) async {
    await AsyncValue.guard(() async {
      // Logger().d("Setting View Model : User delete ${user.userName}");
      DatabaseService.deletePatientDB(patient);
    });
    await getPatientList();
  }

  Future<void> updateUser(PatientModel patient) async {
    await AsyncValue.guard(() async {
      // Logger().d("Setting View Model : User delete ${user.userName}");
      DatabaseService.updatePatientDB(patient);
    });
    await getPatientList();
  }

  @override
  Future<List<PatientModel>> build() async {
    await getPatientList();
    // Logger().i("$StaffScreenViewModel build");
    return patientList;
  }
}

final registrationForm = StateProvider((ref) => {});
final staffScreenViewModelProvider =
    AsyncNotifierProvider<StaffScreenViewModel, List<PatientModel>>(() {
  return StaffScreenViewModel();
});
