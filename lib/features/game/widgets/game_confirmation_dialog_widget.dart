import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/common/constants/gaps.dart';
import 'package:stacking_cone_prototype/features/game/view_model/cone_stacking_game_vm.dart';
import 'package:stacking_cone_prototype/features/game/views/multiple_led_game/multiple_led_game_screen.dart';
import 'package:stacking_cone_prototype/features/game/widgets/level_select_button.dart';
import 'package:stacking_cone_prototype/features/game/widgets/showGameLevelErrorSnack.dart';
import 'package:stacking_cone_prototype/features/game/widgets/targetIndex_select_form.dart';
import 'package:stacking_cone_prototype/features/game_select/view_model/game_config_vm.dart';
import 'package:stacking_cone_prototype/features/staff/view_model/selected_patient_view_model.dart';
import 'package:stacking_cone_prototype/features/staff/widgets/showErrorSnack.dart';
import 'package:stacking_cone_prototype/services/bluetooth_service/view_models/bluetooth_service.dart';
import 'package:stacking_cone_prototype/services/database/models/patient_model.dart';

class GameConfirmationDialog extends ConsumerStatefulWidget {
  //final VoidCallback onStartLottie;
  final Widget screenName;
  final String gameName;

  const GameConfirmationDialog({
    super.key,
    required this.screenName,
    required this.gameName,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GameConfirmationDialogState();
}

class _GameConfirmationDialogState
    extends ConsumerState<GameConfirmationDialog> {
  int targetIndex = 0;
  bool _easySelected = false;
  bool _normalSelected = false;
  bool _hardSelected = false;
  String level = 'easy';
  final String _easy = '쉬움';
  final String _normal = '보통';
  final String _hard = '어려움';

  // void _onStackingGameStartTap() {
  //   ref.read(gameProvider.notifier).startStackingGame();
  //   ref
  //       .read(bluetoothServiceProvider.notifier)
  //       .onSendData(ref.watch(gameProvider).gameRule);
  // }

  void _onNextTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget.screenName,
      ),
    );
    if (widget.gameName == '인지 재활') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MultipleLedGameScreen(
            level: level,
          ),
        ),
      );
    }
  }

  void _onEasySelectTap() {
    _easySelected = true;
    _normalSelected = false;
    _hardSelected = false;
    level = 'easy';
    setState(() {});
  }

  void _onNormalSelectTap() {
    _easySelected = false;
    _normalSelected = true;
    _hardSelected = false;
    level = 'normal';
    setState(() {});
  }

  void _onHardSelectTap() {
    _easySelected = false;
    _normalSelected = false;
    _hardSelected = true;
    level = 'hard';
    setState(() {});
  }

  void _setGameLevel() {
    if (_easySelected) {
      ref.watch(gameProvider).gameMode = 'easy';
      Navigator.pop(context);
      _onNextTap();
    } else if (_normalSelected) {
      ref.watch(gameProvider).gameMode = 'normal';
      Navigator.pop(context);
      _onNextTap();
    } else if (_hardSelected) {
      ref.watch(gameProvider).gameMode = 'hard';
      Navigator.pop(context);
      _onNextTap();
    } else if (widget.gameName == '운동 재활' &&
        !ref.watch(gameProvider).targetIndex.isNaN) {
      Navigator.pop(context);
      _onNextTap();
    } else {
      showGameLevelErrorSnack(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final length = MediaQuery.of(context).size.width * 0.15;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    PatientModel selectedPatient = ref
        .read(SelectedPatientViewModelProvider.notifier)
        .getSelectedPatient();
    final config = ref.read(gameConfigProvider);

    String userName = selectedPatient.userName;
    String mode = widget.gameName;
    String trainOrTest = config.isTest ? '평가 모드' : '훈련 모드';
    config.isMode = widget.gameName == '운동 재활' ? true : false;
    return AlertDialog(
      title: const Text("게임 시작 확인"),
      content: Container(
        width: width * 0.5,
        height: config.isMode ? height * 0.4 : height * 0.2,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("이름: $userName"),
            Text("종류: $mode"),
            Text("모드: $trainOrTest"),
            Gaps.v10,
            config.isMode
                ? const TargetindexSelectForm()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _onEasySelectTap();
                        },
                        child: LevelSelectButton(
                          buttonName: _easy,
                          width: length,
                          height: length,
                          isSelected: _easySelected,
                        ),
                      ),
                      Gaps.h2,
                      GestureDetector(
                        onTap: () {
                          _onNormalSelectTap();
                        },
                        child: LevelSelectButton(
                          buttonName: _normal,
                          width: length,
                          height: length,
                          isSelected: _normalSelected,
                        ),
                      ),
                      Gaps.h2,
                      GestureDetector(
                        onTap: () {
                          _onHardSelectTap();
                        },
                        child: LevelSelectButton(
                          buttonName: _hard,
                          width: length,
                          height: length,
                          isSelected: _hardSelected,
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("취소"),
        ),
        ElevatedButton(
          onPressed: () {
            _setGameLevel();
          },
          child: const Text("시작하기"),
        ),
      ],
    );
  }
}
