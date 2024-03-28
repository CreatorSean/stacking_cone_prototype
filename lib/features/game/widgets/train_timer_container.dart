import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  int time = 0;
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
          time++;
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "훈련 시간 :",
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
                  //widget.currentTime.toString(),
                  time.toString(),
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
