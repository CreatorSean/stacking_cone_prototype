import 'package:flutter/material.dart';

class StopButton extends StatelessWidget {
  const StopButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        print('Stop button pressed');
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: const Color(0xfff0e5c8), // 텍스트 색상을 흰색으로 변경
      ),
      child: const Text('그만하기'),
    );
  }
}
