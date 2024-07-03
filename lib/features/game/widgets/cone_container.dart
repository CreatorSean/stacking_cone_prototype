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
      onTap: () {
        stackCone(index);
      },
      onLongPress: () {
        resetCone(index);
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: index == ref.watch(gameProvider).targetIndex
                  ? Colors.white
                  : const Color(0xfff0e5c8),
              border: Border.all(
                color: const Color(0xFF332F23),
                width: 1.5,
              ),
            ),
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
