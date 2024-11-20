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

  // timeInSeconds로 실행 시간 받아와서 60초 넘으면 형식 변경
  String formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;

    if (minutes > 0) {
      return '$minutes분 $seconds초';
    } else {
      return '$seconds초';
    }
  }

  @override
  Widget build(BuildContext context) {
    final int timeInSeconds = ref.watch(timerControllerProvider).time;

    // 화면 크기에 따른 폰트 크기 조절
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth * 0.04;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(
          width: 20,
        ),
        Text(
          ref.read(gameConfigProvider).isTest ? "남은 시간:" : "훈련 시간:",
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 90,
              height: 90,
              child: Center(
                child: Text(
                  formatTime(timeInSeconds),
                  style: TextStyle(
                    fontSize: fontSize,
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
