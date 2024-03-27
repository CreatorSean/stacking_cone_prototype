import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class _ConeStackingGameScreenState
    extends ConsumerState<ConeStackingGameScreen> {
  bool _isDialogShown = false;
  @override
  Widget build(BuildContext context) {
    final currentTime = ref.watch(currentTimeProvider);
    if (currentTime == 0 && !_isDialogShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _isDialogShown = true; // 대화 상자가 표시됨을 표시
        ResultDialogWidget(
          answer: 8,
          totalCone: 10,
          screenName: const ConeStackingGameScreen(),
        )
            .resultDialog(context)
            .then((value) => _isDialogShown = false); // 대화 상자가 닫히면 플래그를 재설정
      });
    }
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: MainAppBar(
          isSelectScreen: false,
        ),
      ),
      body: Padding(
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
    );
  }
}
