import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/common/constants/gaps.dart';
import 'package:stacking_cone_prototype/common/main_appbar.dart';
import 'package:stacking_cone_prototype/features/game/widgets/multi_cone_container.dart';
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
import '../../widgets/countdown_lottie.dart';

// ignore: must_be_immutable
class MultipleLedGameScreen extends ConsumerStatefulWidget {
  static String routeURL = '/multiple';
  static String routeName = 'multiple';
  String level;
  MultipleLedGameScreen({
    super.key,
    required this.level,
  });

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
  bool _isCountdownComplete = false; // 추가된 상태 변수
  bool _isLottiePlaying = false; // Lottie 애니메이션 상태 추가
  late final AnimationController _lottieController;
  late final AnimationController _countdownController; // 추가된 애니메이션 컨트롤러
  final String gameName = '인지재활';

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
          screenName: MultipleLedGameScreen(
            level: widget.level,
          ),
          answer: positiveNum,
          totalCone: positiveNum + negativeNum,
          gameName: widget.level,
          record: GameRecordModel(
            id: null,
            userName: selectedPatient.userName,
            totalCone: positiveNum + negativeNum,
            answerCone: positiveNum,
            wrongCong: negativeNum,
            totalTime: 60,
            patientId: selectedPatient.id!,
            date: dateTime.microsecondsSinceEpoch,
            mode: 1,
            level: 1, //이부분 수정해야함
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void isFalse() {
    _isConeSuccess = false;
    showLottieAnimation = true;
    ++negativeNum;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);

    _countdownController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // 카운트다운 애니메이션의 지속 시간 설정
    );

    // 화면이 로드되면 카운트다운 시작
    _startCountdown();

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
  }

  void _startCountdown() {
    setState(() {
      _isLottiePlaying = true; // 카운트다운 애니메이션 시작 시 표시
    });
    _countdownController.forward(from: 0); // 카운트다운 시작
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
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() {
                      _isCountdownComplete = true;
                    });
                  }
                });
              },
            )
          : _isCountdownComplete
              ? Stack(
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
                                    gameName,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "LED MODE",
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
                                      : const Text(" "),
                                ],
                              ),
                            ],
                          ),
                          Expanded(
                            child: MultiConContainer(
                              level: widget.level,
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
                                  screenName: MultipleLedGameScreen(
                                    level: widget.level,
                                  ),
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
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) {
                              setState(() {
                                showLottieAnimation = false;
                                randomIndex = Random().nextInt(2);
                              });
                            }
                          });
                        },
                      ),
                    if (negativeNum != 0 && _isConeSuccess == false)
                      NegativeLottie(
                        controller: _lottieController,
                        randomIndex: randomIndex,
                        showLottieAnimation: showLottieAnimation,
                        onAnimationComplete: () {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) {
                              setState(() {
                                showLottieAnimation = false;
                                randomIndex = Random().nextInt(2);
                              });
                            }
                          });
                        },
                      ),
                  ],
                )
              : Container(),
    );
  }
}
