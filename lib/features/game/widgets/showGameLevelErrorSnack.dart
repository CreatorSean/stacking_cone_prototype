import 'package:flutter/material.dart';

void showGameLevelErrorSnack(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text(
        "게임 레벨을 선택해주세요!.",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      action: SnackBarAction(
        label: '닫기',
        onPressed: () {
          // SnackBar를 닫을 때의 동작을 여기에 추가합니다.
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ),
  );
}
