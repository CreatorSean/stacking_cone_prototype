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
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: MainAppBar(
          isSelectScreen: false,
        ),
      ),
      body: Column(
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
            ],
          ),
          const Expanded(
            child: ConContainerWidget(),
          ),
          Gaps.v20,
          const Padding(
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
