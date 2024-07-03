import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stacking_cone_prototype/features/home/view/home_screen.dart';
import 'package:stacking_cone_prototype/features/home/view/main_scaffold.dart';
import 'package:stacking_cone_prototype/features/staff/view/staff_screen.dart';
import 'package:stacking_cone_prototype/features/staff/widgets/showErrorSnack.dart';
import 'package:stacking_cone_prototype/services/database/database_service.dart';
import 'package:stacking_cone_prototype/services/database/models/patient_model.dart';

class RegistrationViewModel extends AsyncNotifier<List<PatientModel>> {
  List<PatientModel> patientList = [];

  Future<void> getPatientList() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      patientList = await DatabaseService.getPatientIdListDB();
      return patientList;
    });
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
    );

    await AsyncValue.guard(() async {
      DatabaseService.insertDB(patient, "Patients");
    });
    await getPatientList();
    if (state.hasError) {
      showErrorSnack(context);
    } else {
      Navigator.pop(context);
      context.goNamed(MainScaffold.routeName);
    }
  }

  @override
  FutureOr<List<PatientModel>> build() async {
    await getPatientList();
    return patientList;
  }
}

final registrationForm = StateProvider((ref) => {});

final registrationProvider =
    AsyncNotifierProvider<RegistrationViewModel, List<PatientModel>>(() {
  return RegistrationViewModel();
});
