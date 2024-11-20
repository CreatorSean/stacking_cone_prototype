import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/common/constants/sizes.dart';
import 'package:stacking_cone_prototype/features/game/widgets/game_confirmation_dialog_widget.dart';
import 'package:stacking_cone_prototype/features/game_select/view_model/game_config_vm.dart';
import 'package:stacking_cone_prototype/features/staff/widgets/showErrorSnack.dart';
import 'package:stacking_cone_prototype/services/timer/timer_service.dart';

import '../../../services/bluetooth_service/view_models/bluetooth_service.dart';

class CommonButton extends ConsumerStatefulWidget {
  final Widget screenName;
  final String buttonName;

  const CommonButton({
    super.key,
    required this.screenName,
    required this.buttonName,
  });

  @override
  ConsumerState<CommonButton> createState() => _CommonButtonState();
}

class _CommonButtonState extends ConsumerState<CommonButton> {
  Color btnColor = Colors.grey;
  void _showConfirmationDialog(bool isConnecting, bool isCalibrating) {
    if (!isConnecting) {
      showErrorSnack(context, '블루투스 연결이 필요합니다!');
      return;
    }
    if (!isCalibrating) {
      if (widget.buttonName == '운동 재활' || widget.buttonName == '인지 재활') {
        showErrorSnack(context, '캘리브레이션을 진행해주세요!');
        return;
      }
    }
    if (widget.buttonName == '운동 재활' || widget.buttonName == '인지 재활') {
      if (ref.watch(gameConfigProvider).isTest == true) {
        ref.watch(timerControllerProvider.notifier).setTimerTime(10);
      }
      ref.read(gameConfigProvider.notifier).setMode(false);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return GameConfirmationDialog(
              screenName: widget.screenName,
              gameName: widget.buttonName,
            );
          },
        );
      });
      return;
    }
    ref.read(bluetoothServiceProvider.notifier).doCalibration('C');
    setState(() {});
  }

  void getColor(bool isConnecting, bool isCalibrating) {
    if (!isConnecting) {
      btnColor = Colors.grey;
    } else {
      if (!isCalibrating) {
        if (widget.buttonName == '운동 재활' || widget.buttonName == '인지 재활') {
          btnColor = Colors.grey;
        } else if (widget.buttonName == 'Calibration') {
          btnColor = Theme.of(context).primaryColor;
        } else {
          btnColor = Colors.grey;
        }
      } else {
        if (widget.buttonName == '운동 재활' || widget.buttonName == '인지 재활') {
          btnColor = Theme.of(context).primaryColor;
        } else if (widget.buttonName == 'Calibration') {
          btnColor = Theme.of(context).primaryColor;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(bluetoothServiceProvider).when(
          data: (data) {
            print(
                'connection : ${data.isConnecting}, calibration : ${data.isCalibrating}');
            getColor(data.isConnecting!, data.isCalibrating!);
            return GestureDetector(
              onTap: () {
                _showConfirmationDialog(
                    data.isConnecting!, data.isCalibrating!);
              },
              child: FractionallySizedBox(
                widthFactor: 0.6,
                child: AnimatedContainer(
                  height: 70,
                  padding: const EdgeInsets.symmetric(
                    vertical: Sizes.size16,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Sizes.size20),
                    color: btnColor,
                  ),
                  duration: const Duration(
                    milliseconds: 300,
                  ),
                  child: AnimatedDefaultTextStyle(
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    duration: const Duration(
                      milliseconds: 300,
                    ),
                    child: Text(
                      widget.buttonName,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                ),
              ),
            );
          },
          error: (err, stack) => Text("Error: $err"),
          loading: () => const CircularProgressIndicator(),
        );
  }
}
