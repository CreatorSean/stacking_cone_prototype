import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:stacking_cone_prototype/common/constants/gaps.dart';
import 'package:stacking_cone_prototype/common/main_appbar.dart';
import 'package:stacking_cone_prototype/features/game/view_model/current_time_vm.dart';
import 'package:stacking_cone_prototype/features/game/widgets/result_dialog_widget.dart';
import 'package:stacking_cone_prototype/features/game/widgets/single_cone_container_widget%20.dart';
import 'package:stacking_cone_prototype/features/game/widgets/stop_button.dart';
import 'package:stacking_cone_prototype/features/game/widgets/timer_container.dart';
import 'package:stacking_cone_prototype/features/game_select/view_model/game_config_vm.dart';
import 'package:stacking_cone_prototype/services/database/models/game_record_model.dart';

class SingleLedGameScreen extends ConsumerStatefulWidget {
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

  void showGameResult(double currentTime) {
    if (currentTime == 0 && !_isDialogShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _isDialogShown = true;
        showDialog(
          context: context,
          builder: (context) => ResultDialog(
            screenName: const SingleLedGameScreen(),
            answer: 8,
            totalCone: 10,
            record: GameRecordModel(
              id: null,
              totalCone: 10,
              answerCone: 8,
              wrongCong: 2,
              totalTime: 60,
            ),
          ),
        ).then((value) => _isDialogShown = false);
      });
    }
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
    setState(() {});
  }

  void isFalse() {
    _isConeSuccess = false;
    _showLottieAnimation = true;
    ++negativeNum;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    currentTime = ref.watch(timeProvider);
    showGameResult(currentTime);
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
                            : const Text(" "),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: SingleConContainerWidget(
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
                      const StopButton(
                        screenName: SingleLedGameScreen(),
                      ),
                      TimerContainer(
                        maxTime: 60,
                        isTimerShow: ref.read(gameConfigProvider).isTest,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          //긍정 로띠
          if (_isConeSuccess && _showLottieAnimation)
            Align(
              alignment: Alignment.centerLeft,
              child: Lottie.asset(
                randomIndex == 1
                    ? 'assets/lottie/okay.json'
                    : 'assets/lottie/confetti.json',
                fit: BoxFit.cover,
                width: 400,
                height: 400,
                controller: _lottieController,
                onLoaded: (composition) {
                  _lottieController.duration = composition.duration;
                  _lottieController.forward(from: 0).then((_) {
                    Future.delayed(const Duration(seconds: 0), () {
                      setState(() {
                        _showLottieAnimation = false;
                      });
                    });
                  });
                },
              ),
            ),

          //부정 로띠
          if (!_isConeSuccess && _showLottieAnimation)
            Align(
              alignment: Alignment.center,
              child: Lottie.asset(
                randomIndex == 1
                    ? 'assets/lottie/normal.json'
                    : 'assets/lottie/clap.json',
                fit: BoxFit.cover,
                width: 200,
                height: 200,
                controller: _lottieController,
                onLoaded: (composition) {
                  _lottieController.duration = composition.duration;
                  _lottieController.forward(from: 0).then((_) {
                    Future.delayed(const Duration(seconds: 0), () {
                      setState(() {
                        _showLottieAnimation = false;
                      });
                    });
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}
