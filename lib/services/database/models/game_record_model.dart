class GameRecordModel {
  final int? id;
  final int totalCone;
  final int answerCone;
  final int wrongCong;
  final int totalTime;

  GameRecordModel({
    required this.id,
    required this.totalCone,
    required this.answerCone,
    required this.wrongCong,
    required this.totalTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'totalCone': totalCone,
      'answerCone': answerCone,
      'wrongCone': wrongCong,
      'totalTime': totalTime,
    };
  }
}
