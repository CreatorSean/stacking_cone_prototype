import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConeStackingGameViewModel extends StateNotifier<ConeStackingGameState> {
  ConeStackingGameViewModel() : super(ConeStackingGameState.initial());

  void startGame() {
    List<int> list = [];
    int newIndex = Random().nextInt(3);
    list.add(newIndex);
    list.add(1);
    state = state.copyWith(
      gameRule: list,
      targetIndex: newIndex,
    );
    print(list);
  }
}

class ConeStackingGameState {
  List<int> gameRule;
  int targetIndex;

  ConeStackingGameState({required this.gameRule, required this.targetIndex});

  ConeStackingGameState.initial()
      : gameRule = [0, 0],
        targetIndex = 0;

  ConeStackingGameState copyWith({
    List<int>? gameRule,
    int? targetIndex,
  }) {
    return ConeStackingGameState(
      gameRule: gameRule ?? this.gameRule,
      targetIndex: targetIndex ?? this.targetIndex,
    );
  }
}

final coneStackingGameProvider =
    StateNotifierProvider<ConeStackingGameViewModel, ConeStackingGameState>(
        (ref) {
  return ConeStackingGameViewModel();
});
