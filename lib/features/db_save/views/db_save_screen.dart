import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'package:stacking_cone_prototype/common/constants/gaps.dart';
import 'package:stacking_cone_prototype/common/main_appbar.dart';
import 'package:stacking_cone_prototype/features/db_save/view_model/db_screen_view_model.dart';
import 'package:stacking_cone_prototype/services/database/models/patient_model.dart';

import '../../../services/database/database_service.dart';
import '../widgets/db_button.dart';

class DbSaveScreen extends ConsumerStatefulWidget {
  const DbSaveScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DbSaveScreenState();
}

class _DbSaveScreenState extends ConsumerState<DbSaveScreen> {
  String? _selectedPatient;

  @override
  Widget build(BuildContext context) {
    return ref.watch(dbScreenViewModelProvider).when(
      data: (patientsList) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: MainAppBar(
              isSelectScreen: false,
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Save Database",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              Gaps.v150,
              DropdownButton<String>(
                value: _selectedPatient,
                items: patientsList.map((patient) {
                  return DropdownMenuItem<String>(
                    value: patient.userName, // value에 userName 설정
                    child: Text(patient
                        .userName), // DropdownMenuItem의 child로 userName 텍스트 설정
                  );
                }).toList(), // List<DropdownMenuItem<String>>로 변환
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPatient = newValue; // 선택된 값 업데이트
                  });
                },
              ),
              Gaps.v32,
              const DbButton(
                buttonName: "DB 저장",
              ),
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
