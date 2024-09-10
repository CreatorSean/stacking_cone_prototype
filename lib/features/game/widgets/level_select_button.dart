import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/common/constants/sizes.dart';

class LevelSelectButton extends ConsumerStatefulWidget {
  final String buttonName;
  final double width;
  final double height;
  final bool isSelected;
  const LevelSelectButton({
    super.key,
    required this.buttonName,
    required this.width,
    required this.height,
    required this.isSelected,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LevelSelectButtonState();
}

class _LevelSelectButtonState extends ConsumerState<LevelSelectButton> {
  // void _onGameLevelSelectTap() {
  //   if (widget.buttonName == '쉬움') {
  //     ref.watch(gameProvider).gameMode = '쉬움';
  //   } else if (widget.buttonName == '보통') {
  //     ref.watch(gameProvider).gameMode = '보통';
  //   } else {
  //     ref.watch(gameProvider).gameMode = '어려움';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth * 0.04;

    return AnimatedContainer(
      width: widget.width,
      height: widget.height,
      padding: const EdgeInsets.symmetric(
        vertical: Sizes.size16,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Sizes.size10),
        color: widget.isSelected
            ? Theme.of(context).primaryColor
            : Colors.grey.shade300,
      ),
      duration: const Duration(
        milliseconds: 10,
      ),
      child: AnimatedDefaultTextStyle(
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        duration: const Duration(
          milliseconds: 300,
        ),
        child: Text(
          widget.buttonName,
          textAlign: TextAlign.center,
          style: widget.isSelected
              ? Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(fontSize: fontSize)
              : Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(fontSize: fontSize, color: Colors.black54),
        ),
      ),
    );
  }
}
