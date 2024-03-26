import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class TimerContainer extends ConsumerStatefulWidget {
  final int maxTime;
  final int currentTime;
  final bool isTimerShow;
  const TimerContainer({
    super.key,
    required this.maxTime,
    required this.currentTime,
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
          currentTime =
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
    final isTimerShow = widget.isTimerShow;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform.translate(
          offset: const Offset(-20, 0),
          child: Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Transform.scale(
              scale: 2.2,
              child: Lottie.asset(
                "assets/lottie/hourglass.json",
                width: 100,
                height: 100,
                controller: _controller,
              )..controller,
            ),
          ),
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  widget.currentTime.toString(),
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ).animate(
                onComplete: (controller) {
                  controller.repeat(reverse: true);
                },
              ).scaleXY(
                begin: 1,
                end: 1.2,
                duration: 250.ms,
                curve: Curves.easeInOutCubic,
              ),
            ),
            SizedBox(
              width: 90,
              height: 90,
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor.withOpacity(0.3),
                strokeWidth: 10,
                value: 1.0,
              ),
            ),
            SizedBox(
              width: 90,
              height: 90,
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
                strokeWidth: 10,
                value: currentTime / widget.maxTime,
              ),
            ),
          ],
        ),
      ],
    )
        .animate(target: isTimerShow ? 1 : 0)
        .fadeIn(
          begin: 0,
          duration: 500.ms,
          curve: Curves.easeInOut,
        )
        .slideY(
          begin: 1,
          end: 0,
        );
  }
}
