import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/common/constants/gaps.dart';
import 'package:stacking_cone_prototype/common/main_appbar.dart';
import 'package:stacking_cone_prototype/features/game/widgets/cone_container_widget.dart';
import 'package:stacking_cone_prototype/features/game/widgets/stop_button.dart';
import 'package:stacking_cone_prototype/features/game/widgets/timer_container.dart';

class MultipleLedGameScreen extends ConsumerStatefulWidget {
  const MultipleLedGameScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MultipleLedGameScreenState();
}

class _MultipleLedGameScreenState extends ConsumerState<MultipleLedGameScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: MainAppBar(
          isSelectScreen: false,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ConContainerWidget(),
          ),
          Gaps.v20,
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
    );
  }
}
