import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stacking_cone_prototype/features/home/view/main_scaffold.dart';
import 'package:stacking_cone_prototype/features/staff/view/patient_add_screen.dart';
import 'package:stacking_cone_prototype/features/staff/view/staff_screen.dart';

final routerProvier = Provider(
  (ref) {
    return GoRouter(
      initialLocation: "/home",
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
        GoRoute(
          path: PatientAddScreen.routeURL,
          name: PatientAddScreen.routeName,
          pageBuilder: (context, state) => const MaterialPage(
            child: PatientAddScreen(),
          ),
        ),
      ],
    );
  },
);
