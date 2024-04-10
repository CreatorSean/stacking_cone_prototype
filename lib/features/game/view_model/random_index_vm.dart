import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final randomIndexProvider =
    StateNotifierProvider<RandomIndexController, TargetState>((ref) {
  return RandomIndexController();
});

class RandomIndexController extends StateNotifier<TargetState> {
  RandomIndexController() : super(TargetState.initial());

  void setIndex() {
    state.targetIndex = Random().nextInt(3);
  }
}

class TargetState {
  int targetIndex;
  final bool isRunning;

  TargetState({required this.targetIndex, this.isRunning = false});

  TargetState.initial()
      : targetIndex = Random().nextInt(3),
        isRunning = false;

  TargetState copyWith({
    int? time,
    bool? isRunning,
  }) {
    return TargetState(
      targetIndex: time ?? targetIndex,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}
