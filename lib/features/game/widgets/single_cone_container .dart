import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/services/bluetooth_service/view_models/bluetooth_service.dart';

import '../view_model/cone_stacking_game_vm.dart';

class SingleConeContainer extends ConsumerStatefulWidget {
  final Function() trueLottie;
  final Function() falseLottie;
  const SingleConeContainer({
    super.key,
    required this.trueLottie,
    required this.falseLottie,
  });

  @override
  ConsumerState<SingleConeContainer> createState() =>
      _SingleConeContainerState();
}

class _SingleConeContainerState extends ConsumerState<SingleConeContainer>
    with TickerProviderStateMixin {
  List<int> changedIndices = [0];
  int randomIndex = 0;
  List<int> gameRule = [];
  List<int> coneMatrix = [0, 0, 0];

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

  void updateRandomIndex(int currentValue) {
    int newValue;
    do {
      newValue = Random().nextInt(3);
    } while (newValue == currentValue);

    randomIndex = newValue;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    randomIndex = Random().nextInt(3);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 360,
        height: 151,
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
                if (changedIndices[0] == randomIndex) {
                  gameRule.clear();
                  widget.trueLottie();
                  Future.delayed(const Duration(seconds: 1), () {
                    updateRandomIndex(randomIndex);
                    gameRule.add(randomIndex);
                    gameRule.add(1);
                    ref
                        .read(bluetoothServiceProvider.notifier)
                        .onSendData(gameRule);
                    setState(() {});
                  });
                } else {
                  widget.falseLottie();
                }
              }

              coneMatrix = btModel.coneMatrixMsg;
              return GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                childAspectRatio: 0.8,
                children: List.generate(
                  3,
                  (index) {
                    return _buildGridItem(context, index);
                  },
                ),
              );
            },
            error: (error, stackTrace) => const Text('Error'),
            loading: () => const CircularProgressIndicator()),
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
              color:
                  index == randomIndex ? Colors.white : const Color(0xfff0e5c8),
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
                      color: index == randomIndex
                          ? Colors.transparent
                          : Colors.red.withOpacity(0.5),
                    ),
                  )
                      .animate(
                        target: index != randomIndex ? 1 : 0,
                        onComplete: (controller) {
                          if (index != randomIndex) {
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
