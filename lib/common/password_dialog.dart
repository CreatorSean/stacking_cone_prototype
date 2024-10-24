import 'package:flutter/material.dart';

class PasswordDialog extends StatefulWidget {
  final Function(String) onPasswordSubmitted;

  const PasswordDialog({required this.onPasswordSubmitted, Key? key})
      : super(key: key);

  @override
  _PasswordDialogState createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<PasswordDialog> {
  final TextEditingController passwordController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final titleFontSize = screenWidth * 0.05;
    final mediumFontSize = screenWidth * 0.03;

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
                focusNode: _focusNode,
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
                onSubmitted: (value) {
                  widget.onPasswordSubmitted(value);
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
            widget.onPasswordSubmitted(passwordController.text);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
