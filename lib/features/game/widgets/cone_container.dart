import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/services/bluetooth_service/view_models/bluetooth_service.dart';

import '../view_model/cone_stacking_game_vm.dart';

class ConeContainer extends ConsumerStatefulWidget {
  final Function() trueLottie;
  final Function() falseLottie;
  const ConeContainer({
    super.key,
    required this.trueLottie,
    required this.falseLottie,
  });

  @override
  ConsumerState<ConeContainer> createState() => _ConeContainerState();
}

class _ConeContainerState extends ConsumerState<ConeContainer>
    with TickerProviderStateMixin {
  List<int> changedIndices = [0];

  List<int> coneMatrix = [0, 0, 0, 0, 0, 0, 0, 0, 0];

  late AnimationController _borderAnimationController;
  late Animation<Color?> _borderColorAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 테두리 애니메이션 컨트롤러 초기화
    _borderAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // 애니메이션 한 사이클의 지속 시간
    );

    // 색상 변화 애니메이션 생성
    _borderColorAnimation = ColorTween(
      begin: Colors.black,
      end: Colors.red, // 테두리가 깜박일 때의 색상
    ).animate(_borderAnimationController);

    // 애니메이션을 계속 반복
    _borderAnimationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _borderAnimationController.dispose();
    super.dispose();
  }

  void stackCone(int index) {
    setState(() {
      coneMatrix[index]++;
    });
  }

  void resetCone(int index) {
    setState(() {
      coneMatrix[index] = 0;
    });
  }

  List<int> detectChangesAndReturnIndices(
      List<int> oldList, List<int> newList) {
    List<int> changedIndices = [];

    for (int i = 0; i < oldList.length; i++) {
      if (oldList[i] != newList[i] && oldList[i] < newList[i]) {
        changedIndices.clear();
        changedIndices.add(i);
      }
    }

    return changedIndices;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          double containerSize = constraints.maxWidth * 0.8; // 부모 위젯의 80% 크기

          return Container(
            width: containerSize,
            height: containerSize, // 정사각형으로 만듭니다.
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF332F23),
                width: 1.5,
              ),
            ),
            child: ref.watch(bluetoothServiceProvider).when(
                  data: (btModel) {
                    List<int> changedIndices = detectChangesAndReturnIndices(
                        coneMatrix, btModel.coneMatrixMsg);
                    if (changedIndices.isNotEmpty) {
                      if (changedIndices[0] ==
                          ref.watch(gameProvider).targetIndex) {
                        widget.trueLottie();
                      } else {
                        widget.falseLottie();
                      }
                    }

                    coneMatrix = btModel.coneMatrixMsg;
                    return GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      childAspectRatio: 1.0,
                      children: List.generate(
                        9,
                        (index) {
                          return _buildGridItem(context, index);
                        },
                      ),
                    );
                  },
                  error: (error, stackTrace) => const Text('Error'),
                  loading: () => const CircularProgressIndicator(),
                ),
          );
        },
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, int index) {
    return GestureDetector(
      // onTap: () {
      //   stackCone(index);
      // },
      // onLongPress: () {
      //   resetCone(index);
      // },
      child: Stack(
        children: [
          if (index != ref.watch(gameProvider).targetIndex)
            Container(
              decoration: BoxDecoration(
                color: index == ref.watch(gameProvider).targetIndex
                    ? const Color.fromARGB(255, 105, 221, 238)
                    : const Color.fromARGB(255, 176, 233, 247),
                border: Border.all(
                  color: Colors.black,
                  width: 1.5,
                ),
              ),
            ),
          if (index == ref.watch(gameProvider).targetIndex)
            AnimatedBuilder(
              animation: _borderAnimationController,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    color: index == ref.watch(gameProvider).targetIndex
                        ? const Color.fromARGB(255, 13, 204, 233)
                        : const Color.fromARGB(255, 81, 184, 231),
                    border: Border.all(
                      color: index == ref.watch(gameProvider).targetIndex
                          ? _borderColorAnimation.value ?? Colors.white
                          : Colors.white,
                      width: 7.0,
                    ),
                  ),
                );
              },
            ),
          if (coneMatrix[index] > 0)
            Positioned.fill(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: index == ref.watch(gameProvider).targetIndex
                          ? Colors.transparent
                          : Colors.red.withOpacity(0.5),
                    ),
                  )
                      .animate(
                        target: index != ref.watch(gameProvider).targetIndex
                            ? 1
                            : 0,
                        onComplete: (controller) {
                          if (index != ref.watch(gameProvider).targetIndex) {
                            controller.forward(from: 0);
                          }
                        },
                      )
                      .color(
                        delay: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        begin: Colors.transparent,
                        end: Colors.red.withOpacity(0.7),
                      ),
                  Image.asset(
                    'assets/images/redcone.png', // 이미지 경로를 설정하세요.
                    width: 180,
                    height: 180,
                  ),
                  Text(
                    '${coneMatrix[index]}', // 카운트 표시
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class BorderTween extends Tween<Border?> {
  BorderTween({Border? begin, Border? end}) : super(begin: begin, end: end);

  @override
  Border? lerp(double t) {
    return Border.all(
      color: Color.lerp(begin!.top.color, end!.top.color, t)!,
      width: lerpDouble(begin!.top.width, end!.top.width, t)!,
    );
  }
}
