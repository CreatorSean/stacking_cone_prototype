import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final randomIndexProvider =
    StateNotifierProvider<RandomIndexController, TargetState>((ref) {
  return RandomIndexController();
});

class RandomIndexController extends StateNotifier<TargetState> {
  RandomIndexController() : super(TargetState.initial());

  void setIndex() {
    int newIndex = Random().nextInt(3);
    state = state.copyWith(targetIndex: newIndex);
  }
}

class TargetState {
  int targetIndex;
  final bool isRunning;

  TargetState({required this.targetIndex, this.isRunning = false});

  TargetState.initial()
      : targetIndex = 0,
        isRunning = false;

  TargetState copyWith({
    int? targetIndex,
    bool? isRunning,
  }) {
    return TargetState(
      targetIndex: targetIndex ?? this.targetIndex,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}
