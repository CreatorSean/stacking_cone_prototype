import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/features/game/view_model/current_time_vm.dart';
import 'package:stacking_cone_prototype/features/game/view_model/game_test_record_vm.dart';
import 'package:stacking_cone_prototype/features/game_select/view/game_select_screen.dart';
import 'package:stacking_cone_prototype/features/game_select/view_model/game_config_vm.dart';
import 'package:stacking_cone_prototype/services/database/models/game_record_model.dart';

class ResultDialog extends ConsumerWidget {
  final Widget screenName;
  final int totalCone;
  final int answer;
  GameRecordModel record;

  ResultDialog({
    Key? key,
    required this.answer,
    required this.totalCone,
    required this.screenName,
    required this.record,
  }) : super(key: key);

  void getTrainGameRecore() {
    record = GameRecordModel(
      id: null,
      totalCone: totalCone,
      answerCone: answer,
      wrongCong: totalCone - answer,
      totalTime: 60,
    );
  }

  void getTestGameRecore() {
    record = GameRecordModel(
      id: null,
      totalCone: totalCone,
      answerCone: answer,
      wrongCong: totalCone - answer,
      totalTime: 60,
    );
  }

  void onHomePressed(BuildContext context, WidgetRef ref) {
    ref.read(timeProvider.notifier).state = 5;
    if (ref.read(gameConfigProvider).isTest) {
      getTestGameRecore();
      ref.watch(gameRecordProvider.notifier).insertRecord(record);
    } else {
      getTrainGameRecore();
      ref.watch(gameRecordProvider.notifier).insertRecord(record);
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const GameSelectScreen(),
      ),
      (route) => false, // 현재 화면 닫기
    );
  }

  void onContinuePressed(BuildContext context, WidgetRef ref) {
    ref.read(timeProvider.notifier).state = 5;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => screenName,
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int score = (answer / totalCone * 100).toInt();

    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: Color(0xff332F23), width: 5.0),
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
      contentPadding:
          const EdgeInsets.only(top: 20, left: 50, right: 50, bottom: 30),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '전체 점수 : $score점',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xff332F23),
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '전체 콘 개수 : $totalCone개',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xff332F23),
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '맞게 올린 콘 : $answer개',
            textAlign: TextAlign.center,
            style: const TextStyle(
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
              onPressed: () => onHomePressed(context, ref),
              child: const Text('나가기'),
            ),
            const SizedBox(width: 20),
            TextButton(
              onPressed: () => onContinuePressed(context, ref),
              child: const Text('다시하기'),
            ),
          ],
        ),
      ],
    );
  }
}
