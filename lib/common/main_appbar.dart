import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/common/constants/sizes.dart';
import 'package:stacking_cone_prototype/features/game_select/widgets/toggle_button.dart';

class MainAppBar extends ConsumerStatefulWidget {
  final bool isSelectScreen;

  const MainAppBar({
    super.key,
    required this.isSelectScreen,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainAppBarState();
}

class _MainAppBarState extends ConsumerState<MainAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: widget.isSelectScreen
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
        if (widget.isSelectScreen) const ToggleButton(),
      ],
    );
  }
}
