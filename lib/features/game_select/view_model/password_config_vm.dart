import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/features/staff/widgets/showErrorSnack.dart';
import 'package:stacking_cone_prototype/services/database/database_service.dart';
import 'package:stacking_cone_prototype/services/database/models/password_model.dart';

class PasswordConfigViewModel extends AsyncNotifier<PasswordModel> {
  PasswordModel myPassword = PasswordModel(
    id: 0,
    password: '659371',
  );

  Future<void> insertPassword(BuildContext context) async {
    state = const AsyncValue.loading();
    await AsyncValue.guard(() async {
      // Logger().d("Setting View Model : User insert ${user.userName}");
      DatabaseService.insertDB(myPassword, "Password");
    });

    if (state.hasError) {
      showErrorSnack(context);
    } else {
      //Navigator.pop(context);
      //context.goNamed(MainScaffold.routeName);
    }
  }

  @override
  FutureOr<PasswordModel> build() {
    return myPassword;
  }
}

final passwordConfigViewModelProvider =
    AsyncNotifierProvider<PasswordConfigViewModel, PasswordModel>(() {
  return PasswordConfigViewModel();
});
