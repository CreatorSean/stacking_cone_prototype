import 'package:flutter/material.dart';

class PasswordDialog extends StatelessWidget {
  final Function(String) onPasswordSubmitted;

  const PasswordDialog({required this.onPasswordSubmitted, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final titleFontSize = screenWidth * 0.07;
    final mediumFontSize = screenWidth * 0.06;
    final TextEditingController passwordController = TextEditingController();

    return AlertDialog(
      title: Center(
        child: Text(
          '비밀번호 입력',
          style: TextStyle(
            fontSize: titleFontSize,
          ),
        ),
      ),
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
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '비밀번호 입력',
                  hintStyle: TextStyle(
                    fontSize: mediumFontSize,
                  ),
                ),

                // enter 누르면 입력한 비밀번호 사라지는 에러 해결
                onSubmitted: (value) {
                  onPasswordSubmitted(value);
                  Navigator.of(context).pop();
                },
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
