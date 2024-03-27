import 'package:flutter_riverpod/flutter_riverpod.dart';

double currentTime = 5;

final currentTimeProvider = StateProvider<double>((ref) {
  return currentTime; // 초기값 설정
});
