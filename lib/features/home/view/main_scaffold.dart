import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacking_cone_prototype/common/password_dialog.dart';
import 'package:stacking_cone_prototype/features/game_select/view/game_select_screen.dart';
import 'package:stacking_cone_prototype/features/result/view/result_screen.dart';
import 'package:stacking_cone_prototype/features/staff/view/user_screen.dart';
import 'package:stacking_cone_prototype/features/staff/view_model/selected_patient_view_model.dart';
import 'package:stacking_cone_prototype/services/database/models/patient_model.dart';

import '../../staff/widgets/showErrorSnack.dart';

class MainScaffold extends ConsumerStatefulWidget {
  static const routeName = 'home';
  static const routeURL = '/home';

  const MainScaffold({
    super.key,
  });

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {
  int _selectedPageIndex = 0;

  final List<Widget> _pageScreen = <Widget>[
    const GameSelectScreen(),
    const ResultScreen(),
    const UserScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      // Show password dialog when Staff tab is clicked
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return PasswordDialog(
            onPasswordSubmitted: (password) {
              // Implement your password check logic here
              if (password == '1111') {
                setState(() {
                  _selectedPageIndex = index;
                });
              } else {
                showErrorSnack(context, "비밀번호를 다시 입력해주세요!.");
              }
            },
          );
        },
      );
    } else {
      setState(() {
        _selectedPageIndex = index;
      });
    }
  }

  Future<void> initUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? savedPatientId = prefs.getInt('selectedPatientId') ?? 1;
    Logger().i("initPatient");
    PatientModel user = await ref
        .read(SelectedPatientViewModelProvider.notifier)
        .getSavedPatientDB(savedPatientId);
    ref
        .read(SelectedPatientViewModelProvider.notifier)
        .setSelectedPatient(user);
  }

  Future<void> initPermission() async {
    await Permission.bluetooth.request();
    await Permission.bluetoothConnect.request();
    await Permission.bluetoothScan.request();
    await Permission.location.request();
  }

  @override
  void initState() {
    super.initState();
    initUser();
    initPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageScreen[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.stethoscope,
              size: 35,
            ),
            label: 'Game',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.clipboard,
              size: 35,
            ),
            label: 'Result',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.user,
              size: 35,
            ),
            label: 'Staff',
          ),
        ],
        currentIndex: _selectedPageIndex, // 지정 인덱스로 이동
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped, // 선언했던 onItemTapped
      ),
    );
  }
}
