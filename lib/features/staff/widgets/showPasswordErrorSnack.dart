import 'package:flutter/material.dart';

void showPasswordErrorSnack(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("비밀번호를 다시 입력해주세요!."),
      // action: SnackBarAction(
      //   label: '닫기',
      //   onPressed: () {
      //     if (ScaffoldMessenger.of(context).mounted) {
      //       ScaffoldMessenger.of(context).hideCurrentSnackBar();
      //     }
      //   },
      // ),
    ),
  );
}
