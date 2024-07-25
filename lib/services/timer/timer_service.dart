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
    _timer?.cancel(); // 기존 타이머가 있으면 취소
    state = TimerState(time: 0); // 타이머 상태 초기화
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state.copyWith(time: state.time + 1);
    });
  }

  void startTestTimer() {
    _timer?.cancel(); // 기존 타이머가 있으면 취소
    state = TimerState(time: 10); // 타이머 상태 초기화
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.time == 0) {
        stopTimer();
      } else {
        state = state.copyWith(time: state.time - 1);
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }
}

class TimerState {
  final int time;

  TimerState({required this.time});

  TimerState.initial() : time = 0;

  TimerState copyWith({int? time}) {
    return TimerState(time: time ?? this.time);
  }
}
