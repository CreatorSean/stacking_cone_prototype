import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacking_cone_prototype/common/constants/gaps.dart';
import 'package:stacking_cone_prototype/common/constants/sizes.dart';
import 'package:stacking_cone_prototype/features/staff/view/patient_add_screen.dart';
import 'package:stacking_cone_prototype/features/staff/view_model/selected_patient_view_model.dart';
import 'package:stacking_cone_prototype/features/staff/view_model/staff_screen_view_model.dart';
import 'package:stacking_cone_prototype/features/staff/widgets/info_container.dart';
import 'package:stacking_cone_prototype/features/staff/widgets/patient_button.dart';
import 'package:stacking_cone_prototype/features/staff/widgets/patient_container.dart';
import 'package:stacking_cone_prototype/services/database/models/patient_model.dart';

class StaffScreen extends ConsumerStatefulWidget {
  static String routeURL = '/staff';
  static String routeName = 'staff';
  const StaffScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StaffScreenState();
}

class _StaffScreenState extends ConsumerState<StaffScreen>
    with TickerProviderStateMixin {
  int _selectedIdx = -1;

  void _onPatientScreenTap() async {
    // final result = await Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => const PatientAddScreen(),
    //   ),
    // );

    // if (result == true) {
    //   _logCurrentPatientInfo();
    // }
  }

  Future<void> selectPatient(
      int idx, PatientModel selectedPatient, bool isChecked) async {
    final prefs = await SharedPreferences.getInstance();
    _selectedIdx = idx;
    if (isChecked) {
      prefs.setInt('selectedPatientId', selectedPatient.id!);
      ref
          .read(SelectedPatientViewModelProvider.notifier)
          .setSelectedPatient(selectedPatient);
    }
    setState(() {});
  }

  void _logCurrentPatientInfo() {
    PatientModel selectedPatient = ref
        .read(SelectedPatientViewModelProvider.notifier)
        .getSelectedPatient();

    Logger().i({
      'id': selectedPatient.id,
      'userName': selectedPatient.userName,
      'gender': selectedPatient.gender,
      'birth': selectedPatient.birth,
      'age': selectedPatient.age,
      'diagnosis': selectedPatient.diagnosis,
      'diagnosisDate': selectedPatient.diagnosisDate,
      'surgeryDate': selectedPatient.surgeryDate,
      'medication': selectedPatient.medication,
      'img': selectedPatient.img,
      'memo': selectedPatient.memo,
    });
  }

  void onDeleteTap(context, int index, List<PatientModel> patientList) {
    if (patientList.length != 1) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          // buttonPadding: const EdgeInsets.all(20),
          actionsAlignment: MainAxisAlignment.spaceAround,
          // actionsOverflowButtonSpacing: 0,
          actionsPadding:
              const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          titlePadding: const EdgeInsets.only(top: 20, left: 20, right: 20),

          title: const Row(
            children: [
              Icon(
                Icons.dangerous,
                color: Colors.red,
              ),
              Text(
                "Delete User",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ],
          ),
          content: SizedBox(
              height: 70,
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Would you like to delete",
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontSize: 18,
                        ),
                  ),
                  Text(
                    "${patientList[index].userName}’s information",
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontSize: 18,
                        ),
                  ),
                ],
              ))),
          actions: <Widget>[
            GestureDetector(
                onTap: () {
                  ref
                      .read(staffScreenViewModelProvider.notifier)
                      .deletePatient(patientList[index]);
                  if (index == patientList.length - 1 && index == index) {
                    ref
                        .read(SelectedPatientViewModelProvider.notifier)
                        .setSelectedPatient(patientList[index - 1]);
                  } else if (index != patientList.length - 1 &&
                      index == index) {
                    ref
                        .read(SelectedPatientViewModelProvider.notifier)
                        .setSelectedPatient(patientList[index + 1]);
                  }
                  Navigator.pop(context);
                },
                child: Text("Yes",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 15,
                        ))),
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text("No",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 15,
                        ))),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding:
              const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          // shape: const RoundedRectangleBorder(
          //     // borderRadius: BorderRadius.all(
          //     //   Radius.circular(5.0),
          //     // ),
          //     ),
          titlePadding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          title: const Row(
            children: [
              Icon(
                Icons.dangerous,
                color: Colors.red,
              ),
              Text(
                "  User deletion failed",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ],
          ),
          content: const SizedBox(
            height: 70,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "The last remaining user",
                  ),
                  Text(
                    "cannot be deleted.",
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text("Close",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 15,
                        ))),
          ],
        ),
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    PatientModel selectedPatient = ref
        .read(SelectedPatientViewModelProvider.notifier)
        .getSelectedPatient();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Staff Screen',
          style: TextStyle(
            color: Color(0xFFF8F9FA),
            fontSize: Sizes.size24,
          ),
        ),
        actions: [
          Stack(
            children: [
              Container(
                color: Colors.white,
              ),
              const Icon(
                FontAwesomeIcons.floppyDisk,
                color: Color(0xFF223A5E),
              )
            ],
          ),
        ],
      ),
      body: ref.watch(staffScreenViewModelProvider).when(
        data: (patientList) {
          return SingleChildScrollView(
            padding: const EdgeInsets.only(
              top: 50,
              left: 20,
              right: 20,
              bottom: 10,
            ),
            child: Column(
              children: [
                InfoContainer(
                  selectedPatient: selectedPatient,
                  isSetting: false,
                ),
                Divider(
                  height: 2,
                  thickness: 0.5,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
                Gaps.v8,
                GestureDetector(
                  onTap: () {
                    _onPatientScreenTap();
                  },
                  child: PatientButton(
                    screenName: PatientAddScreen(
                      patientsList: patientList,
                    ),
                    isAddScreen: false,
                  ),
                ),
                Gaps.v8,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: patientList.length,
                        itemBuilder: (context, index) {
                          return Slidable(
                            endActionPane: ActionPane(
                              extentRatio: 1,
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) =>
                                      onDeleteTap(context, index, patientList),
                                  // onPressed: (context) =>
                                  // onDeletePressed(context, index, userList),
                                  backgroundColor: const Color(0xFFFE4A49),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                ),
                              ],
                            ),
                            child: PatientContainer(
                                    index: index,
                                    selected: _selectedIdx == index,
                                    selectFunc: selectPatient,
                                    context: context,
                                    patient: patientList[index])
                                .animate()
                                .then(delay: (index * 50).ms)
                                .fadeIn(
                                  duration: 300.ms,
                                  curve: Curves.easeInOut,
                                )
                                .flipV(
                                  begin: -0.25,
                                  end: 0,
                                  duration: 300.ms,
                                  curve: Curves.easeInOut,
                                ),
                            // child: UserCard(
                            //   userModel: patientList[index],
                            //   isHome: false,
                            //   index: index,
                            //   selected: _selectedIdx == index,
                            //   selectFunc: selectPatient,
                            // ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        error: (error, stackTrace) {
          return const Scaffold(
            resizeToAvoidBottomInset: false,
            body: Center(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 50,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // 수직 가운데 정렬
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // GestureDetector(
                    //   onTap: () {
                    //     _onPatientScreenTap();
                    //   },
                    //   child: const PatientButton(
                    //     screenName: PatientAddScreen(),
                    //     isAddScreen: false,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          );
          // return Center(
          //   child: Text(
          //     error.toString(),
          //     style: const TextStyle(
          //       fontSize: Sizes.size16,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // );
        },
      ),
    );
  }
}
