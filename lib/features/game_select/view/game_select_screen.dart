import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/common/constants/gaps.dart';
import 'package:stacking_cone_prototype/common/main_appbar.dart';
import 'package:stacking_cone_prototype/features/db_save/views/db_save_screen.dart';
import 'package:stacking_cone_prototype/features/game/views/cone_stacking_game/cone_stacking_game_screen.dart';
import 'package:stacking_cone_prototype/features/game/views/multiple_led_game/multiple_led_game_screen.dart';
import 'package:stacking_cone_prototype/features/game_select/widgets/common_button.dart';
import 'package:stacking_cone_prototype/features/game_select/widgets/difficult_select_button.dart';
import 'package:stacking_cone_prototype/features/staff/view_model/selected_patient_view_model.dart';
import 'package:stacking_cone_prototype/features/staff/widgets/info_container.dart';
import 'package:stacking_cone_prototype/services/database/models/patient_model.dart';

class GameSelectScreen extends ConsumerStatefulWidget {
  static String routeURL = '/select';
  static String routeName = 'select';
  const GameSelectScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GameSelectScreenState();
}

class _GameSelectScreenState extends ConsumerState<GameSelectScreen> {
  @override
  Widget build(BuildContext context) {
    PatientModel selectedPatient = ref
        .read(SelectedPatientViewModelProvider.notifier)
        .getSelectedPatient();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: MainAppBar(
          isSelectScreen: true,
        ),
      ),
      body: Column(
        children: [
          Column(
            children: [
              Divider(
                height: 2,
                thickness: 1,
                color: Theme.of(context).primaryColor,
              ),
              InfoContainer(
                selectedPatient: selectedPatient,
                isSetting: false,
              ),
              Gaps.v1,
              Divider(
                height: 2,
                thickness: 1,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),

          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Select Game",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              Gaps.v72,
              const Column(
                children: [
                  CommonButton(
                    screenName: ConeStackingGameScreen(),
                    buttonName: "콘 쌓기 MODE",
                  ),
                  Gaps.v32,
                  CommonButton(
                    screenName: MultipleLedGameScreen(),
                    buttonName: "다중 LED MODE",
                  ),
                  Gaps.v32,
                  CommonButton(
                    screenName: DbSaveScreen(),
                    buttonName: "DB 저장",
                  ),
                ],
              ),
            ],
          ),

          // Gaps.v32,
          // const CommonButton(
          //   screenName: MultipleLedGameScreen(),
          //   buttonName: "이중 LED MODE",
          // ),
          // Gaps.v32,
          // const DifficultSelectButton(),
        ],
      ),
    );
  }
}
