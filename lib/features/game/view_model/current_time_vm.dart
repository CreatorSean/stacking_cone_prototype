import 'package:flutter_riverpod/flutter_riverpod.dart';

double currentTime = 60;

final timeProvider = StateProvider<double>((ref) {
  return currentTime; // 초기값 설정
});
