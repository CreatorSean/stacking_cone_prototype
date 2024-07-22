import 'package:flutter/material.dart';
import 'package:stacking_cone_prototype/services/database/models/game_record_model.dart';

class ResultDetailScreen extends StatelessWidget {
  final GameRecordModel record;

  const ResultDetailScreen({Key? key, required this.record}) : super(key: key);

  String _formatDate(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${date.year}-${date.month}-${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Result Detail',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${_formatDate(record.date)}'),
            const SizedBox(height: 8.0),
            Text('Mode: ${record.mode == 0 ? '단일 LED' : '다중 LED'}'),
            const SizedBox(height: 8.0),
            Text('Train or Test: ${record.trainOrtest == 0 ? '훈련' : '평가'}'),
            const SizedBox(height: 8.0),
            Text('Total Cone: ${record.totalCone}'),
            const SizedBox(height: 8.0),
            Text('Answer Cone: ${record.answerCone}'),
            const SizedBox(height: 8.0),
            Text('Wrong Cone: ${record.wrongCong}'),
            const SizedBox(height: 8.0),
            Text('Total Time: ${record.totalTime}'),
          ],
        ),
      ),
    );
  }
}
