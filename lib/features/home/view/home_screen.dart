import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:stacking_cone_prototype/common/main_navigator_screen.dart';
import 'package:stacking_cone_prototype/features/game_select/view/game_select_screen.dart';
import 'package:stacking_cone_prototype/features/staff/view/staff_screen.dart';

class HomeScreen extends StatefulWidget {
  static String routeURL = '/home';
  static String routeName = 'home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  void changePage(int index) {
    _currentPage = index;
    _pageController.animateToPage(
      index,
      duration: 1.ms,
      curve: Curves.linear,
    );

    setState(() {});
  }

  String getTitle(int pageIdx) {
    if (pageIdx == 0) {
      return "Game Select";
    } else {
      return "For Staff";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B303A),
      body: PageView(
        controller: _pageController,
        onPageChanged: changePage,
        children: const [
          GameSelectScreen(),
          StaffScreen(),
        ],
      ),
      bottomNavigationBar: MainNavigator(
        page: _currentPage,
        changeFunc: changePage,
      ),
    );
  }
}
