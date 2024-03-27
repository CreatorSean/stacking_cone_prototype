import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/features/game/view_model/current_time_vm.dart';

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
  @override
  void initState() {
    super.initState();
    currentTime = widget.maxTime.toDouble();
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
          ref.read(currentTimeProvider.notifier).state =
              widget.maxTime - _circleController.value * widget.maxTime;
        });
      })
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _circleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 90,
              height: 90,
              child: Center(
                child: Text(
                  //widget.currentTime.toString(),
                  ref.watch(currentTimeProvider).toInt().toString(),
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
