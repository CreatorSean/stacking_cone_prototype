import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:stacking_cone_prototype/common/constants/gaps.dart';
import 'package:stacking_cone_prototype/common/main_appbar.dart';
import 'package:stacking_cone_prototype/features/game/view_model/current_time_vm.dart';
import 'package:stacking_cone_prototype/features/game/widgets/cone_container_widget.dart';
import 'package:stacking_cone_prototype/features/game/widgets/result_dialog_widget.dart';
import 'package:stacking_cone_prototype/features/game/widgets/stop_button.dart';
import 'package:stacking_cone_prototype/features/game/widgets/timer_container.dart';
import 'package:stacking_cone_prototype/features/game_select/view_model/game_config_vm.dart';

class ConeStackingGameScreen extends ConsumerStatefulWidget {
  const ConeStackingGameScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConeStackingGameScreenState();
}

class _ConeStackingGameScreenState extends ConsumerState<ConeStackingGameScreen>
    with TickerProviderStateMixin {
  bool _isDialogShown = false;
  final bool _isConeSuccess = true; //콘 꽂았을 때 효과
  late final AnimationController _lottieController;

  void showGameResult(double currentTime) {
    if (currentTime == 0 && !_isDialogShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _isDialogShown = true;
        ResultDialogWidget(
          answer: 8,
          totalCone: 10,
          screenName: const ConeStackingGameScreen(),
        ).resultDialog(context).then((value) => _isDialogShown = false);
      });
    }
  }

  @override
  void initState() {
    _lottieController = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTime = ref.watch(currentTimeProvider);
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
                          "콘 쌓기 MODE",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    if (_isConeSuccess)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "잘했어요!",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    if (!_isConeSuccess)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "다시 한 번 해보세요!",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                  ],
                ),
                const Expanded(
                  child: ConContainerWidget(),
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
                        screenName: ConeStackingGameScreen(),
                      ),
                      TimerContainer(
                        maxTime: 5,
                        isTimerShow: ref.read(gameConfigProvider).isTest,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isConeSuccess)
            Align(
              alignment: Alignment.centerLeft,
              child: Lottie.asset(
                'assets/lottie/confetti.json',
                fit: BoxFit.cover,
                width: 600,
                height: 500,
                controller: _lottieController,
                onLoaded: (composition) {
                  _lottieController.duration = composition.duration;
                  _lottieController.forward(from: 0);
                },
              ),
            ),
          if (!_isConeSuccess)
            Align(
              alignment: Alignment.centerLeft,
              child: Lottie.asset(
                'assets/lottie/okay.json',
                fit: BoxFit.cover,
                width: 400,
                height: 400,
                controller: _lottieController,
                onLoaded: (composition) {
                  _lottieController.duration = composition.duration;
                  _lottieController.forward(from: 0);
                },
              ),
            ),
        ],
      ),
    );
  }
}
