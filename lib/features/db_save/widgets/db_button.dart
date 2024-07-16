import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
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
    //final XFile xfile = XFile(databaseFile.path);

    Database database = await openDatabase(databasePath);
    List<Map> results = await database.rawQuery('SELECT * FROM GameRecords');

    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    Map<String, String> columnMapping = {
      'id': 'ID',
      'patientId': '환자 ID',
      'date': '날짜',
      'mode': '모드',
      'trainOrtest': '훈련/테스트',
      'totalCone': '총 콘 수',
      'answerCone': '정답 콘 수',
      'wrongCone': '오답 콘 수',
      'totalTime': '총 시간',
    };

    // 스타일 정의
    CellStyle rightAlignStyle =
        CellStyle(horizontalAlign: HorizontalAlign.Right);

    // 헤더 삽입
    List<String> headers = columnMapping.values.toList();
    for (int i = 0; i < headers.length; i++) {
      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
          .value = TextCellValue(headers[i]);
    }

    for (int i = 0; i < results.length; i++) {
      int j = 0;
      columnMapping.forEach((dbColumn, excelHeader) {
        String value;
        CellStyle? cellStyle;

        if (dbColumn == 'date') {
          // 날짜를 원하는 형식으로 변환
          String rawDate = results[i][dbColumn]?.toString() ?? '';
          DateTime? parsedDate = DateTime.tryParse(rawDate);
          value = parsedDate != null
              ? DateFormat('yyyy-MM-dd').format(parsedDate)
              : '';
        } else if (dbColumn == 'totalCone' ||
            dbColumn == 'answerCone' ||
            dbColumn == 'wrongCone' ||
            dbColumn == 'totalTime') {
          // 수치를 문자열로 변환하고 우측 정렬 스타일 지정
          value = results[i][dbColumn]?.toString() ?? '';
          cellStyle = rightAlignStyle;
        } else {
          value = results[i][dbColumn]?.toString() ?? '';
        }

        // 데이터 삽입 및 스타일 적용
        final cell = sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i + 1));
        cell.value = TextCellValue(value);

        if (cellStyle != null) {
          cell.cellStyle = cellStyle;
        }

        j++;
      });
    }

    // 파일 저장 경로 얻기
    final directory = await getApplicationDocumentsDirectory();
    String filePath = "${directory.path}/stackingCone.xlsx";

    // 파일 저장
    List<int>? fileBytes = excel.save();

    File file = File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);
    print('Excel File Created at $filePath');

    final XFile xfile = XFile(file.path);

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
