import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacking_cone_prototype/common/constants/gaps.dart';
import 'package:stacking_cone_prototype/common/constants/sizes.dart';
import 'package:stacking_cone_prototype/features/game_select/widgets/toggle_button.dart';

class MainAppBar extends StatelessWidget {
  final bool isSelectScreen;

  const MainAppBar({
    super.key,
    required this.isSelectScreen,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: isSelectScreen
          ? null
          : IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: Sizes.size36,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
      actions: [
        if (isSelectScreen) const ToggleButton(),
      ],
    );
  }
}
