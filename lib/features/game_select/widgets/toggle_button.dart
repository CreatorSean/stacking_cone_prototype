import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/common/constants/gaps.dart';
import 'package:stacking_cone_prototype/common/constants/sizes.dart';
import 'package:stacking_cone_prototype/features/game_select/view_model/game_config_vm.dart';

class ToggleButton extends ConsumerStatefulWidget {
  const ToggleButton({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends ConsumerState<ToggleButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          ref.read(gameConfigProvider).isTest ? "평가형" : "훈련형",
          style: const TextStyle(
            fontSize: Sizes.size20,
            fontWeight: FontWeight.w600,
            fontFamily: 'NotosansKR-Medium',
            color: Colors.black,
          ),
        ),
        Gaps.h4,
        CupertinoSwitch(
          //active가 true이고 track이 false임
          trackColor: const Color(0xff4079E8),
          activeColor: const Color(0xff7DDD5C),
          value: ref.read(gameConfigProvider).isTest,
          onChanged: (bool value) {
            setState(
              () {
                ref.read(gameConfigProvider.notifier).setTest(value);
              },
            );
          },
        ),
        Gaps.h20,
      ],
    );
  }
}
