import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacking_cone_prototype/common/bluetooth_dialog.dart';
import 'package:stacking_cone_prototype/common/constants/sizes.dart';
import 'package:stacking_cone_prototype/common/dispose_connection_dialog.dart';
import 'package:stacking_cone_prototype/features/game_select/widgets/toggle_button.dart';
import 'package:stacking_cone_prototype/features/staff/widgets/showErrorSnack.dart';
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

void onBluetooth(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const BluetoothDialog();
    },
  );
}

void onDispose(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const DisposeConnectionDialog();
    },
  );
}

class _MainAppBarState extends ConsumerState<MainAppBar> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(bluetoothServiceProvider).when(
          data: (data) {
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
                        icon: Icon(
                          FontAwesomeIcons.bluetooth,
                          color: (data.isConnecting == false)
                              ? Colors.grey
                              : Colors.blue,
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
                if (widget.isSelectScreen)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: IconButton(
                      icon: const Icon(
                        FontAwesomeIcons.plugCircleExclamation,
                        color: Colors.black,
                        size: Sizes.size36,
                      ),
                      onPressed: () {
                        if (data.isConnecting == true) {
                          onDispose(context);
                        } else {
                          showErrorSnack(context, '블루수트가 연결되어 있지 않습니다!');
                        }
                      },
                    ),
                  ),
                if (widget.isSelectScreen) const ToggleButton(),
              ],
            );
          },
          error: (err, stack) => Text("Error: $err"),
          loading: () => const CircularProgressIndicator(),
        );
  }
}
