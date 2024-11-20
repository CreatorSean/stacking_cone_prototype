import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/features/game/view_model/game_record_vm.dart';
import 'package:stacking_cone_prototype/features/game_select/view_model/game_config_vm.dart';
import 'package:stacking_cone_prototype/features/staff/view_model/selected_patient_view_model.dart';
import 'package:stacking_cone_prototype/services/database/models/game_record_model.dart';
import 'package:stacking_cone_prototype/services/database/models/patient_model.dart';
import '../../../services/timer/timer_service.dart';
import '../../staff/widgets/showErrorSnack.dart';
import 'game_confirmation_dialog_widget.dart';

// ignore: must_be_immutable
class ResultDialog extends ConsumerWidget {
  final Widget screenName;
  final int totalCone;
  final int answer;
  final int mode;
  final String gameName;
  GameRecordModel record;

  ResultDialog({
    Key? key,
    required this.answer,
    required this.totalCone,
    required this.screenName,
    required this.record,
    required this.mode,
    required this.gameName,
  }) : super(key: key);

  void getTrainGameRecore(WidgetRef ref) {
    DateTime dateTime = DateTime.now();
    PatientModel selectedPatient = ref
        .read(SelectedPatientViewModelProvider.notifier)
        .getSelectedPatient();
    record = GameRecordModel(
      id: null,
      totalCone: totalCone,
      patientId: selectedPatient.id!,
      userName: selectedPatient.userName,
      answerCone: answer,
      wrongCong: totalCone - answer,
      totalTime: ref.watch(timerControllerProvider).time,
      date: dateTime.microsecondsSinceEpoch,
      mode: mode,
      level: record.level,
      trainOrtest: ref.read(gameConfigProvider).isTest ? 1 : 0,
    );
  }

  void getTestGameRecore(WidgetRef ref) {
    DateTime dateTime = DateTime.now();
    PatientModel selectedPatient = ref
        .read(SelectedPatientViewModelProvider.notifier)
        .getSelectedPatient();
    record = GameRecordModel(
      id: null,
      totalCone: totalCone,
      userName: selectedPatient.userName,
      patientId: selectedPatient.id!,
      answerCone: answer,
      wrongCong: totalCone - answer,
      totalTime: 60,
      date: dateTime.microsecondsSinceEpoch,
      mode: mode,
      level: record.level,
      trainOrtest: ref.read(gameConfigProvider).isTest ? 1 : 0,
    );
  }

  void _showConfirmationDialog(BuildContext context, WidgetRef ref) {
    final name = record.mode == 0 ? '운동 재활' : '인지 재활';
    if (record.mode == 0 || record.mode == 1) {
      if (ref.watch(gameConfigProvider).isTest == true) {
        ref.watch(timerControllerProvider.notifier).setTimerTime(10);
      }
      ref.read(gameConfigProvider.notifier).setMode(false);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return GameConfirmationDialog(
              screenName: screenName,
              gameName: name,
            );
          },
        );
      });
    } else {
      showErrorSnack(context, '오류가 발생했습니다!');
    }
  }

  void onHomePressed(BuildContext context, WidgetRef ref) {
    if (ref.read(gameConfigProvider).isTest) {
      getTestGameRecore(ref);
      ref.watch(gameRecordProvider.notifier).insertRecord(record);
    } else {
      getTrainGameRecore(ref);
      ref.watch(gameRecordProvider.notifier).insertRecord(record);
    }
    Navigator.pop(context);
    Navigator.pop(context);
  }

  void onRestartPressed(BuildContext context, WidgetRef ref) {
    if (ref.read(gameConfigProvider).isTest) {
      getTestGameRecore(ref);
      ref.watch(gameRecordProvider.notifier).insertRecord(record);
    } else {
      getTrainGameRecore(ref);
      ref.watch(gameRecordProvider.notifier).insertRecord(record);
    }
    _showConfirmationDialog(context, ref);
    Navigator.pop(context);
    Navigator.pop(context);
    // if (ref.watch(gameConfigProvider).isTest) {
    //   ref.watch(timerControllerProvider.notifier).setTimerTime(10);
    //   ref.read(timerControllerProvider.notifier).startTestTimer();
    // } else {
    //   ref.read(timerControllerProvider.notifier).startTimer();
    // }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final titleFontSize = screenWidth * 0.05;
    final mediumFontSize = screenWidth * 0.03;

    int score = 0;
    if (record.answerCone != 0 && record.totalCone != 0) {
      score = (record.answerCone / record.totalCone * 100).toInt();
    } else {
      score = 0;
    }

    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: Color(0xff332F23), width: 5.0),
      ),
      title: Text(
        '게임 결과',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: const Color(0xff332F23),
          fontWeight: FontWeight.w300,
          fontSize: titleFontSize,
        ),
      ),
      contentPadding:
          const EdgeInsets.only(top: 20, left: 50, right: 50, bottom: 30),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            '전체 점수 : $score점',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xff332F23),
              fontWeight: FontWeight.bold,
              fontSize: mediumFontSize,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '맞은 콘 개수 : ${record.answerCone}개',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xff332F23),
              fontWeight: FontWeight.bold,
              fontSize: mediumFontSize,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '틀린 콘 개수 : ${record.wrongCong}개',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xff332F23),
              fontWeight: FontWeight.bold,
              fontSize: mediumFontSize,
            ),
          ),
          const SizedBox(height: 5),
          if (record.mode == 1)
            Text(
              '난이도 : ${record.level == 0 ? '쉬움' : record.level == 1 ? '보통' : '어려움'}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xff332F23),
                fontWeight: FontWeight.bold,
                fontSize: mediumFontSize,
              ),
            ),
        ],
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 10),
            SizedBox(
              width: 110,
              height: 40,
              child: TextButton(
                onPressed: () => onHomePressed(context, ref),
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.pressed)) {
                        return Colors.grey.shade400; // 눌렸을 때의 배경색
                      }
                      return const Color(0xfff0e5c8); // 기본 배경색
                    },
                  ),
                ),
                child: const Text(
                  '나가기',
                ),
              ),
            ),
            const SizedBox(width: 20),
            SizedBox(
              width: 110,
              height: 40,
              child: TextButton(
                onPressed: () => onRestartPressed(context, ref),
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.pressed)) {
                        return Colors.grey.shade400; // 눌렸을 때의 배경색
                      }
                      return const Color(0xfff0e5c8); // 기본 배경색
                    },
                  ),
                ),
                child: const Text(
                  '다시하기',
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
