import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/common/constants/sizes.dart';
import 'package:stacking_cone_prototype/features/game/widgets/game_confirmation_dialog_widget.dart';
import 'package:stacking_cone_prototype/features/game_select/view_model/game_config_vm.dart';
import 'package:stacking_cone_prototype/services/timer/timer_service.dart';

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
  void _showConfirmationDialog() {
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => widget.screenName,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // if (ref.read(gameConfigProvider).isTest) {
        //   ref.read(timerControllerProvider.notifier).startTestTimer();
        // } else {
        //   ref.read(timerControllerProvider.notifier).startTimer();
        // }

        _showConfirmationDialog();
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
            color: Theme.of(context).primaryColor,
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
