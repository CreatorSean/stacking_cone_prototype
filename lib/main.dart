import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/common/constants/sizes.dart';
import 'package:stacking_cone_prototype/features/game_select/view/game_select_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: StackingConePrototype(),
    ),
  );
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
        appBarElevation: 0.5,
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: Color(0xFF223A5E),
            fontFamily: 'NotosansKR-Bold',
            fontSize: Sizes.size48,
          ),
          titleMedium: TextStyle(
            color: Color(0xFF223A5E),
            fontFamily: 'NotosansKR-Medium',
          ),
          titleSmall: TextStyle(
            color: Color(0xFF223A5E),
            fontFamily: 'NotosansKR-Regular',
          ),
          labelLarge: TextStyle(
            color: Color(0xFFF8F9FA),
            fontFamily: 'NotosansKR-Bold',
          ),
          labelMedium: TextStyle(
            color: Color(0xFFF8F9FA),
            fontFamily: 'NotosansKR-Medium',
            fontSize: Sizes.size16,
          ),
          labelSmall: TextStyle(
            color: Colors.black,
            fontFamily: 'NotosansKR-Regular',
          ),
        ),
      ),
      darkTheme: FlexThemeData.dark(
        scheme: deepBlue,
        appBarElevation: 2,
      ),
      home: const GameSelectScreen(),
    );
  }
}
