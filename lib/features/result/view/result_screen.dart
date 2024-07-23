import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:stacking_cone_prototype/common/constants/sizes.dart';
import 'package:stacking_cone_prototype/services/database/database_service.dart';
import 'package:stacking_cone_prototype/services/database/models/game_record_model.dart';
import 'package:stacking_cone_prototype/services/database/models/patient_model.dart';
import 'package:stacking_cone_prototype/features/staff/view_model/selected_patient_view_model.dart';
import 'package:stacking_cone_prototype/features/staff/widgets/info_container.dart';
import 'detail_result_screen.dart';

class ResultScreen extends ConsumerStatefulWidget {
  static String routeURL = '/result';
  static String routeName = 'result';
  const ResultScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  late Future<List<GameRecordModel>> _gameRecordsFuture;

  @override
  void initState() {
    super.initState();
    _loadGameRecords();
  }

  void _loadGameRecords() {
    PatientModel selectedPatient = ref
        .read(SelectedPatientViewModelProvider.notifier)
        .getSelectedPatient();

    _gameRecordsFuture =
        DatabaseService.getGameRecordsByPatientId(selectedPatient.id!);
  }

  void _logGameRecords() async {
    List<GameRecordModel> gameRecords = await _gameRecordsFuture;
    List<String> logRecords = [];
    for (var record in gameRecords) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(record.date);
      String formattedDate = DateFormat('yy.MM.dd').format(date);
      logRecords.add(
          'ID: ${record.id}, Patient ID: ${record.patientId}, Date: $formattedDate, Mode: ${record.mode}, TrainOrTest: ${record.trainOrtest}');
    }
    Logger().i(logRecords.join('\n'));
  }

  String _formatDate(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('yy.MM.dd').format(date);
  }

  Future<void> _deleteGameRecords() async {
    PatientModel selectedPatient = ref
        .read(SelectedPatientViewModelProvider.notifier)
        .getSelectedPatient();
    await DatabaseService.deleteGameRecordsByPatientId(selectedPatient.id!);
    Logger().i(
        'All game records for patient ID: ${selectedPatient.id} have been deleted.');
    setState(() {
      _loadGameRecords();
    });
  }

  @override
  Widget build(BuildContext context) {
    PatientModel selectedPatient = ref
        .read(SelectedPatientViewModelProvider.notifier)
        .getSelectedPatient();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Result Screen',
          style: TextStyle(
            color: Color(0xFFF8F9FA),
            fontSize: Sizes.size24,
          ),
        ),
      ),
      body: Column(
        children: [
          InfoContainer(
            selectedPatient: selectedPatient,
            isSetting: false,
          ),
          Divider(
            height: 2,
            thickness: 0.5,
            color: Theme.of(context).secondaryHeaderColor,
          ),
          Expanded(
            child: FutureBuilder<List<GameRecordModel>>(
              future: _gameRecordsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No records found'),
                  );
                } else {
                  List<GameRecordModel> records = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      GameRecordModel record = records[index];
                      String formattedDate = _formatDate(record.date);
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailResultScreen(
                                    record: record, index: index + 1),
                              ),
                            );
                          },
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formattedDate,
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                  ),
                                ),
                                Text(
                                  '${index + 1}회차',
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(7.0),
                                  decoration: BoxDecoration(
                                    color: record.mode == 0
                                        ? Colors.green
                                        : Colors.blue,
                                    borderRadius: BorderRadius.circular(7.0),
                                  ),
                                  child: Text(
                                    '${record.mode == 0 ? '단일 LED' : '다중 LED'} (${record.trainOrtest == 0 ? '훈련' : '평가'})',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),

          //테스트시 데이터 확인 버튼
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _logGameRecords,
                    child: const Text('Log Records'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _deleteGameRecords,
                    child: const Text('Delete Records'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
