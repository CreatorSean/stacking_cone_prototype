import 'package:flutter/material.dart';

class PasswordDialog extends StatelessWidget {
  final Function(String) onPasswordSubmitted;

  const PasswordDialog({required this.onPasswordSubmitted, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();

    return AlertDialog(
      title: const Text('비밀번호 입력'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.grey[400]!,
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextField(
                controller: passwordController,
                keyboardType: TextInputType.number,
                obscureText: true,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '비밀번호 입력',
                ),
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('취소'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('확인'),
          onPressed: () {
            onPasswordSubmitted(passwordController.text);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
