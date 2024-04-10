import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/features/game_select/view_model/game_config_vm.dart';
import 'package:stacking_cone_prototype/services/timer/timer_service.dart';

class TimerContainer extends ConsumerStatefulWidget {
  final bool isTimerShow;
  final bool isGameStop;
  const TimerContainer({
    super.key,
    this.isGameStop = false,
    this.isTimerShow = false,
  });
  @override
  ConsumerState<TimerContainer> createState() => _TimerContainerState();
}

class _TimerContainerState extends ConsumerState<TimerContainer>
    with TickerProviderStateMixin {
  late double currentTime;
  late double time;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          ref.read(gameConfigProvider).isTest ? "남은 시간: " : "훈련 시간: ",
          style: Theme.of(context).textTheme.labelSmall,
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 90,
              height: 90,
              child: Center(
                child: Text(
                  ref.watch(timerControllerProvider).time.toString(),
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ).animate(
                onComplete: (controller) {
                  controller.repeat(reverse: true);
                },
              ).scaleXY(
                begin: 1,
                end: 1,
                duration: 250.ms,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
