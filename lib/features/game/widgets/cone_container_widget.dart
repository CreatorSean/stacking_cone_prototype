import 'package:flutter/material.dart';
import 'dart:math';

class ConContainerWidget extends StatefulWidget {
  const ConContainerWidget({Key? key}) : super(key: key);

  @override
  _ConContainerWidgetState createState() => _ConContainerWidgetState();
}

class _ConContainerWidgetState extends State<ConContainerWidget> {
  late int _randomIndex;
  int? _selectedGridIndex;
  int _coneCount = 0; // 카운트 변수 추가
  int _normalConeCount = 0;
  @override
  void initState() {
    super.initState();
    _randomIndex = Random().nextInt(6);
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
            return _buildGridItem(context, index);
          }),
        ),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, int index) {
    if (index == _randomIndex) {
      return _coneLocation(context, index);
    } else {
      return _normalLocation(context, index);
    }
  }

  Widget _coneLocation(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGridIndex = index;
          _coneCount++; // 그리드를 클릭할 때마다 카운트 증가
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: _selectedGridIndex == index ? Colors.white : null,
          border: Border.all(
            color: const Color(0xFF332F23),
            width: 1.5,
          ),
        ),
        child: Stack(
          children: [
            if (_coneCount > 0)
              Positioned.fill(
                child: Center(
                  child: Image.asset(
                    'assets/images/redcone.png', // 이미지 경로를 설정하세요.
                    width: 180,
                    height: 180,
                  ),
                ),
              ),
            if (_coneCount > 0)
              Positioned.fill(
                child: Center(
                  child: Text(
                    '$_coneCount', // 카운트 표시
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

Widget _normalLocation(BuildContext context, int index) {
  return GestureDetector(
    onTap: () {
      setState(() {
        _selectedGridIndex = _selectedGridIndex == index ? null : index;
        if (_selectedGridIndex == _randomIndex) {
          _coneCount++;
        }
      });
    },
    child: Container(
      decoration: BoxDecoration(
        color: const Color(0xfff0e5c8),
        border: Border.all(
          color: const Color(0xFF332F23),
          width: 1.5,
        ),
      ),
      child: Stack(
        children: [
          if (_selectedGridIndex == index && _coneCount > 0)
            Positioned.fill(
              child: Center(
                child: Image.asset(
                  'assets/images/redcone.png', // 이미지 경로를 설정하세요.
                  width: 180,
                  height: 180,
                ),
              ),
            ),
    
        ],
      ),
    ),
  );
}

}