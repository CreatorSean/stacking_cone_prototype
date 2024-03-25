import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacking_cone_prototype/common/constants/gaps.dart';
import 'package:stacking_cone_prototype/features/game_select/widgets/toggle_button.dart';

class MainAppBar extends StatelessWidget {
  final bool isSelectScreen;

  const MainAppBar({
    super.key,
    required this.isSelectScreen,
  });

  void onPrchasePressed() {}

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      actions: [
        if (isSelectScreen) const ToggleButton(),
      ],
    );
  }
}
