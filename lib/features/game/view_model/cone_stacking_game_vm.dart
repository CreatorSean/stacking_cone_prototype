import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConeStackingGameViewModel extends StateNotifier<ConeStackingGameState> {
  ConeStackingGameViewModel() : super(ConeStackingGameState.initial());

  void startStackingGame() {
    List<int> list = [];
    state.copyWith(gameRule: List.empty());
    list.add(state.targetIndex);
    state = state.copyWith(
      gameRule: list,
      targetIndex: state.targetIndex,
    );
  }

  void setTargetIndex(int newIndex) {
    state = state.copyWith(targetIndex: newIndex);
  }

  void setGameMode(String gameMode) {
    state = state.copyWith(
      gameMode: gameMode,
    );
  }
}

class ConeStackingGameState {
  List<int> gameRule;
  int targetIndex;
  String gameMode;

  ConeStackingGameState(
      {required this.gameRule,
      required this.targetIndex,
      required this.gameMode});

  ConeStackingGameState.initial()
      : gameRule = [0, 0],
        targetIndex = 0,
        gameMode = "";

  ConeStackingGameState copyWith({
    List<int>? gameRule,
    int? targetIndex,
    String? gameMode,
  }) {
    return ConeStackingGameState(
      gameRule: gameRule ?? this.gameRule,
      targetIndex: targetIndex ?? this.targetIndex,
      gameMode: gameMode ?? this.gameMode,
    );
  }
}

final gameProvider =
    StateNotifierProvider<ConeStackingGameViewModel, ConeStackingGameState>(
        (ref) {
  return ConeStackingGameViewModel();
});
