import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class MultiConContainerWidget extends StatefulWidget {
  final Function() trueLottie;
  final Function() falseLottie;

  const MultiConContainerWidget(
      {Key? key, required this.trueLottie, required this.falseLottie})
      : super(key: key);

  @override
  State<MultiConContainerWidget> createState() =>
      _MultiConContainerWidgetState();
}

class _MultiConContainerWidgetState extends State<MultiConContainerWidget> {
  Set<int> randomIndexes = {};
  Map<int, DateTime> displayStartTimes = {};
  Set<int> correctIndexes = {};
  Set<int> incorrectIndexes = {};
  Set<int> alreadyClicked = {};
  int? fixedRedConeIndex;
  int convertScreen = 0;
  int correctScore = 0;
  int incorrectScore = 0;
  List<int> coneMatrix = [0, 0, 0];

  @override
  void initState() {
    super.initState();
    _initRandomIndexes();
  }

  void _initRandomIndexes() {
    while (randomIndexes.length < 2) {
      randomIndexes.add(Random().nextInt(3));
    }
    _whiteLocationDisplayTime();
  }

  void _whiteLocationDisplayTime() {
    int delaySeconds = 1;
    for (var index in randomIndexes) {
      Future.delayed(Duration(seconds: delaySeconds), () {
        setState(() {
          displayStartTimes[index] = DateTime.now();
        });
        Future.delayed(const Duration(seconds: 3), () {
          setState(() {
            displayStartTimes.remove(index);
          });
        });
      });
      delaySeconds += 1;
    }
  }

  void _notifyRightLoaction() {
    int delaySeconds = 1;
    for (var index in randomIndexes) {
      if (index != fixedRedConeIndex) {
        Future.delayed(Duration(seconds: delaySeconds), () {
          setState(() {
            displayStartTimes[index] = DateTime.now();
          });
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              displayStartTimes.remove(index);
            });
          });
        });
      }
    }
  }

  void _handleTap(int index) {
    setState(() {
      if (correctIndexes.contains(index)) {
        return;
      }
      if (correctIndexes.length == 2) {
        return;
      }
      if (alreadyClicked.contains(index) || index == fixedRedConeIndex) {
        return;
      }
      if (fixedRedConeIndex == null) {
        alreadyClicked.clear();
        alreadyClicked.add(index);
      } else {
        if (!correctIndexes.contains(index)) {
          alreadyClicked.removeWhere((element) => element != fixedRedConeIndex);
          alreadyClicked.add(index);
        }
      }
      if (randomIndexes.contains(index)) {
        coneMatrix[index]++;
        widget.trueLottie();
        ++correctScore;
        ++convertScreen;
        correctIndexes.add(index);
        fixedRedConeIndex ??= index;
      } else {
        widget.falseLottie();
        coneMatrix[index]--;
        ++incorrectScore;
        incorrectIndexes.add(index);
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            incorrectIndexes.remove(index);
            _notifyRightLoaction();
          });
        });
      }
      if (convertScreen == 2) {
        Future.delayed(const Duration(seconds: 3), () {
          setState(() {
            randomIndexes.clear();
            displayStartTimes.clear();
            correctIndexes.clear();
            incorrectIndexes.clear();
            alreadyClicked.clear();
            fixedRedConeIndex = null;
            convertScreen = 0;

            _initRandomIndexes();
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 360, // 컨테이너의 너비
        height: 151, // 컨테이너의 높이를 줄여 한 줄로 표시
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFF332F23),
            width: 1.5,
          ),
        ),
        child: GridView.count(
          crossAxisCount: 3, // 한 줄에 3개의 격자를 표시
          childAspectRatio: 0.8,
          // GridView가 스크롤 가능한 영역을 넘어서지 않도록 physics 속성을 NeverScrollableScrollPhysics로 설정
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(3, (index) {
            // 총 3개의 격자 생성
            return GestureDetector(
              onTap: () => _handleTap(index),
              child: Stack(
                children: [
                  correctIndexes.contains(index)
                      ? _greenLocation(context, index)
                      : _redLocation(context, index),
                  if (displayStartTimes.containsKey(index))
                    _whiteLocation(context)
                  else if (!correctIndexes.contains(index) &&
                      !incorrectIndexes.contains(index))
                    _normalLocation(context, index),
                  if (alreadyClicked.contains(index)) viewRedCone(),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Stack viewRedCone() {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset('assets/images/redcone.png', fit: BoxFit.cover),
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
