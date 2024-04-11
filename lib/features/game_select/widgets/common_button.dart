import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/common/constants/sizes.dart';
import 'package:stacking_cone_prototype/features/game/view_model/cone_stacking_game_vm.dart';
import 'package:stacking_cone_prototype/features/game_select/view_model/game_config_vm.dart';
import 'package:stacking_cone_prototype/services/bluetooth_service/view_models/bluetooth_service.dart';
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
  void _onNextTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget.screenName,
      ),
    );
  }

  void _onStackingGameStartTap() {
    ref.read(gameProvider.notifier).startStackingGame();
    ref
        .read(bluetoothServiceProvider.notifier)
        .onSendData(ref.watch(gameProvider).gameRule);
  }

  void _onLEDGameStartTap() {
    ref.read(gameProvider.notifier).startStackingGame();
    ref
        .read(bluetoothServiceProvider.notifier)
        .onSendData(ref.watch(gameProvider).gameRule);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (ref.read(gameConfigProvider).isTest) {
          ref.read(timerControllerProvider.notifier).startTestTimer();
        } else {
          ref.read(timerControllerProvider.notifier).startTimer();
        }
        if (widget.screenName.toString() == "ConeStackingGameScreen") {
          _onStackingGameStartTap();
          ref.read(gameProvider.notifier).setGameMode("ConeStackingGame");
        }
        if (widget.screenName.toString() == "SingleLedGameScreen") {
          _onLEDGameStartTap();
          ref.read(gameProvider.notifier).setGameMode("SingleLedGame");
        }
        _onNextTap();
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
