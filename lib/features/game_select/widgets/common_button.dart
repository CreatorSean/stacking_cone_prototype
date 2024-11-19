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
  void _showConfirmationDialog(bool isConnecting) {
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
    } else {
      if (isConnecting) {
        ref.read(bluetoothServiceProvider.notifier).doCalibration('C');
      } else {
        showErrorSnack(context, '블루투스 연결이 필요합니다!');
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isConnecting =
        ref.watch(bluetoothServiceProvider.notifier).isConnecting;

    // 버튼 색상을 조건에 따라 설정
    final buttonColor =
        (isConnecting == false) ? Colors.grey : Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: () {
        _showConfirmationDialog(isConnecting);
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
            color: buttonColor,
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
  }
}
