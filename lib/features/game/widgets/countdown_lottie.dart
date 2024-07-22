import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CountdownLottie extends StatefulWidget {
  final AnimationController controller;
  final Function()? onAnimationComplete;

  const CountdownLottie({
    Key? key,
    required this.controller,
    this.onAnimationComplete,
  }) : super(key: key);

  @override
  _CountdownLottieState createState() => _CountdownLottieState();
}

class _CountdownLottieState extends State<CountdownLottie> {
  @override
  void initState() {
    super.initState();
    widget.controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationComplete?.call();
      }
    });
  }

  @override
  void dispose() {
    widget.controller.removeStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationComplete?.call();
      }
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/lottie/countdown.json',
        controller: widget.controller,
        onLoaded: (composition) {
          widget.controller
            ..duration = composition.duration
            ..forward(from: 0);
        },
      ),
    );
  }
}
