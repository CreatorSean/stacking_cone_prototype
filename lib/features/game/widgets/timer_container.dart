import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/features/game/view_model/current_time_vm.dart';
import 'package:stacking_cone_prototype/features/game_select/view_model/game_config_vm.dart';

class TimerContainer extends ConsumerStatefulWidget {
  final double maxTime;
  final bool isTimerShow;
  const TimerContainer({
    super.key,
    required this.maxTime,
    this.isTimerShow = false,
  });
  @override
  ConsumerState<TimerContainer> createState() => _TimerContainerState();
}

class _TimerContainerState extends ConsumerState<TimerContainer>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _circleController;
  late double currentTime;
  late double time;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    currentTime = widget.maxTime.toDouble();
    ref.read(timeProvider.notifier).state = currentTime;
    time = 0;

    _controller = AnimationController(
      duration: (1.25).seconds,
      vsync: this,
    )
      ..addListener(() {
        setState(() {});
      })
      ..repeat();
    _circleController = AnimationController(
      duration: widget.maxTime.seconds,
      vsync: this,
    )
      ..addListener(() {
        setState(() {
          if (ref.read(gameConfigProvider).isTest) {
            currentTime =
                widget.maxTime - _circleController.value * widget.maxTime;
            if (currentTime == 0) {
              ref.read(timeProvider.notifier).state = 0;
            }
          }
        });
      })
      ..forward();

    if (!ref.read(gameConfigProvider).isTest) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            time++;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _circleController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          ref.read(gameConfigProvider).isTest ? "남은 시간" : "훈련 시간",
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
                  ref.read(gameConfigProvider).isTest
                      ? currentTime.toInt().toString()
                      : time.toInt().toString(),
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
