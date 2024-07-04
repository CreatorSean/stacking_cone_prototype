//사용자가 편집하길 원하는 모든 데이터를 가지고 있어야 함.
// 뷰가 필요한 데이터를 모델에 담아야 함.

class PatientModel {
  final int? id; //사용자 id
  final String userName; //사용자 이름
  final int gender; //성별  0: 남자 | 1: 여자
  final String birth; //생일
  final String diagnosis;
  final String diagnosisDate;
  final String surgeryDate;
  final String medication;
  final String img;
  final String memo;
  final int age;

  PatientModel({
    required this.id,
    required this.userName,
    required this.gender,
    required this.birth,
    required this.age,
    required this.diagnosis,
    required this.diagnosisDate,
    required this.surgeryDate,
    required this.medication,
    this.img = "assets/images/man.png",
    this.memo = "",
  });

  //toMap()은 Spec을 map 타입으로 변환주는 함수
  // DB에 실제로 insert할 땐 map 타입이어야 함.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userName': userName,
      'gender': gender,
      'birth': birth,
      'age': age,
      'diagnosis': diagnosis,
      'diagnosisDate': diagnosisDate,
      'surgeryDate': surgeryDate,
      'medication': medication,
      'img': img,
      'memo': memo,
    };
  }

  @override
  String toString() {
    return 'Memo{id: $id, userName: $userName, gender: $gender, birth: $birth, diagnosis: $diagnosis, diagnosisDate : $diagnosisDate, surgeryDate: $surgeryDate, medication: $medication, img: $img, age: $age, memo: $memo,}';
  }
}
