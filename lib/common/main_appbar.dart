import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacking_cone_prototype/common/bluetooth_dialog.dart';
import 'package:stacking_cone_prototype/common/constants/sizes.dart';
import 'package:stacking_cone_prototype/features/game_select/widgets/toggle_button.dart';
import 'package:stacking_cone_prototype/services/bluetooth_service/utils/bluetooth_device_entry.dart';
import 'package:stacking_cone_prototype/services/bluetooth_service/view_models/bluetooth_service.dart';
import 'package:stacking_cone_prototype/services/timer/timer_service.dart';

class MainAppBar extends ConsumerStatefulWidget {
  final bool isSelectScreen;

  const MainAppBar({
    super.key,
    required this.isSelectScreen,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainAppBarState();
}

void onBluetooth(
  BuildContext context,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const BluetoothDialog();
    },
  );
}

class _MainAppBarState extends ConsumerState<MainAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: widget.isSelectScreen
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: IconButton(
                onPressed: () {
                  onBluetooth(context);
                },
                icon: const Icon(
                  FontAwesomeIcons.bluetooth,
                  color: Colors.blue,
                  size: Sizes.size36,
                ),
              ),
            )
          : IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: Sizes.size36,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(timerControllerProvider.notifier).stopTimer();
              },
            ),
      actions: [
        if (widget.isSelectScreen) const ToggleButton(),
      ],
    );
  }
}
