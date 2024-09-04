import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stacking_cone_prototype/features/game/views/cone_stacking_game/cone_stacking_game_screen.dart';
import 'package:stacking_cone_prototype/features/game/views/multiple_led_game/multiple_led_game_screen.dart';
import 'package:stacking_cone_prototype/features/home/view/main_scaffold.dart';
import 'package:stacking_cone_prototype/features/result/view/result_screen.dart';
import 'package:stacking_cone_prototype/features/staff/view/patient_add_screen.dart';
import 'package:stacking_cone_prototype/features/staff/view/staff_screen.dart';

final routerProvier = Provider(
  (ref) {
    return GoRouter(
      initialLocation: MainScaffold.routeURL,
      routes: [
        // GoRoute(
        //   path: HomeScreen.routeURL,
        //   name: HomeScreen.routeName,
        //   pageBuilder: (context, state) => const MaterialPage(
        //     child: HomeScreen(),
        //   ),
        // ),
        GoRoute(
          path: MainScaffold.routeURL,
          name: MainScaffold.routeName,
          pageBuilder: (context, state) => const MaterialPage(
            child: MainScaffold(),
          ),
        ),
        GoRoute(
          path: StaffScreen.routeURL,
          name: StaffScreen.routeName,
          pageBuilder: (context, state) => const MaterialPage(
            child: StaffScreen(),
          ),
        ),
        // GoRoute(
        //   path: PatientAddScreen.routeURL,
        //   name: PatientAddScreen.routeName,
        //   pageBuilder: (context, state) => const MaterialPage(
        //     child: PatientAddScreen(),
        //   ),
        // ),
        // GoRoute(
        //   path: ConeStackingGameScreen.routeURL,
        //   name: ConeStackingGameScreen.routeName,
        //   pageBuilder: (context, state) => const MaterialPage(
        //     child: ConeStackingGameScreen(),
        //   ),
        // ),
        // GoRoute(
        //   path: MultipleLedGameScreen.routeURL,
        //   name: MultipleLedGameScreen.routeName,
        //   pageBuilder: (context, state) =>  MaterialPage(
        //     child: MultipleLedGameScreen(),
        //   ),
        // ),
        GoRoute(
          path: ResultScreen.routeURL,
          name: ResultScreen.routeName,
          pageBuilder: (context, state) => const MaterialPage(
            child: ResultScreen(),
          ),
        ),
      ],
    );
  },
);
