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
import 'package:stacking_cone_prototype/features/db_save/widgets/showDbErrorSnack.dart';

class DbButton extends ConsumerStatefulWidget {
  final String buttonName;
  final String? patientName;

  const DbButton({
    super.key,
    required this.buttonName,
    required this.patientName,
  });

  @override
  ConsumerState<DbButton> createState() => _DbButtonState();
}

class _DbButtonState extends ConsumerState<DbButton> {
  String value = '';

  Future<String> getDatabasePath() async {
    final databasePath = await getDatabasesPath();
    return join(databasePath, 'StackingCone.db'); // 여기에 실제 데이터베이스 파일 이름을 넣으세요
  }

  Future<void> shareDatabase(String? patientName, BuildContext context) async {
    final databasePath = await getDatabasePath();
    late List<Map> results;
    String date = '';

    // 데이터베이스 열기
    Database database = await openDatabase(databasePath);

    // SQL 쿼리 결정
    String query;
    List<dynamic> arguments = [];

    if (patientName != null && patientName.isNotEmpty) {
      query = 'SELECT * FROM GameRecords WHERE userName = ?';
      arguments = [patientName];
      // 특정 환자의 데이터 또는 전체 데이터를 가져오는 SQL 쿼리 실행
      results = await database.rawQuery(query, arguments);
    } else {
      // patientName이 null이거나 비어있을 경우 모든 데이터를 가져옴
      ShowDbErrorSnack(context);
      return;
    }

    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    Map<String, String> columnMapping = {
      'id': 'ID',
      'patientId': '환자 ID',
      'userName': '환자 이름',
      'date': '날짜',
      'mode': '모드',
      'level': '난이도',
      'trainOrtest': '훈련/평가',
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
        CellStyle? cellStyle;

        if (dbColumn == 'date') {
          // 날짜를 원하는 형식으로 변환
          int? rawDate = results[i][dbColumn] as int?;

          // rawDate가 null이 아닌 경우에만 DateTime 객체 생성
          if (rawDate != null) {
            DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(rawDate);

            // dateTime을 사용하여 날짜 포맷 변환
            value = DateFormat('yyyy-MM-dd').format(dateTime);
          } else {
            // rawDate가 null일 경우 빈 문자열 또는 적절한 기본값 사용
            value = '';
          }

          date = value;
        } else if (dbColumn == 'level') {
          // 난이도를 문자열로 변환
          int? levelValue = results[i][dbColumn] as int?;
          switch (levelValue) {
            case 0:
              value = '쉬움';
              break;
            case 1:
              value = '보통';
              break;
            case 2:
              value = '어려움';
              break;
            default:
              value = '알 수 없음'; // 예상치 못한 값이 있을 경우
          }
        } else if (dbColumn == 'totalCone' ||
            dbColumn == 'answerCone' ||
            dbColumn == 'wrongCone' ||
            dbColumn == 'totalTime') {
          // 수치를 문자열로 변환하고 우측 정렬 스타일 지정
          value = results[i][dbColumn]?.toString() ?? '';
          cellStyle = rightAlignStyle;
        } else if (dbColumn == 'mode') {
          int? modeValue = results[i][dbColumn] as int?;
          switch (modeValue) {
            case 0:
              value = '운동 재활';
              break;
            case 1:
              value = '인지 재활';
              break;
            default:
              value = '알 수 없음';
          }
        } else if (dbColumn == 'trainOrtest') {
          int? gameValue = results[i][dbColumn] as int?;
          switch (gameValue) {
            case 0:
              value = '훈련 모드';
              break;
            case 1:
              value = '평가 모드';
              break;
            default:
              value = '알 수 없음';
          }
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
    String filePath =
        "${directory.path}/${date}_${widget.patientName}_StackingConeDB.xlsx";

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
        shareDatabase(widget.patientName, context);
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
