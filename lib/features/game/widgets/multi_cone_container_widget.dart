import 'package:flutter/material.dart';
import 'dart:math';

class MultiConContainerWidget extends StatelessWidget {
  const MultiConContainerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Set<int> randomIndexes = {};
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
            return randomIndexes.contains(index)
                ? _coneLocation(context, index)
                : _normalLocation(context, index);
          }),
        ),
      ),
    );
  }

  //랜덤 위치에 콘 나타나는 곳
  Widget _coneLocation(BuildContext context, int index) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: const Color(0xFF332F23),
              width: 1.5,
            ),
          ),
        ),
        Positioned.fill(
          child: Image.asset(
            'assets/images/redcone.png',
            fit: BoxFit.cover,
          ),
        ),
      ],
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
