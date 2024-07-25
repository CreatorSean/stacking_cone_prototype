import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/features/game_select/model/game_config_model.dart';
import 'package:stacking_cone_prototype/features/game_select/repos/game_config_repo.dart';

class GameConfigViewModel extends Notifier<GameConfigModel> {
  final GameConfigRepository _repository;

  GameConfigViewModel(this._repository);

  void setTest(bool value) {
    _repository.setTest(value);
    state = GameConfigModel(
      isTest: value,
      isMode: state.isMode,
    );
  }

  void setMode(bool isMode) {
    state = GameConfigModel(
      isTest: state.isTest,
      isMode: isMode,
    );
  }

  @override
  GameConfigModel build() {
    return GameConfigModel(
      isTest: _repository.isTest(),
      isMode: _repository.isMode(),
    );
  }
}

final gameConfigProvider =
    NotifierProvider<GameConfigViewModel, GameConfigModel>(
  () => throw UnimplementedError(),
);
