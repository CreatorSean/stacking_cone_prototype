import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'package:stacking_cone_prototype/common/constants/gaps.dart';
import 'package:stacking_cone_prototype/common/main_appbar.dart';
import 'package:stacking_cone_prototype/features/db_save/view_model/db_screen_view_model.dart';
import '../widgets/db_button.dart';

class DbSaveScreen extends ConsumerStatefulWidget {
  const DbSaveScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DbSaveScreenState();
}

class _DbSaveScreenState extends ConsumerState<DbSaveScreen> {
  String? _selectedPatient; // Nullable로 변경하여 초기 상태에서 선택되지 않은 상태를 나타냄

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return ref.watch(dbScreenViewModelProvider).when(
      data: (patientsList) {
        return Scaffold(
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: MainAppBar(
              isSelectScreen: false,
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Save Database",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Gaps.v64,
                SizedBox(
                  width: width * 0.7,
                  height: height * 0.1,
                  child: DropdownSearch<String>(
                    items: patientsList
                        .map((patient) => patient.userName)
                        .toList(),
                    dropdownDecoratorProps: const DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "환자를 선택해주세요",
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedPatient = newValue;
                      });
                    },
                    selectedItem: _selectedPatient,
                  ),
                ),
                Gaps.v64,
                DbButton(
                  buttonName: "DB 저장",
                  patientName: _selectedPatient,
                ),
              ],
            ),
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
