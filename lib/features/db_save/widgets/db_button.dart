import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stacking_cone_prototype/common/constants/sizes.dart';
import 'package:stacking_cone_prototype/features/game/view_model/cone_stacking_game_vm.dart';
import 'package:stacking_cone_prototype/features/game_select/view_model/game_config_vm.dart';
import 'package:stacking_cone_prototype/services/bluetooth_service/view_models/bluetooth_service.dart';
import 'package:stacking_cone_prototype/services/timer/timer_service.dart';

class DbButton extends ConsumerStatefulWidget {
  final String buttonName;

  const DbButton({
    super.key,
    required this.buttonName,
  });

  @override
  ConsumerState<DbButton> createState() => _DbButtonState();
}

class _DbButtonState extends ConsumerState<DbButton> {
  Future<String> getDatabasePath() async {
    final databasePath = await getDatabasesPath();
    return join(databasePath, 'StackingCone.db'); // 여기에 실제 데이터베이스 파일 이름을 넣으세요
  }

  Future<void> shareDatabase() async {
    final databasePath = await getDatabasePath();
    final File databaseFile = File(databasePath);
    final XFile xfile = XFile(databaseFile.path);

    try {
      await Share.shareXFiles(
        [xfile],
        text: 'Here is the database file.',
        subject: 'Database File',
      );
    } on PlatformException catch (e) {
      print('Error sharing file: $e');
    } catch (error) {
      print('Unexpected error sharing file: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        shareDatabase();
      },
      child: FractionallySizedBox(
        widthFactor: 0.6,
        child: AnimatedContainer(
          height: 70,
          padding: const EdgeInsets.symmetric(
            vertical: Sizes.size16,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Sizes.size20),
            color: Theme.of(context).primaryColor,
          ),
          duration: const Duration(
            milliseconds: 300,
          ),
          child: AnimatedDefaultTextStyle(
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            duration: const Duration(
              milliseconds: 300,
            ),
            child: Text(
              widget.buttonName,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ),
      ),
    );
  }
}
