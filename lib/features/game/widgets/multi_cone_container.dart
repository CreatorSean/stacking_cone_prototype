import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/services/bluetooth_service/view_models/bluetooth_service.dart';
import 'package:collection/collection.dart';

class MultiConContainer extends ConsumerStatefulWidget {
  final Function() trueLottie;
  final Function() falseLottie;

  const MultiConContainer(
      {Key? key, required this.trueLottie, required this.falseLottie})
      : super(key: key);

  @override
  ConsumerState<MultiConContainer> createState() => _MultiConContainerState();
}

class _MultiConContainerState extends ConsumerState<MultiConContainer> {
  Set<int> randomIndexes = {};
  Map<int, DateTime> displayStartTimes = {};
  Set<int> correctIndexes = {};
  Set<int> incorrectIndexes = {};
  Set<int> alreadyClicked = {};
  int? fixedRedConeIndex;
  int convertScreen = 0;
  int correctScore = 0;
  int incorrectScore = 0;
  List<int> coneMatrix = [0, 0, 0, 0, 0, 0, 0, 0, 0];
  int coneCount = 0;
  List<int> initMatrix = [0, 0, 0, 0, 0, 0, 0, 0, 0];

  final ListEquality _listEquality = const ListEquality();

  @override
  void initState() {
    super.initState();
    _initRandomIndexes();
  }

  void _initRandomIndexes() {
    while (randomIndexes.length < 3) {
      randomIndexes.add(Random().nextInt(9));
    }
    _whiteLocationDisplayTime();
  }

  void _whiteLocationDisplayTime() {
    int delaySeconds = 1;
    for (var index in randomIndexes) {
      Future.delayed(Duration(seconds: delaySeconds), () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              displayStartTimes[index] = DateTime.now();
            });
          }
        });
      });
      Future.delayed(const Duration(seconds: 4), () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              displayStartTimes.remove(index);
            });
          }
        });
      });
      delaySeconds += 1;
    }
  }

  // void _notifyRightLocation() {
  //   int delaySeconds = 1;
  //   for (var index in randomIndexes) {
  //     if (index != fixedRedConeIndex) {
  //       Future.delayed(Duration(seconds: delaySeconds), () {
  //         WidgetsBinding.instance.addPostFrameCallback((_) {
  //           if (mounted) {
  //             setState(() {
  //               displayStartTimes[index] = DateTime.now();
  //             });
  //             Future.delayed(const Duration(seconds: 1), () {
  //               WidgetsBinding.instance.addPostFrameCallback((_) {
  //                 if (mounted) {
  //                   setState(() {
  //                     displayStartTimes.remove(index);
  //                   });
  //                 }
  //               });
  //             });
  //           }
  //         });
  //       });
  //     }
  //   }
  // }

  void _notifyRightLocation() {
    int delaySeconds = 1;
    for (var index in randomIndexes) {
      Future.delayed(Duration(seconds: delaySeconds), () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              displayStartTimes[index] = DateTime.now();
            });
          }
        });
      });
      Future.delayed(const Duration(seconds: 4), () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              displayStartTimes.remove(index);
            });
          }
        });
      });
      delaySeconds += 1;
    }
  }

  void detectChangesAndReturnIndices(
      List<int> coneMatrix, List<int> btConeMatrix, int index) {
    List<int> changedIndices = [];
    for (int i = 0; i < coneMatrix.length; i++) {
      if (coneMatrix[i] != btConeMatrix[i] && coneMatrix[i] < btConeMatrix[i]) {
        changedIndices.clear();
        changedIndices.add(i);
      }
    }
    if (!_listEquality.equals(btConeMatrix, [0, 0, 0, 0, 0, 0, 0, 0, 0])) {
      if (randomIndexes.isNotEmpty) {
        if (changedIndices.isNotEmpty) {
          if (changedIndices[0] == randomIndexes.first) {
            widget.trueLottie();
            ++coneCount;
            randomIndexes.remove(randomIndexes.first);
            correctIndexes.add(changedIndices[0]);
          } else {
            widget.falseLottie();
            incorrectIndexes.add(changedIndices[0]);

            Future.delayed(const Duration(seconds: 1), () {
              setState(() {
                incorrectIndexes.remove(changedIndices[0]);
                _notifyRightLocation();
              });
            });
          }
        }
      }
    }

    if (_listEquality.equals(btConeMatrix, initMatrix) &&
        coneCount == 3 &&
        coneCount == 3) {
      randomIndexes.clear();
      displayStartTimes.clear();
      correctIndexes.clear();
      incorrectIndexes.clear();
      fixedRedConeIndex = null;
      coneCount = 0;
      _initRandomIndexes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          double containerSize = constraints.maxWidth * 0.8; // 부모 위젯의 80% 크기
          return Container(
            width: containerSize, // 컨테이너의 너비
            height: containerSize, // 컨테이너의 높이를 줄여 한 줄로 표시
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF332F23),
                width: 1.5,
              ),
            ),
            child: ref.watch(bluetoothServiceProvider).when(
                  data: (btModel) {
                    return GridView.count(
                      crossAxisCount: 3,
                      childAspectRatio: 1.0,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: List.generate(
                        9,
                        (index) {
                          detectChangesAndReturnIndices(
                              coneMatrix, btModel.coneMatrixMsg, index);

                          coneMatrix = btModel.coneMatrixMsg;
                          return Stack(
                            children: [
                              correctIndexes.contains(index)
                                  ? _greenLocation(context, index)
                                  : _redLocation(context, index),
                              if (displayStartTimes.containsKey(index))
                                _whiteLocation(context)
                              else if (!correctIndexes.contains(index) &&
                                  !incorrectIndexes.contains(index))
                                _normalLocation(context, index),
                              if (coneMatrix[index] > 0) viewRedCone(index)
                            ],
                          );
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

  Stack viewRedCone(int index) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/redcone.png',
            fit: BoxFit.cover,
            key: ValueKey(index),
          ),
        ),
      ],
    );
  }

  Widget _whiteLocation(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFF332F23),
          width: 1.5,
        ),
      ),
    );
  }

  Widget _normalLocation(BuildContext context, int index) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xfff0e5c8),
        border: Border.all(
          color: const Color(0xFF332F23),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Text(
          '$index',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }

  Widget _greenLocation(BuildContext context, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        border: Border.all(
          color: const Color(0xFF332F23),
          width: 1.5,
        ),
      ),
    );
  }

  Widget _redLocation(BuildContext context, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        border: Border.all(
          color: const Color(0xFF332F23),
          width: 1.5,
        ),
      ),
    );
  }
}
