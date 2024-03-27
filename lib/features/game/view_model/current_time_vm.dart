import 'package:flutter_riverpod/flutter_riverpod.dart';

double currentTime = 5;
double maxTime = 5;

final currentTimeProvider = StateProvider<double>((ref) {
  return maxTime; // 초기값 설정
});
