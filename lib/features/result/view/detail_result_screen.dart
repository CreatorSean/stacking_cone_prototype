import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacking_cone_prototype/common/constants/sizes.dart';
import 'package:stacking_cone_prototype/features/staff/widgets/info_container.dart';
import 'package:stacking_cone_prototype/services/database/database_service.dart';
import 'package:stacking_cone_prototype/services/database/models/game_record_model.dart';
import 'package:stacking_cone_prototype/services/database/models/patient_model.dart';

class DetailResultScreen extends StatefulWidget {
  final GameRecordModel record;
  final int index;

  const DetailResultScreen(
      {Key? key, required this.record, required this.index})
      : super(key: key);

  @override
  State<DetailResultScreen> createState() => _DetailResultScreenState();
}

class _DetailResultScreenState extends State<DetailResultScreen> {
  PatientModel? _selectedPatient;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSelectedPatient();
    _loadGameRecords();
  }

  String _formatDate(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('yy.MM.dd').format(date);
  }

  Future<void> _loadSelectedPatient() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedPatientId = prefs.getInt('selectedPatientId');
    if (selectedPatientId != null) {
      final patientList =
          await DatabaseService.getSelectedPatientDB(selectedPatientId);
      if (patientList.isNotEmpty) {
        setState(() {
          _selectedPatient = patientList.first;
        });
      }
    }
  }

  Future<void> _loadGameRecords() async {
    try {
      final gameRecords = await DatabaseService.getGameRecordsByPatientId(
          widget.record.patientId);
      final filteredRecords = gameRecords.where((record) {
        return record.date == widget.record.date;
      }).toList();
      for (var record in filteredRecords) {
        Logger().i(
            'ID: ${record.id}, Patient ID: ${record.patientId}, Date: ${record.date}, Mode: ${record.mode}, Train/Test: ${record.trainOrtest}, Total Cone: ${record.totalCone}, Answer Cone: ${record.answerCone}, Wrong Cone: ${record.wrongCong}, Total Time: ${record.totalTime}');
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      Logger().e("Error loading game records: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double percentage = widget.record.totalCone > 0
        ? widget.record.answerCone / widget.record.totalCone
        : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Result Detail',
          style: TextStyle(
            color: Color(0xFFF8F9FA),
            fontSize: Sizes.size24,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_selectedPatient != null)
                    InfoContainer(
                      selectedPatient: _selectedPatient!,
                      isSetting: false,
                    ),
                  Divider(
                    height: 2,
                    thickness: 0.5,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10.0),
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDate(widget.record.date),
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                          ),
                        ),
                        Text(
                          '${widget.index}회차', // index를 사용하여 회차 표시
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(7.0),
                          decoration: BoxDecoration(
                            color: widget.record.mode == 0
                                ? Colors.green
                                : Colors.blue,
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          child: Text(
                            '${widget.record.mode == 0 ? '운동 재활' : '인지 재활'} (${widget.record.trainOrtest == 0 ? '훈련' : '평가'})',
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10.0),
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CircularPercentIndicator(
                            radius: 60.0,
                            lineWidth: 13.0,
                            animation: true,
                            percent: percentage,
                            center: Text(
                              '${(percentage * 100).toStringAsFixed(1)}%',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.0),
                            ),
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('총 쌓은 콘: ${widget.record.totalCone} 개',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04,
                                    )),
                                Text('맞게 쌓은 콘: ${widget.record.answerCone} 개',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04,
                                    )),
                                Text('틀린 콘: ${widget.record.wrongCong} 개',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04,
                                    )),
                                Text('소요시간: ${widget.record.totalTime} s',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
