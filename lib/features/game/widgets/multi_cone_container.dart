import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/services/bluetooth_service/view_models/bluetooth_service.dart';

class MultiConContainer extends ConsumerStatefulWidget {
  final Function() trueLottie;
  final Function() falseLottie;
  final String level;

  const MultiConContainer({
    Key? key,
    required this.trueLottie,
    required this.falseLottie,
    required this.level,
  }) : super(key: key);

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
  int randomIndexesCounts = 0;
  List<int> coneMatrix = [0, 0, 0, 0, 0, 0, 0, 0, 0];
  int coneCount = 0;
  List<int> initMatrix = [0, 0, 0, 0, 0, 0, 0, 0, 0];
  List<String> gameRule = [];
  int gameLevel = 0; // 0: easy | 1: normal | 2: hard

  final ListEquality _listEquality = const ListEquality();

  @override
  void initState() {
    super.initState();
    _initRandomIndexes();
  }

  void _initRandomIndexes() {
    if (widget.level == 'easy') {
      while (randomIndexes.isEmpty) {
        randomIndexes.add(Random().nextInt(9));
      }
      _easyWhiteLocationDisplayTime();
    } else if (widget.level == 'normal') {
      while (randomIndexes.length < 3) {
        randomIndexes.add(Random().nextInt(9));
      }
      _normalWhiteLocationDisplayTime();
    } else {
      while (randomIndexes.length < 5) {
        randomIndexes.add(Random().nextInt(9));
      }
      _hardWhiteLocationDisplayTime();
    }
  }

  void _easyWhiteLocationDisplayTime() {
    int delaySeconds = 1;
    for (var index in randomIndexes) {
      Future.delayed(Duration(seconds: delaySeconds), () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            gameRule.add('l');
            gameRule.add(index.toString());
            gameRule.add('G');
            ref.watch(bluetoothServiceProvider.notifier).onSendData(gameRule);
            displayStartTimes[index] = DateTime.now();
            gameRule.clear();
            setState(() {});
          }
        });
      });
      Future.delayed(const Duration(seconds: 3), () {
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

  void _normalWhiteLocationDisplayTime() {
    int delaySeconds = 1;
    for (var index in randomIndexes) {
      Future.delayed(Duration(seconds: delaySeconds), () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            gameRule.add('l');
            gameRule.add(index.toString());
            gameRule.add('G');
            ref.watch(bluetoothServiceProvider.notifier).onSendData(gameRule);
            displayStartTimes[index] = DateTime.now();
            gameRule.clear();
            setState(() {});
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

  void _hardWhiteLocationDisplayTime() {
    // 모든 인덱스를 동시에 시작하도록 지연 시간을 통일
    for (var index in randomIndexes) {
      // 동시에 1초 후에 모든 인덱스를 표시
      Future.delayed(const Duration(seconds: 1), () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            gameRule.add('l');
            gameRule.add(index.toString());
            gameRule.add('G');
            ref.watch(bluetoothServiceProvider.notifier).onSendData(gameRule);
            displayStartTimes[index] = DateTime.now();
            gameRule.clear();
            setState(() {});
          }
        });
      });

      // 동시에 4초 후에 모든 인덱스를 숨김
      Future.delayed(const Duration(seconds: 3), () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              displayStartTimes.remove(index);
            });
          }
        });
      });
    }
  }

  void _notifyRightLocation() {
    int delaySeconds = 1;
    for (var index in randomIndexes) {
      Future.delayed(Duration(seconds: delaySeconds), () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            gameRule.add('L');
            gameRule.add(index.toString());
            gameRule.add('G');
            ref.watch(bluetoothServiceProvider.notifier).onSendData(gameRule);
            displayStartTimes[index] = DateTime.now();
            gameRule.clear();
            setState(() {});
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

  void _resetGame() {
    randomIndexes.clear();
    displayStartTimes.clear();
    correctIndexes.clear();
    incorrectIndexes.clear();
    fixedRedConeIndex = null;
    coneCount = 0;
    _initRandomIndexes();
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

    if ((coneCount == 3 && widget.level == 'normal') ||
        (coneCount == 5 && widget.level == 'hard') ||
        (coneCount == 1 && widget.level == 'easy')) {
      _resetGame();
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
                                _targetLocation(context)
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

  Widget _targetLocation(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 105, 221, 238),
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
        color: const Color.fromARGB(255, 176, 233, 247),
        border: Border.all(
          color: const Color(0xFF332F23),
          width: 1.5,
        ),
      ),
      // child: Center(
      //   child: Text(
      //     '$index',
      //     style: Theme.of(context).textTheme.titleLarge,
      //   ),
      // ),
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
