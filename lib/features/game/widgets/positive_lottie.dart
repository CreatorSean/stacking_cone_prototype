import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PositiveLottie extends StatefulWidget {
  final AnimationController controller;
  final int randomIndex;
  final bool showLottieAnimation;
  final Function()? onAnimationComplete; // 애니메이션 완료 시 호출할 콜백 함수

  const PositiveLottie({
    Key? key,
    required this.controller,
    required this.randomIndex,
    required this.showLottieAnimation,
    this.onAnimationComplete,
  }) : super(key: key);

  @override
  _PositiveLottieState createState() => _PositiveLottieState();
}

class _PositiveLottieState extends State<PositiveLottie> {
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
    //lottie false이면 애니메이션 제거
    if (!widget.showLottieAnimation) {
      return SizedBox.shrink();
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Lottie.asset(
        widget.randomIndex == 1
            ? 'assets/lottie/okay.json'
            : 'assets/lottie/confetti.json',
        fit: BoxFit.cover,
        width: 400,
        height: 400,
        controller: widget.controller,
        onLoaded: (composition) {
          // 애니메이션의 실행 여부 확인 후 실행
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
