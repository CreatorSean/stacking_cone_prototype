import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stacking_cone_prototype/common/constants/gaps.dart';
import 'package:stacking_cone_prototype/common/main_appbar.dart';
import 'package:stacking_cone_prototype/features/db_save/views/db_save_screen.dart';

import 'package:stacking_cone_prototype/features/game/views/cone_stacking_game/cone_stacking_game_screen.dart';
import 'package:stacking_cone_prototype/features/game/views/multiple_led_game/multiple_led_game_screen.dart';
import 'package:stacking_cone_prototype/features/game/views/single_led_game/single_led_game_screen.dart';

import 'package:stacking_cone_prototype/features/game_select/widgets/common_button.dart';
import 'package:stacking_cone_prototype/features/game_select/widgets/difficult_select_button.dart';

class GameSelectScreen extends ConsumerStatefulWidget {
  const GameSelectScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GameSelectScreenState();
}

class _GameSelectScreenState extends ConsumerState<GameSelectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: MainAppBar(
          isSelectScreen: true,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Select Game",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          Gaps.v150,
          const CommonButton(
            screenName: ConeStackingGameScreen(),
            buttonName: "콘 쌓기 MODE",
          ),
          Gaps.v32,
          const CommonButton(
            screenName: SingleLedGameScreen(),
            buttonName: "단일 LED MODE",
          ),
          Gaps.v32,
          const CommonButton(
            screenName: DbSaveScreen(),
            buttonName: "DB 저장",
          ),
          // Gaps.v32,
          // const CommonButton(
          //   screenName: MultipleLedGameScreen(),
          //   buttonName: "이중 LED MODE",
          // ),
          Gaps.v32,
          const DifficultSelectButton(),
        ],
      ),
    );
  }
}
