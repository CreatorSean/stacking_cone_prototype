import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/common/constants/gaps.dart';
import 'package:stacking_cone_prototype/common/main_appbar.dart';
import 'package:stacking_cone_prototype/features/game/widgets/result_dialog_widget.dart';
import 'package:stacking_cone_prototype/features/game/widgets/stop_button.dart';
import 'package:stacking_cone_prototype/features/game/widgets/timer_container.dart';
import 'package:stacking_cone_prototype/features/game_select/view_model/game_config_vm.dart';
import 'package:stacking_cone_prototype/services/database/models/game_record_model.dart';

import '../../../../services/timer/timer_service.dart';
import '../../widgets/negative_lottie.dart';
import '../../widgets/positive_lottie.dart';
import '../../widgets/single_cone_container .dart';

class SingleLedGameScreen extends ConsumerStatefulWidget {
  static String routeURL = '/single';
  static String routeName = 'single';
  const SingleLedGameScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SingleLedGameScreenState();
}

class _SingleLedGameScreenState extends ConsumerState<SingleLedGameScreen>
    with TickerProviderStateMixin {
  int randomIndex = Random().nextInt(2);
  bool _isDialogShown = false;
  bool _showLottieAnimation = false;
  bool _isConeSuccess = false; //콘 꽂았을 때 효과
  int positiveNum = 0;
  int negativeNum = 0;
  late final AnimationController _lottieController;

  void showGameResult() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isDialogShown = true;
      showDialog(
        context: context,
        builder: (context) => ResultDialog(
          screenName: const SingleLedGameScreen(),
          answer: positiveNum,
          totalCone: positiveNum + negativeNum,
          record: GameRecordModel(
            id: null,
            totalCone: positiveNum + negativeNum,
            answerCone: positiveNum,
            wrongCong: negativeNum,
            totalTime: 60,
          ),
        ),
      ).then((value) => _isDialogShown = false);
    });
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

  void isTrue() {
    _isConeSuccess = true;
    _showLottieAnimation = true;
    ++positiveNum;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  void isFalse() {
    _isConeSuccess = false;
    _showLottieAnimation = true;
    ++negativeNum;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
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
        children: [
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
                          "단일 모드",
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
                        _showLottieAnimation
                            ? Text(
                                _isConeSuccess ? "잘했어요!" : "다시 한 번 해보세요!",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(color: Colors.pink),
                              )
                            : Text(
                                "",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: SingleConeContainer(
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
                        screenName: const SingleLedGameScreen(),
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
              showLottieAnimation: _showLottieAnimation,
              onAnimationComplete: () {
                setState(() {
                  _showLottieAnimation = false;
                });
              },
            ),
          //부정 로띠
          if (negativeNum != 0 && _isConeSuccess == false)
            NegativeLottie(
              controller: _lottieController,
              randomIndex: randomIndex,
              showLottieAnimation: _showLottieAnimation,
              onAnimationComplete: () {
                setState(() {
                  _showLottieAnimation = false;
                });
              },
            ),
        ],
      ),
    );
  }
}
