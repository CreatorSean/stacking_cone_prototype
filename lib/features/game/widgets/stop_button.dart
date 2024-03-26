import 'package:flutter/material.dart';
import 'package:stacking_cone_prototype/features/game/views/cone_stacking_game/cone_stacking_game_screen.dart';
import 'package:stacking_cone_prototype/features/game/views/multiple_led_game/multiple_led_game_screen.dart';
import 'package:stacking_cone_prototype/features/game/widgets/result_dialog_widget.dart';
import 'package:stacking_cone_prototype/features/game_select/view/game_select_screen.dart';

enum GameType { coneStacking, Multiple }

class StopButton extends StatelessWidget {
  final GameType gameType;

  const StopButton({Key? key, required this.gameType}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ResultDialog(
              totalCone: 10,
              answer: 8,
              timeElapsed: '10:00', // 가상의 시간
              onHomePressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                Navigator.of(context).pop(); // 현재 화면 닫기
              },
              onContinuePressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                Navigator.of(context).pop(); // 게임 화면 닫기
                if (gameType == GameType.coneStacking) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ConeStackingGameScreen(),
                    ),
                  );
                  const ConeStackingGameScreen();
                }
                if (gameType == GameType.Multiple) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MultipleLedGameScreen(),
                    ),
                  );
                  const MultipleLedGameScreen();
                }
              },
            );
          },
        );
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            const Color(0xfff0e5c8),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // 버튼의 모서리를 둥글게 만듦
              side: const BorderSide(
                color: Color(0xFF332F23), // 테두리 색상
                width: 1.5, // 테두리 두께
              ),
            ),
          ),
          minimumSize: MaterialStateProperty.all(const Size(100, 40))),
      child: const Text(
        '그만하기',
        style: TextStyle(
          color: Color(0xFF332F23),
        ),
      ),
    );
  }
}
