import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/features/game_select/view_model/game_config_vm.dart';
import 'package:stacking_cone_prototype/services/database/models/game_model.dart';

class TimerService extends AsyncNotifier<GameModel> {
  late int time;
  late Timer? _timer;

  final gameModel = GameModel(time: 0);

  void startTimer() {
    if (ref.read(gameConfigProvider).isTest) {
      time = 60;
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        time--;
        gameModel.time = time;
        if (time == 0) {
          pauseTimer();
        }
      });
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        time++;
        gameModel.time = time;
      });
    }
  }

  void pauseTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  FutureOr<GameModel> build() {
    return gameModel;
  }
}

final timerServiceProvider =
    AsyncNotifierProvider<TimerService, GameModel>(() => TimerService());
