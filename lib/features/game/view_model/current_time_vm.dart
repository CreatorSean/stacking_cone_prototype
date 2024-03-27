import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentTimeProvider = StateProvider<double>((ref) {
  return 5; // 초기값 설정
});
