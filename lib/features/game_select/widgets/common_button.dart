import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/common/constants/sizes.dart';
import 'package:stacking_cone_prototype/features/game/widgets/game_confirmation_dialog_widget.dart';
import 'package:stacking_cone_prototype/features/game_select/view_model/game_config_vm.dart';
import 'package:stacking_cone_prototype/features/staff/widgets/showErrorSnack.dart';
import 'package:stacking_cone_prototype/services/timer/timer_service.dart';

import '../../../services/bluetooth_service/view_models/bluetooth_service.dart';

// class CommonButton extends ConsumerStatefulWidget {
//   final Widget screenName;
//   final String buttonName;

//   const CommonButton({
//     super.key,
//     required this.screenName,
//     required this.buttonName,
//   });

//   @override
//   ConsumerState<CommonButton> createState() => _CommonButtonState();
// }

// class _CommonButtonState extends ConsumerState<CommonButton> {
//   Color btnColor = Colors.grey;
//   void _showConfirmationDialog(
//       bool isConnecting, bool isCalibrating, bool isOffsetting) {
//     if (!isConnecting) {
//       showErrorSnack(context, '블루투스 연결이 필요합니다!');
//       return;
//     }
//     if (!isOffsetting) {
//       if (widget.buttonName == '운동 재활' ||
//           widget.buttonName == '인지 재활' ||
//           widget.buttonName == 'Calibration') {
//         showErrorSnack(context, '오프셋을 진행해주세요!');
//         return;
//       }
//     }
//     if (!isCalibrating) {
//       if (widget.buttonName == '운동 재활' || widget.buttonName == '인지 재활') {
//         showErrorSnack(context, '캘리브레이션을 진행해주세요!');
//         return;
//       }
//     }
//     if (widget.buttonName == '운동 재활' || widget.buttonName == '인지 재활') {
//       if (ref.watch(gameConfigProvider).isTest == true) {
//         ref.watch(timerControllerProvider.notifier).setTimerTime(10);
//       }
//       ref.read(gameConfigProvider.notifier).setMode(false);

//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return GameConfirmationDialog(
//               screenName: widget.screenName,
//               gameName: widget.buttonName,
//             );
//           },
//         );
//       });
//       return;
//     }
//     if (widget.buttonName == 'Offset') {
//       ref.read(bluetoothServiceProvider.notifier).doOffset('Z');
//       return;
//     }
//     if (widget.buttonName == 'Calibration') {
//       ref.read(bluetoothServiceProvider.notifier).doCalibration('C');
//       return;
//     }
//     setState(() {});
//   }

//   void getColor(bool isConnecting, bool isCalibrating, bool isOffsetting) {
//     final primary = Theme.of(context).primaryColor;

//     // 1단계: 연결 안 됨 → 전부 비활성
//     if (!isConnecting) {
//       btnColor = Colors.grey;
//       return;
//     }

//     // 2단계: Offset 아직 안 했음
//     if (!isOffsetting) {
//       btnColor = widget.buttonName == 'Offset' ? primary : Colors.grey;
//       return;
//     }

//     // 3단계: Calibration 아직 안 했음
//     if (!isCalibrating) {
//       btnColor = widget.buttonName == 'Calibration' ? primary : Colors.grey;
//       return;
//     }

//     // 4단계: 다 끝남 → 재활 버튼 활성화
//     if (widget.buttonName == '운동 재활' || widget.buttonName == '인지 재활') {
//       btnColor = primary;
//     } else {
//       btnColor = Colors.grey;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ref.watch(bluetoothServiceProvider).when(
//           data: (data) {
//             print(
//                 'connection : ${data.isConnecting}, calibration : ${data.isCalibrating}');
//             getColor(
//               data.isConnecting!,
//               data.isCalibrating!,
//               data.isOffsetting!,
//             );
//             // getColor(
//             //   true,
//             //   true,
//             // );
//             return GestureDetector(
//               onTap: () {
//                 _showConfirmationDialog(
//                   data.isConnecting!,
//                   data.isCalibrating!,
//                   data.isOffsetting!,
//                 );
//                 // _showConfirmationDialog(
//                 //   true,
//                 //   true,
//                 // );
//               },
//               child: FractionallySizedBox(
//                 widthFactor: 0.6,
//                 child: AnimatedContainer(
//                   height: 70,
//                   padding: const EdgeInsets.symmetric(
//                     vertical: Sizes.size16,
//                   ),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(Sizes.size20),
//                     color: btnColor,
//                   ),
//                   duration: const Duration(
//                     milliseconds: 300,
//                   ),
//                   child: AnimatedDefaultTextStyle(
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                     ),
//                     duration: const Duration(
//                       milliseconds: 300,
//                     ),
//                     child: Text(
//                       widget.buttonName,
//                       textAlign: TextAlign.center,
//                       style: Theme.of(context).textTheme.labelMedium,
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//           error: (err, stack) => Text("Error: $err"),
//           loading: () => const CircularProgressIndicator(),
//         );
//   }
// }
enum RehabPhase {
  disconnected,
  needOffset,
  needCalibration,
  needGram,
  ready,
}

enum ButtonType {
  offset,
  calibration,
  gram,
  motorRehab,
  cognitiveRehab,
}

class CommonButton extends ConsumerWidget {
  final Widget screenName;
  final String buttonName;

  const CommonButton({
    super.key,
    required this.screenName,
    required this.buttonName,
  });

  ButtonType _parseButtonType(String name) {
    switch (name) {
      case 'Offset':
        return ButtonType.offset;
      case 'Calibration':
        return ButtonType.calibration;
      case 'Gram':
        return ButtonType.gram;
      case '운동 재활':
        return ButtonType.motorRehab;
      case '인지 재활':
        return ButtonType.cognitiveRehab;
      default:
        return ButtonType.calibration;
    }
  }

  RehabPhase _getPhase({
    required bool isConnecting,
    required bool isOffsetting,
    required bool isCalibrating,
    required bool isGraming,
  }) {
    if (!isConnecting) return RehabPhase.disconnected;
    if (!isOffsetting) return RehabPhase.needOffset;
    if (!isCalibrating) return RehabPhase.needCalibration;
    if (!isGraming) return RehabPhase.needGram;
    return RehabPhase.ready;
  }

  Color _getButtonColor({
    required BuildContext context,
    required RehabPhase phase,
    required ButtonType buttonType,
  }) {
    final primary = Theme.of(context).primaryColor;

    switch (phase) {
      case RehabPhase.disconnected:
        return Colors.grey;

      case RehabPhase.needOffset:
        return buttonType == ButtonType.offset ? primary : Colors.grey;

      case RehabPhase.needCalibration:
        return buttonType == ButtonType.calibration ? primary : Colors.grey;

      case RehabPhase.needGram:
        return buttonType == ButtonType.gram ? primary : Colors.grey;

      case RehabPhase.ready:
        if (buttonType == ButtonType.motorRehab ||
            buttonType == ButtonType.cognitiveRehab) {
          return primary;
        }
        return Colors.grey;
    }
  }

  bool _canTap(RehabPhase phase, ButtonType type) {
    switch (phase) {
      case RehabPhase.disconnected:
        return false;

      case RehabPhase.needOffset:
        return type == ButtonType.offset;

      case RehabPhase.needCalibration:
        return type == ButtonType.calibration;

      case RehabPhase.needGram:
        return type == ButtonType.gram;

      case RehabPhase.ready:
        return type == ButtonType.motorRehab ||
            type == ButtonType.cognitiveRehab;
    }
  }

  void _handleTap({
    required BuildContext context,
    required WidgetRef ref,
    required RehabPhase phase,
    required ButtonType type,
  }) {
    if (!_canTap(phase, type)) {
      switch (phase) {
        case RehabPhase.disconnected:
          showErrorSnack(context, '블루투스 연결이 필요합니다!');
          return;

        case RehabPhase.needOffset:
          showErrorSnack(context, '오프셋을 진행해주세요!');
          return;

        case RehabPhase.needCalibration:
          showErrorSnack(context, '캘리브레이션을 진행해주세요!');
          return;

        case RehabPhase.needGram:
          showErrorSnack(context, 'Gram을 먼저 진행해주세요!');
          return;

        case RehabPhase.ready:
          return;
      }
    }

    if (type == ButtonType.offset) {
      ref.read(bluetoothServiceProvider.notifier).doOffset('Z');
      return;
    }

    if (type == ButtonType.calibration) {
      ref.read(bluetoothServiceProvider.notifier).doCalibration('C');
      return;
    }

    if (type == ButtonType.gram) {
      ref.read(bluetoothServiceProvider.notifier).doGram('G');
      return;
    }

    if (type == ButtonType.motorRehab || type == ButtonType.cognitiveRehab) {
      if (ref.read(gameConfigProvider).isTest == true) {
        ref.read(timerControllerProvider.notifier).setTimerTime(10);
      }
      ref.read(gameConfigProvider.notifier).setMode(false);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (_) => GameConfirmationDialog(
            screenName: screenName,
            gameName: buttonName,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(bluetoothServiceProvider).when(
          data: (data) {
            final isConnecting = data.isConnecting ?? false;
            final isOffsetting = data.isOffsetting ?? false;
            final isCalibrating = data.isCalibrating ?? false;
            final isGraming = data.isGraming ?? false;

            final type = _parseButtonType(buttonName);
            final phase = _getPhase(
              isConnecting: isConnecting,
              isOffsetting: isOffsetting,
              isCalibrating: isCalibrating,
              isGraming: isGraming,
            );

            final color = _getButtonColor(
              context: context,
              phase: phase,
              buttonType: type,
            );

            return GestureDetector(
              onTap: () => _handleTap(
                context: context,
                ref: ref,
                phase: phase,
                type: type,
              ),
              child: FractionallySizedBox(
                widthFactor: 0.6,
                child: AnimatedContainer(
                  height: 70,
                  padding: const EdgeInsets.symmetric(vertical: Sizes.size16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Sizes.size20),
                    color: color,
                  ),
                  duration: const Duration(milliseconds: 300),
                  child: Center(
                    child: Text(
                      buttonName,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ),
              ),
            );
          },
          error: (err, stack) => Text("Error: $err"),
          loading: () => const CircularProgressIndicator(),
        );
  }
}
