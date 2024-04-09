import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NegativeLottie extends StatefulWidget {
  final AnimationController controller;
  final int randomIndex;
  final bool showLottieAnimation;
  final Function()? onAnimationComplete; // 애니메이션 완료 시 호출할 콜백 함수

  const NegativeLottie({
    Key? key,
    required this.controller,
    required this.randomIndex,
    required this.showLottieAnimation,
    this.onAnimationComplete,
  }) : super(key: key);

  @override
  _NegativeLottieState createState() => _NegativeLottieState();
}

class _NegativeLottieState extends State<NegativeLottie> {
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
    if (!widget.showLottieAnimation) {
      return const SizedBox.shrink();
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Lottie.asset(
        widget.randomIndex == 1
            ? 'assets/lottie/clap.json'
            : 'assets/lottie/normal.json',
        fit: BoxFit.cover,
        width: 400,
        height: 400,
        controller: widget.controller,
        onLoaded: (composition) {
          if (widget.showLottieAnimation) {
            widget.controller
              ..duration = composition.duration
              ..forward(from: 0);
          }
        },
      ),
    );
  }
}
