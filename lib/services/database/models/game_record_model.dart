class GameRecordModel {
  final int? id;
  final int patientId;
  final String userName; //사용자 이름
  int date;
  final int mode; // 0: 콘 쌓기 | 1: 다중 LED
  final int level; // 0: 쉬움 | 1: 보통 | 2: 어려움
  final int trainOrtest; // 0: train | 1: test
  final int totalCone;
  final int answerCone;
  final int wrongCong;
  final int totalTime;

  GameRecordModel({
    required this.id,
    required this.patientId,
    required this.userName,
    required this.date,
    required this.mode,
    required this.level,
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
      'userName': userName,
      'date': date,
      'mode': mode,
      'level': level,
      'totalCone': totalCone,
      'answerCone': answerCone,
      'wrongCone': wrongCong,
      'totalTime': totalTime,
      'trainOrtest': trainOrtest
    };
  }
}
