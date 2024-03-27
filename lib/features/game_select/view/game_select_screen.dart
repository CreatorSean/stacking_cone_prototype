import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacking_cone_prototype/common/constants/gaps.dart';
import 'package:stacking_cone_prototype/common/main_appbar.dart';
import 'package:stacking_cone_prototype/features/game/views/cone_stacking_game/cone_stacking_game_screen.dart';
import 'package:stacking_cone_prototype/features/game/views/multiple_led_game/multiple_led_game_screen.dart';
import 'package:stacking_cone_prototype/features/game_select/widgets/common_button.dart';

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
          Gaps.v80,
          const CommonButton(
            screenName: ConeStackingGameScreen(),
            buttonName: "콘 쌓기 Mode",
          ),
          Gaps.v60,
          const CommonButton(
            screenName: MultipleLedGameScreen(),
            buttonName: "이중 LED Mode",
          ),
        ],
      ),
    );
  }
}
