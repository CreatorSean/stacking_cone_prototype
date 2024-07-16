import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/common/constants/gaps.dart';
import 'package:stacking_cone_prototype/common/main_appbar.dart';
import 'package:stacking_cone_prototype/features/game/widgets/multi_cone_container_widget.dart';
import 'package:stacking_cone_prototype/features/game/widgets/negative_lottie.dart';
import 'package:stacking_cone_prototype/features/game/widgets/positive_lottie.dart';
import 'package:stacking_cone_prototype/features/game/widgets/result_dialog_widget.dart';
import 'package:stacking_cone_prototype/features/game/widgets/stop_button.dart';
import 'package:stacking_cone_prototype/features/game/widgets/timer_container.dart';
import 'package:stacking_cone_prototype/features/game_select/view_model/game_config_vm.dart';
import 'package:stacking_cone_prototype/features/staff/view_model/selected_patient_view_model.dart';
import 'package:stacking_cone_prototype/services/database/models/game_record_model.dart';
import 'package:stacking_cone_prototype/services/database/models/patient_model.dart';

import '../../../../services/timer/timer_service.dart';

class MultipleLedGameScreen extends ConsumerStatefulWidget {
  static String routeURL = '/multiple';
  static String routeName = 'multiple';
  const MultipleLedGameScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MultipleLedGameScreenState();
}

class _MultipleLedGameScreenState extends ConsumerState<MultipleLedGameScreen>
    with TickerProviderStateMixin {
  int randomIndex = Random().nextInt(2);
  bool _isDialogShown = false;
  bool showLottieAnimation = false;
  bool _isConeSuccess = true; //콘 꽂았을 때 효과
  int positiveNum = 0;
  int negativeNum = 0;
  late final AnimationController _lottieController;

  void showGameResult() {
    DateTime dateTime = DateTime.now();
    PatientModel selectedPatient = ref
        .read(SelectedPatientViewModelProvider.notifier)
        .getSelectedPatient();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isDialogShown = true;
      showDialog(
        context: context,
        builder: (context) => ResultDialog(
          screenName: const MultipleLedGameScreen(),
          answer: 8,
          totalCone: 10,
          record: GameRecordModel(
            id: null,
            totalCone: 10,
            answerCone: 8,
            wrongCong: 2,
            totalTime: 60,
            patientId: selectedPatient.id!,
            date: dateTime.microsecondsSinceEpoch,
            mode: 1,
            trainOrtest: ref.read(gameConfigProvider).isTest ? 1 : 0,
          ),
          mode: 1,
        ),
      ).then((value) => _isDialogShown = false);
    });
  }

  void isTrue() {
    _isConeSuccess = true;
    showLottieAnimation = true;
    ++positiveNum;
    setState(() {});
  }

  void isFalse() {
    _isConeSuccess = false;
    showLottieAnimation = true;
    ++negativeNum;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTime = ref.watch(timerControllerProvider).time;
    if (ref.read(gameConfigProvider).isTest) {
      if (currentTime == 0 && !_isDialogShown) {
        showGameResult();
      }
    }
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: MainAppBar(
          isSelectScreen: false,
        ),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              bottom: 40,
            ),
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "이중 모드",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "LED MODE",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    Gaps.v28,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        showLottieAnimation
                            ? Text(
                                _isConeSuccess ? "잘했어요!" : "다시 한 번 해보세요!",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(color: Colors.pink),
                              )
                            : const Text(" "),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: MultiConContainerWidget(
                    trueLottie: () => isTrue(),
                    falseLottie: () => isFalse(),
                  ),
                ),
                Gaps.v20,
                Padding(
                  padding: const EdgeInsets.only(
                    right: 30,
                    left: 30,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      StopButton(
                        showResult: () => showGameResult(),
                        screenName: const MultipleLedGameScreen(),
                      ),
                      TimerContainer(
                        isTimerShow: ref.read(gameConfigProvider).isTest,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          //긍정 로띠
          if (positiveNum != 0 && _isConeSuccess == true)
            PositiveLottie(
              controller: _lottieController,
              randomIndex: randomIndex,
              showLottieAnimation: showLottieAnimation,
              onAnimationComplete: () {
                setState(() {
                  showLottieAnimation = false;
                  randomIndex = Random().nextInt(2);
                });
              },
            ),
          //부정 로띠
          if (negativeNum != 0 && _isConeSuccess == false)
            NegativeLottie(
              controller: _lottieController,
              randomIndex: randomIndex,
              showLottieAnimation: showLottieAnimation,
              onAnimationComplete: () {
                setState(() {
                  showLottieAnimation = false;
                  randomIndex = Random().nextInt(2);
                });
              },
            ),
        ],
      ),
    );
  }
}
