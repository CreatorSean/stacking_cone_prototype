import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ConeContainer extends StatefulWidget {
  const ConeContainer({super.key});

  @override
  State<ConeContainer> createState() => _ConeContainerState();
}

class _ConeContainerState extends State<ConeContainer> {
  late int _targetIndex;

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

  @override
  void initState() {
    super.initState();
    _targetIndex = Random().nextInt(3);
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
        child: GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          childAspectRatio: 0.8,
          children: List.generate(3, (index) {
            return _buildGridItem(context, index);
          }),
        ),
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
              color: index == _targetIndex
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
                      color: index == _targetIndex
                          ? Colors.transparent
                          : Colors.red.withOpacity(0.5),
                    ),
                  )
                      .animate(
                        target: index != _targetIndex ? 1 : 0,
                        onComplete: (controller) {
                          if (index != _targetIndex) {
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
