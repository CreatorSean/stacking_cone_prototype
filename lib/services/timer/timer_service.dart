import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final timerControllerProvider =
    StateNotifierProvider<TimerController, TimerState>((ref) {
  return TimerController();
});

class TimerController extends StateNotifier<TimerState> {
  Timer? _timer;

  TimerController() : super(TimerState.initial());

  void startTimer() {
    state.time = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state.copyWith(time: state.time + 1);
    });
  }

  void startTestTimer() {
    state.time = 10;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state.copyWith(time: state.time - 1);
      if (state.time == 0) {
        stopTimer();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }
}

class TimerState {
  int time;
  final bool isRunning;

  TimerState({required this.time, this.isRunning = false});

  TimerState.initial()
      : time = 0,
        isRunning = false;

  TimerState copyWith({
    int? time,
    bool? isRunning,
  }) {
    return TimerState(
      time: time ?? this.time,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}
