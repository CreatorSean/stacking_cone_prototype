import 'package:flutter/material.dart';
import 'dart:math';

class ConContainerWidget extends StatefulWidget {
  const ConContainerWidget({Key? key}) : super(key: key);

  @override
  _ConContainerWidgetState createState() => _ConContainerWidgetState();
}

class _ConContainerWidgetState extends State<ConContainerWidget> {
  int _randomIndex = 0;
  int? _selectedGridIndex;
  int _coneCount = 0;

  @override
  void initState() {
    super.initState();
    _randomIndex = Random().nextInt(6);
  }

  void _handleTap(int index) {
    setState(() {
      if (index == _randomIndex) {
        _coneCount++;
        _randomIndex = Random().nextInt(6); // 새로운 정답 인덱스 생성
        _selectedGridIndex = null; // 선택 초기화
      } else {
        _selectedGridIndex = index; // 오답 선택
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
              onTap: () => _handleTap(index),
              child: Container(
                decoration: BoxDecoration(
                  color: _selectedGridIndex == index
                      ? const Color(0xffEB1138)
                      : const Color(0xfff0e5c8),
                  border: Border.all(
                    color: const Color(0xFF332F23),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    index == _randomIndex && _selectedGridIndex == null
                        ? '🎉'
                        : '$index',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildWCorrectGrid(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff10C738),
        border: Border.all(
          color: const Color(0xFF332F23),
          width: 1.5,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/images/redcone.png', // 이미지 경로를 설정하세요.
            width: 180,
            height: 180,
          ),
          Text(
            '$_coneCount',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildWorngGrid(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffEB1138),
        border: Border.all(
          color: const Color(0xFF332F23),
          width: 1.5,
        ),
      ),
      child: Image.asset(
        'assets/images/redcone.png', // 이미지 경로를 설정하세요.
        width: 180,
        height: 180,
      ),
    );
  }
}
