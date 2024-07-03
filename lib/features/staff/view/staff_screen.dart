import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stacking_cone_prototype/common/constants/gaps.dart';
import 'package:stacking_cone_prototype/features/staff/view/patient_add_screen.dart';
import 'package:stacking_cone_prototype/features/staff/view_model/patient_load_view_model.dart';
import 'package:stacking_cone_prototype/features/staff/view_model/registration_view_model.dart';
import 'package:stacking_cone_prototype/features/staff/widgets/patient_button.dart';
import 'package:stacking_cone_prototype/features/staff/widgets/patient_container.dart';

class StaffScreen extends ConsumerStatefulWidget {
  static String routeURL = '/staff';
  static String routeName = 'staff';
  const StaffScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StaffScreenState();
}

class _StaffScreenState extends ConsumerState<StaffScreen> {
  void _onPatientScreenTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PatientAddScreen(),
      ),
    );
    //context.goNamed(PatientAddScreen.routeName);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ref.watch(registrationProvider).when(
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
                GestureDetector(
                  onTap: () {
                    _onPatientScreenTap();
                  },
                  child: const PatientButton(
                    screenName: PatientAddScreen(),
                    isAddScreen: false,
                  ),
                ),
                Gaps.v16,
                Row(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: patientList.length,
                        itemBuilder: (context, index) {
                          return PatientContainer(
                              idx: index,
                              context: context,
                              patient: patientList[index]);
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
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 50,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // 수직 가운데 정렬
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _onPatientScreenTap();
                      },
                      child: const PatientButton(
                        screenName: PatientAddScreen(),
                        isAddScreen: false,
                      ),
                    ),
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
