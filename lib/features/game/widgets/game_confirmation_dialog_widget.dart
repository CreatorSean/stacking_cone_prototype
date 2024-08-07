import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/features/game_select/view_model/game_config_vm.dart';
import 'package:stacking_cone_prototype/features/staff/view_model/selected_patient_view_model.dart';
import 'package:stacking_cone_prototype/services/database/models/patient_model.dart';

class GameConfirmationDialog extends ConsumerWidget {
  final VoidCallback onStartLottie;

  const GameConfirmationDialog({super.key, required this.onStartLottie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PatientModel selectedPatient = ref
        .read(SelectedPatientViewModelProvider.notifier)
        .getSelectedPatient();
    final config = ref.read(gameConfigProvider);

    String userName = selectedPatient.userName;
    String mode = config.isMode ? '콘 쌓기' : '다중 LED';
    String trainOrTest = config.isTest ? '평가 모드' : '훈련 모드';

    return AlertDialog(
      title: const Text("게임 시작 확인"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("이름: $userName"),
          Text("모드: $mode"),
          Text("훈련 모드: $trainOrTest"),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          child: const Text("취소"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onStartLottie();
          },
          child: const Text("시작하기"),
        ),
      ],
    );
  }
}
