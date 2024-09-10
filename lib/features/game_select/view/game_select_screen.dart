import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/common/constants/gaps.dart';
import 'package:stacking_cone_prototype/common/main_appbar.dart';
import 'package:stacking_cone_prototype/features/game/views/cone_stacking_game/cone_stacking_game_screen.dart';
import 'package:stacking_cone_prototype/features/game/views/multiple_led_game/multiple_led_game_screen.dart';
import 'package:stacking_cone_prototype/features/game_select/widgets/common_button.dart';
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
    final selectedPatientState = ref.watch(SelectedPatientViewModelProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: MainAppBar(
          isSelectScreen: true,
        ),
      ),
      body: selectedPatientState.when(
        data: (PatientModel selectedPatient) {
          return Column(
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
              Column(
                children: [
                  Gaps.v72,
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
                  Column(
                    children: [
                      const CommonButton(
                        screenName: ConeStackingGameScreen(),
                        buttonName: "운동 재활",
                      ),
                      Gaps.v32,
                      CommonButton(
                        screenName: MultipleLedGameScreen(
                          level: '',
                        ),
                        buttonName: "인지 재활",
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('오류 발생: $error')),
      ),
    );
  }
}
