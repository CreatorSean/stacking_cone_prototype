import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/features/game_select/view_model/game_config_vm.dart';
import 'package:stacking_cone_prototype/services/timer/timer_service.dart';

class StopButton extends ConsumerWidget {
  final Function() showResult;
  final Widget screenName;
  final int answer = 9;
  final int totalCone = 10;

  const StopButton({
    Key? key,
    required this.showResult,
    required this.screenName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 화면 크기에 따른 폰트 크기 조절
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth * 0.05;

    return Visibility(
      visible: !ref.read(gameConfigProvider).isTest,
      child: ElevatedButton(
        onPressed: () {
          ref.read(timerControllerProvider.notifier).stopTimer();
          showResult();
        },
        style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(
              const Color(0xfff0e5c8),
            ),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(
                  color: Color(0xFF332F23),
                  width: 1.5,
                ),
              ),
            ),
            minimumSize: WidgetStateProperty.all(const Size(100, 40))),
        child: Text(
          '그만하기',
          style: TextStyle(
            color: const Color(0xFF332F23),
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
