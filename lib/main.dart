import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/features/game_select/view/game_select_screen.dart';

void main() {
  runApp(const StackingConePrototype());
}

class StackingConePrototype extends ConsumerWidget {
  const StackingConePrototype({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    FlexScheme deepBlue = FlexScheme.deepBlue;

    return MaterialApp(
      title: 'Stacking Cone',
      theme: FlexThemeData.light(
        scheme: deepBlue,
      ),
      home: const GameSelectScreen(),
    );
  }
}
