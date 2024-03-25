import 'package:shared_preferences/shared_preferences.dart';

class GameConfigRepository {
  static const String _isTest = "isTest";
  final SharedPreferences _preferences;

  GameConfigRepository(this._preferences);

  Future<void> setTest(bool value) async {
    _preferences.setBool(_isTest, value);
  }

  bool isTest() {
    return _preferences.getBool(_isTest) ?? false;
  }
}
