import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacking_cone_prototype/features/game_select/view/game_select_screen.dart';
import 'package:stacking_cone_prototype/features/staff/view/staff_screen.dart';

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
  int _selectedPageIndex = 1;

  final List<Widget> _pageScreen = <Widget>[
    const GameSelectScreen(),
    const StaffScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  // Future<void> initUser() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   int? savedUserId = prefs.getInt('selectedUserId') ?? 1;
  //   Logger().i("initUser");
  //   UserModel user = await ref
  //       .read(selectedUserViewModelProvider.notifier)
  //       .getSavedUserDB(savedUserId);
  //   ref.read(selectedUserViewModelProvider.notifier).setSelectedUser(user);
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   initUser();
  // }

  @override
  Widget build(BuildContext context) {
    final List<String> titleList = <String>[
      "Game",
      "Staff",
    ];

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
