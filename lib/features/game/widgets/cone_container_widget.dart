import 'package:flutter/material.dart';
import 'dart:math';

class ConContainerWidget extends StatelessWidget {
  const ConContainerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int randomIndex = Random().nextInt(6);

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
            return index == randomIndex
                ? _coneLocation(context, index) // 흰색 배경, redcone 나타남
                : _normalLocation(context, index); // 일반 아이템
          }),
        ),
      ),
    );
  }

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
