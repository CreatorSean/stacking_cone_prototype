import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacking_cone_prototype/common/constants/sizes.dart';
import 'package:stacking_cone_prototype/common/my_scrolll_behavior.dart';
import 'package:stacking_cone_prototype/features/staff/view/patient_add_screen.dart';
import 'package:stacking_cone_prototype/features/staff/view_model/selected_patient_view_model.dart';
import 'package:stacking_cone_prototype/features/staff/view_model/staff_screen_view_model.dart';
import 'package:stacking_cone_prototype/features/staff/widgets/info_container.dart';
import 'package:stacking_cone_prototype/features/staff/widgets/patient_container.dart';
import 'package:stacking_cone_prototype/features/staff/widgets/user_card.dart';
import 'package:stacking_cone_prototype/services/database/models/patient_model.dart';

class UserScreen extends ConsumerStatefulWidget {
  const UserScreen({super.key});

  @override
  ConsumerState<UserScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<UserScreen>
    with TickerProviderStateMixin {
  int _selectedIdx = -1;
  // late final AnimationController _controller;

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

  // void makeFakeRecord(UserModel selectedUser) {
  //   DateTime dateTime = DateTime(2023, 10, 1, 15, 23, 58, 0, 0);

  //   RecordModel fake_1 = RecordModel(
  //     id: null,
  //     userId: selectedUser.id!,
  //     date: dateTime.microsecondsSinceEpoch,
  //     mode: 0,
  //     score: Random().nextInt(20) + 60,
  //     xList: "[0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5]",
  //     yList: "[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]",
  //   );
  //   DatabaseService.insertDB(fake_1, "Records");
  // }

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
                "  Delete User",
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

  void onAddPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PatientAddScreen(),
      ),
    );
    //context.goNamed(PatientAddScreen.routeName);
  }

  // void onModifyPressed(UserModel user) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => const UserAddScreen(isAdd: false),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    PatientModel selectedPatient = ref
        .read(SelectedPatientViewModelProvider.notifier)
        .getSelectedPatient();
    return ref.watch(staffScreenViewModelProvider).when(
      data: (userList) {
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
          ),
          body: Column(
            children: [
              InfoContainer(
                isSetting: true,
                selectedPatient: selectedPatient,
              ),
              Divider(
                height: 2,
                thickness: 0.5,
                color: Theme.of(context).secondaryHeaderColor,
              ),
              Container(
                padding: const EdgeInsets.only(left: 15, bottom: 5, right: 5),
                height: screenHeight * 0.053,
                color: Theme.of(context).hoverColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Patients",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: screenHeight * 0.035),
                    ),
                    IconButton(
                      onPressed: onAddPressed,
                      icon: Icon(
                        Icons.add,
                        size: screenWidth * 0.08,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 2,
                thickness: 0.5,
                color: Theme.of(context).secondaryHeaderColor,
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      return Slidable(
                        endActionPane: ActionPane(
                          extentRatio: 1,
                          motion: const ScrollMotion(),
                          children: [
                            // SlidableAction(
                            //   onPressed: (context) =>
                            //       onModifyPressed(userList[index]),
                            //   backgroundColor: Colors.blue,
                            //   foregroundColor: Colors.white,
                            //   icon: Icons.edit,
                            // ),
                            SlidableAction(
                              onPressed: (context) =>
                                  onDeleteTap(context, index, userList),
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
                          patient: userList[index],
                        )
                            .animate()
                            .fadeIn(
                              begin: 0,
                              duration: 500.ms,
                            )
                            .slideX(
                              begin: -1,
                              end: 0,
                              duration: 300.ms,
                              curve: Curves.easeInOut,
                            ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        );
      },
      error: (error, stackTrace) {
        return Column(
          children: [
            const Text("An error occurred while retrieving user information."),
            Text("err: $error"),
            Text("stackTrace: $stackTrace"),
          ],
        );
      },
      loading: () {
        return const Center(
          child: CupertinoActivityIndicator(),
        );
      },
    );
  }
}
