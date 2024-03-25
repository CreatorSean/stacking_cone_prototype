import 'package:flutter/material.dart';

class ResultDialog extends StatelessWidget {
  final int score;
  final String timeElapsed;
  final VoidCallback onHomePressed;
  final VoidCallback onContinuePressed;

  const ResultDialog({
    Key? key,
    required this.score,
    required this.timeElapsed,
    required this.onHomePressed,
    required this.onContinuePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Color(0xff332F23), width: 5.0),
      ),
      title: const Text(
        '게임 결과',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xff332F23),
          fontWeight: FontWeight.w300,
          fontSize: 28,
        ),
      ),
      contentPadding: EdgeInsets.only(top: 20, left: 50, right: 50, bottom: 30),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '전체 점수 : 80점',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xff332F23),
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            '전체 콘 개수 : 10개',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xff332F23),
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            '맞게 올린 콘 : 8개',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xff332F23),
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Color(0xffF0E5C8),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // 버튼의 모서리를 둥글게 만듦
                    side: const BorderSide(
                      color: Color(0xFF332F23), // 테두리 색상
                      width: 3.0, // 테두리 두께
                    ),
                  ),
                ),
                minimumSize: MaterialStateProperty.all(
                  Size(110, 20),
                ),
              ),
              onPressed: onHomePressed,
              child: const Text(
                '나가기',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Color(0xffF0E5C8),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // 버튼의 모서리를 둥글게 만듦
                    side: const BorderSide(
                      color: Color(0xFF332F23), // 테두리 색상
                      width: 3.0, // 테두리 두께
                    ),
                  ),
                ),
                minimumSize: MaterialStateProperty.all(
                  Size(110, 20),
                ),
              ),
              onPressed: onContinuePressed,
              child: const Text(
                '다시하기',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
