import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/common/constants/gaps.dart';
import 'package:stacking_cone_prototype/common/main_appbar.dart';
import 'package:stacking_cone_prototype/features/game/widgets/cone_container_widget.dart';
import 'package:stacking_cone_prototype/features/game/widgets/stop_button.dart';
import 'package:stacking_cone_prototype/features/game/widgets/timer_container.dart';

class ConeStackingGameScreen extends ConsumerStatefulWidget {
  const ConeStackingGameScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConeStackingGameScreenState();
}

class _ConeStackingGameScreenState
    extends ConsumerState<ConeStackingGameScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: MainAppBar(
          isSelectScreen: false,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          bottom: 40,
        ),
        child: Column(
          children: [
            Expanded(
              child: ConContainerWidget(),
            ),
            Gaps.v20,
            // Padding(
            //   padding: EdgeInsets.only(right: 200),
            //   child: StopButton(),
            // ),
            Padding(
              padding: EdgeInsets.only(
                right: 30,
                left: 30,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  StopButton(),
                  TimerContainer(
                    maxTime: 60,
                    currentTime: 60,
                    isTimerShow: true,
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
