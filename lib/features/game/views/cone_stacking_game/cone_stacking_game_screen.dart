import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/common/constants/gaps.dart';
import 'package:stacking_cone_prototype/common/main_appbar.dart';
import 'package:stacking_cone_prototype/features/game/widgets/cone_container.dart';
import 'package:stacking_cone_prototype/features/game/widgets/result_dialog_widget.dart';
import 'package:stacking_cone_prototype/features/game/widgets/stop_button.dart';
import 'package:stacking_cone_prototype/features/game/widgets/timer_container.dart';
import 'package:stacking_cone_prototype/features/game_select/view_model/game_config_vm.dart';
import 'package:stacking_cone_prototype/features/staff/view_model/selected_patient_view_model.dart';
import 'package:stacking_cone_prototype/services/database/models/game_record_model.dart';
import 'package:stacking_cone_prototype/services/timer/timer_service.dart';
import '../../../../services/database/models/patient_model.dart';
import '../../widgets/negative_lottie.dart';
import '../../widgets/positive_lottie.dart';
import '../../widgets/countdown_lottie.dart';

class ConeStackingGameScreen extends ConsumerStatefulWidget {
  static String routeURL = '/stacking';
  static String routeName = 'stacking';
  const ConeStackingGameScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConeStackingGameScreenState();
}

class _ConeStackingGameScreenState extends ConsumerState<ConeStackingGameScreen>
    with TickerProviderStateMixin {
  int randomIndex = Random().nextInt(2);
  bool showLottieAnimation = false;
  bool _isDialogShown = false;
  bool _isConeSuccess = true;
  int positiveNum = 0;
  int negativeNum = 0;
  bool _isCountdownComplete = false;
  bool _isLottiePlaying = true; // Lottie 애니메이션 상태 변경
  late final AnimationController _lottieController;
  late final AnimationController _countdownController;

  void isTrue() {
    _isConeSuccess = true;
    showLottieAnimation = true;
    ++positiveNum;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  void isFalse() {
    _isConeSuccess = false;
    showLottieAnimation = true;
    ++negativeNum;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

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
          screenName: const ConeStackingGameScreen(),
          answer: positiveNum,
          totalCone: positiveNum + negativeNum,
          record: GameRecordModel(
            id: null,
            userName: selectedPatient.userName,
            mode: 0,
            level: 0, //이부분 수정해야함
            totalCone: positiveNum + negativeNum,
            answerCone: positiveNum,
            wrongCong: negativeNum,
            totalTime: 60,
            patientId: selectedPatient.id!,
            date: dateTime.microsecondsSinceEpoch,
            trainOrtest: ref.read(gameConfigProvider).isTest ? 1 : 0,
          ),
          mode: 0,
        ),
      ).then((value) => _isDialogShown = false);
    });
  }

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
    _countdownController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // 카운트다운 애니메이션의 지속 시간
    ); // 카운트다운 컨트롤러 초기화
    _countdownController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _isCountdownComplete = true; // 카운트다운 완료 상태로 변경
              _isLottiePlaying = false; // Lottie 애니메이션 상태 변경
            });
          }
        });
        if (ref.read(gameConfigProvider).isTest) {
          ref
              .read(timerControllerProvider.notifier)
              .startTestTimer(); // 평가 타이머 시작
        } else {
          ref.read(timerControllerProvider.notifier).startTimer(); // 일반 타이머 시작
        }
      }
    });

    _countdownController.forward(); // 화면이 로드되면 카운트다운 시작
  }

  @override
  void dispose() {
    _lottieController.dispose();
    _countdownController.dispose(); // 카운트다운 컨트롤러 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTime = ref.watch(timerControllerProvider).time;
    if (ref.read(gameConfigProvider).isTest) {
      if (currentTime == 0 && _isDialogShown == true) {
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
      body: _isLottiePlaying
          ? CountdownLottie(
              controller: _countdownController,
              onAnimationComplete: () {
                setState(() {
                  _isCountdownComplete = true;
                });
              },
            )
          : _isCountdownComplete
              ? Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 10,
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
                                    "단일 모드",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "콘 쌓기 MODE",
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                ],
                              ),
                              Gaps.v28,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  showLottieAnimation
                                      ? Text(
                                          _isConeSuccess
                                              ? "잘했어요!"
                                              : "다시 한 번 해보세요!",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(color: Colors.pink),
                                        )
                                      : const Text(""),
                                ],
                              ),
                            ],
                          ),
                          Gaps.v28,
                          Expanded(
                            child: ConeContainer(
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
                                  screenName: const ConeStackingGameScreen(),
                                  showResult: () => showGameResult(),
                                ),
                                TimerContainer(
                                  isTimerShow:
                                      ref.read(gameConfigProvider).isTest,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (positiveNum != 0 && _isConeSuccess == true)
                      PositiveLottie(
                        controller: _lottieController,
                        randomIndex: randomIndex,
                        showLottieAnimation: showLottieAnimation,
                        onAnimationComplete: () {
                          setState(() {
                            showLottieAnimation = false;
                          });
                        },
                      ),
                    if (negativeNum != 0 && _isConeSuccess == false)
                      NegativeLottie(
                        controller: _lottieController,
                        randomIndex: randomIndex,
                        showLottieAnimation: showLottieAnimation,
                        onAnimationComplete: () {
                          setState(() {
                            showLottieAnimation = false;
                          });
                        },
                      ),
                  ],
                )
              : Container(),
    );
  }
}
