import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:stacking_cone_prototype/common/constants/gaps.dart';
import 'package:stacking_cone_prototype/common/main_appbar.dart';
import 'package:stacking_cone_prototype/features/game/widgets/cone_container_widget.dart';
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
  late final AnimationController _lottieController;
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
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: MainAppBar(
          isSelectScreen: false,
        ),
      ),
      body: Stack(
        children: [
          // Positioned.fill(
          //   child: Lottie.asset(
          //     'assets/lottie/confetti.json',
          //     fit: BoxFit.cover,
          //     controller: _lottieController,
          //     onLoaded: (composition) {
          //       _lottieController.duration = composition.duration;
          //       _lottieController.forward(from: 0.5);
          //     },
          //   ),
          // ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "잘했어요!",
                          style: Theme.of(context).textTheme.titleLarge,
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
                        maxTime: 60,
                        currentTime: 60,
                        isTimerShow: ref.read(gameConfigProvider).isTest,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
