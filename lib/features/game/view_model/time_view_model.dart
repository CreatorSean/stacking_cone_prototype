import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/services/database/models/game_model.dart';

class TimeViewModel extends StateNotifier<GameTimeModel> {
  TimeViewModel()
      : super(
          GameTimeModel(
            currentTime: 5,
            maxTime: 5,
          ),
        );

  void setTimer(double currentTime, double maxTime) {}
}

final timerProvider =
    StateNotifierProvider<TimeViewModel, GameTimeModel>((ref) {
  return TimeViewModel();
});
