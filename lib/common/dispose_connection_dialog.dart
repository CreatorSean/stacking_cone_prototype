import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/services/bluetooth_service/view_models/bluetooth_service.dart';

import '../features/staff/widgets/showErrorSnack.dart';

class DisposeConnectionDialog extends ConsumerWidget {
  const DisposeConnectionDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final titleFontSize = screenWidth * 0.07;
    final mediumFontSize = screenWidth * 0.03;
    return AlertDialog(
      title: Center(
        child: Text(
          '블루투스 연결을 끊겠습니까?',
          style: TextStyle(
            fontSize: mediumFontSize,
          ),
        ),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
                ref.watch(bluetoothServiceProvider.notifier).dispose();
                showErrorSnack(context, '블루투스와의 연결이 해제되었습니다!');
              },
            ),
          ],
        )
      ],
    );
  }
}
