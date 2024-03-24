import 'package:flutter/material.dart';
import 'package:stacking_cone_prototype/common/constants/gaps.dart';
import 'package:stacking_cone_prototype/features/game_select/widgets/toggle_button.dart';

class MainAppBar extends StatelessWidget {
  const MainAppBar({
    super.key,
  });
  void onPrchasePressed() {}
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      actions: const [
        Gaps.v48,
        ToggleButton(),
      ],
    );
  }
}
