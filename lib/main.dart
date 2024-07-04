import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacking_cone_prototype/common/constants/sizes.dart';
import 'package:stacking_cone_prototype/features/game_select/repos/game_config_repo.dart';
import 'package:stacking_cone_prototype/features/game_select/view/game_select_screen.dart';
import 'package:stacking_cone_prototype/features/game_select/view_model/game_config_vm.dart';
import 'package:stacking_cone_prototype/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  final repository = GameConfigRepository(preferences);

  runApp(
    ProviderScope(
      overrides: [
        gameConfigProvider.overrideWith(
          () => GameConfigViewModel(repository),
        )
      ],
      child: const StackingConePrototype(),
    ),
  );
}

class StackingConePrototype extends ConsumerWidget {
  const StackingConePrototype({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvier);
    FlexScheme deepBlue = FlexScheme.deepBlue;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      title: 'Stacking Cone',
      theme: FlexThemeData.light(
        scheme: deepBlue,
        appBarElevation: 0.5,
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: Color(0xFF223A5E),
            fontFamily: 'NotosansKR-Bold',
            fontSize: Sizes.size40,
          ),
          titleMedium: TextStyle(
            color: Color(0xFF223A5E),
            fontFamily: 'NotosansKR-Medium',
            fontSize: Sizes.size28,
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
            fontSize: Sizes.size24,
          ),
          labelSmall: TextStyle(
            color: Colors.black,
            fontFamily: 'NotosansKR-Regular',
            fontSize: Sizes.size20,
          ),
        ),
      ),
      darkTheme: FlexThemeData.dark(
        scheme: deepBlue,
        appBarElevation: 2,
      ),
      themeMode: ThemeMode.light,
    );
  }
}
