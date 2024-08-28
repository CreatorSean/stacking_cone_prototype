import 'package:flutter/material.dart';

void showPasswordErrorSnack(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text("비밀번호를 다시 입력해주세요!."),
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
