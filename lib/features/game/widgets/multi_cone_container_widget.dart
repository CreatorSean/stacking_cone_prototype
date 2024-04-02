import 'package:flutter/material.dart';
import 'dart:math';

class MultiConContainerWidget extends StatefulWidget {
  const MultiConContainerWidget({Key? key}) : super(key: key);

  @override
  State<MultiConContainerWidget> createState() =>
      _MultiConContainerWidgetState();
}

class _MultiConContainerWidgetState extends State<MultiConContainerWidget> {
  int? clickedIndex; // 사용자가 클릭한 인덱스
  Set<int> randomIndexes = {}; //랜덤으로 흰색 배경 띄워주는 인덱스

  Positioned viewRedCone() {
    return Positioned.fill(
      child: Image.asset(
        'assets/images/redcone.png',
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    while (randomIndexes.length < 2) {
      randomIndexes.add(Random().nextInt(6));
    }

    return Center(
      child: Container(
        width: 360,
        height: 300,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFF332F23),
            width: 1.5,
          ),
        ),
        child: GridView.count(
          crossAxisCount: 3,
          childAspectRatio: 0.8,
          children: List.generate(6, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  clickedIndex = index;
                });
              },
              child: Stack(
                children: [
                  randomIndexes.contains(index)
                      ? _coneLocation(context, index)
                      : _normalLocation(context, index),
                  if (clickedIndex == index) viewRedCone(),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _coneLocation(BuildContext context, int index) {
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
}
