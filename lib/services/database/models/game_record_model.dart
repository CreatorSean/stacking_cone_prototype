class GameRecordModel {
  final int? id;
  final int patientId;
  final int date;
  final int mode; // 0: 콘 쌓기 | 1: 다중 LED
  final int trainOrtest; // 0: train | 1: test
  final int totalCone;
  final int answerCone;
  final int wrongCong;
  final int totalTime;

  GameRecordModel({
    required this.id,
    required this.patientId,
    required this.date,
    required this.mode,
    required this.totalCone,
    required this.answerCone,
    required this.wrongCong,
    required this.totalTime,
    required this.trainOrtest,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientId': patientId,
      'date': date,
      'mode': mode,
      'totalCone': totalCone,
      'answerCone': answerCone,
      'wrongCone': wrongCong,
      'totalTime': totalTime,
      'trainOrtest': trainOrtest
    };
  }
}
