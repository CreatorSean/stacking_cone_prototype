import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/common/constants/gaps.dart';
import 'package:stacking_cone_prototype/common/constants/sizes.dart';
import 'package:stacking_cone_prototype/features/staff/view/staff_screen.dart';
import 'package:stacking_cone_prototype/features/staff/view_model/staff_screen_view_model.dart';
import 'package:stacking_cone_prototype/features/staff/widgets/date_textField.dart';
import 'package:stacking_cone_prototype/features/staff/widgets/patient_button.dart';
import 'package:stacking_cone_prototype/features/staff/widgets/patient_textField.dart';
import 'package:stacking_cone_prototype/features/staff/widgets/showErrorSnack.dart';

class PatientAddScreen extends ConsumerStatefulWidget {
  static String routeURL = '/add';
  static String routeName = 'add';
  const PatientAddScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PatientAddScreenState();
}

class _PatientAddScreenState extends ConsumerState<PatientAddScreen> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _diagnosisController = TextEditingController();
  final TextEditingController _medicationController = TextEditingController();
  final TextEditingController _birthYearController = TextEditingController();
  final TextEditingController _birthMonthController = TextEditingController();
  final TextEditingController _birthDayController = TextEditingController();
  final TextEditingController _diagnosisYearController =
      TextEditingController();
  final TextEditingController _diagnosisMonthController =
      TextEditingController();
  final TextEditingController _diagnosisDayController = TextEditingController();
  final TextEditingController _surgeryYearController = TextEditingController();
  final TextEditingController _surgeryMonthController = TextEditingController();
  final TextEditingController _surgeryDayController = TextEditingController();

  FocusNode fieldOne = FocusNode();
  FocusNode fieldTwo = FocusNode();
  FocusNode fieldThree = FocusNode();

  String _userName = "";
  int _gender = 0;
  String _birthYear = "";
  String _birthMonth = "";
  String _birthDay = "";
  String _birth = "";
  String _diagnosis = "";
  String _diagnosisYear = "";
  String _diagnosisMonth = "";
  String _diagnosisDay = "";
  String _diagnosisDate = "";
  String _surgeryYear = "";
  String _surgeryMonth = "";
  String _surgeryDay = "";
  String _surgeryDate = "";
  String _medication = "";

  void _addPatient() {
    _birth = "$_birthYear.$_birthMonth.$_birthDay";
    _diagnosisDate = "$_diagnosisYear.$_diagnosisMonth.$_diagnosisDay";
    _surgeryDate = "$_surgeryYear.$_surgeryMonth.$_surgeryDay";
    if (_birthYear.isEmpty && _birthMonth.isEmpty && _birthDay.isEmpty ||
        _isValidBirth(_birth) == false) return;
    if (_userNameController.text == "" || _birth == "") {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              "Please write your user information.",
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ),
          duration: 1.seconds,
        ),
      );
    }
    ref.read(registrationForm.notifier).state = {
      "userName": _userName,
      "gender": _gender,
      "birth": _birth,
      "diagnosis": _diagnosis,
      "diagnosisDate": _diagnosisDate,
      "surgeryDate": _surgeryDate,
      "medication": _medication,
    };
    ref.read(staffScreenViewModelProvider.notifier).insertPatient(context);
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userNameController.addListener(
      () {
        setState(() {
          _userName = _userNameController.text;
        });
      },
    );
    _diagnosisController.addListener(
      () {
        setState(() {
          _diagnosis = _diagnosisController.text;
        });
      },
    );
    _medicationController.addListener(
      () {
        setState(() {
          _medication = _medicationController.text;
        });
      },
    );
    _birthYearController.addListener(
      () {
        setState(() {
          _birthYear = _birthYearController.text;
        });
      },
    );
    _birthMonthController.addListener(
      () {
        setState(() {
          _birthMonth = _birthMonthController.text;
        });
      },
    );
    _birthDayController.addListener(
      () {
        setState(() {
          _birthDay = _birthDayController.text;
        });
      },
    );
    _diagnosisYearController.addListener(
      () {
        setState(() {
          _diagnosisYear = _diagnosisYearController.text;
        });
      },
    );
    _diagnosisMonthController.addListener(
      () {
        setState(() {
          _diagnosisMonth = _diagnosisMonthController.text;
        });
      },
    );
    _diagnosisDayController.addListener(
      () {
        setState(() {
          _diagnosisDay = _diagnosisDayController.text;
        });
      },
    );
    _surgeryYearController.addListener(
      () {
        setState(() {
          _surgeryYear = _surgeryYearController.text;
        });
      },
    );
    _surgeryMonthController.addListener(
      () {
        setState(() {
          _surgeryMonth = _surgeryMonthController.text;
        });
      },
    );
    _surgeryDayController.addListener(
      () {
        setState(() {
          _surgeryDay = _surgeryDayController.text;
        });
      },
    );
  }

  bool _isValidBirth(String input) {
    // "YYYYMMDD" 형식의 8자리 숫자에 대한 정규식
    RegExp regex = RegExp(r'^\d{4}\.\d{2}\.\d{2}$');

    // 정규식과 매치되는지 확인
    if (!regex.hasMatch(input)) {
      showErrorSnack(context);
      return false;
    }

    // 년, 월, 일을 추출하여 각각 검증
    int year = int.parse(input.split(".")[0]);
    int month = int.parse(input.split(".")[1]);
    int day = int.parse(input.split(".")[2]);

    // 생년월일 유효성 검증
    if (year < 1900 || month < 1 || month > 12 || day < 1 || day > 31) {
      showErrorSnack(context);
      return false;
    }

    // 월에 따른 일자 유효성 검증 (간단한 예시)
    if ((month == 4 || month == 6 || month == 9 || month == 11) && day > 30) {
      showErrorSnack(context);
      return false; // 4, 6, 9, 11월은 30일까지만 존재
    } else if (month == 2) {
      // 2월은 윤년을 고려하여 28일 또는 29일까지 존재
      if ((year % 4 == 0 && year % 100 != 0) ||
          (year % 400 == 0 && year % 100 == 0)) {
        if (day > 29) {
          showErrorSnack(context);
          return false; // 윤년인 경우 29일까지
        }
      } else {
        if (day > 28) {
          showErrorSnack(context);
          return false; // 윤년이 아닌 경우 28일까지
        }
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final displayWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        //FocusManager.instance.primaryFocus?.unfocus();
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "개인 정보",
                  style: TextStyle(
                    color: Color(0xFF223A5E),
                    fontSize: Sizes.size32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gaps.v36,
                const Text(
                  "이름",
                  style: TextStyle(
                    color: Color(0xFF223A5E),
                    fontSize: Sizes.size20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gaps.v16,
                PatientTextfield(
                  focusNode: fieldOne,
                  isAutofocus: true,
                  birthdayController: _userNameController,
                  birthHintText: "",
                  boxWidth: displayWidth * 0.84,
                  maxLength: 4,
                ),
                Gaps.v24,
                const Text(
                  "생일",
                  style: TextStyle(
                    color: Color(0xFF223A5E),
                    fontSize: Sizes.size20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gaps.v16,
                Row(
                  children: [
                    DateTextField(
                      focusNode: fieldOne,
                      isAutofocus: false,
                      birthdayController: _birthYearController,
                      birthHintText: "YYYY",
                      boxWidth: displayWidth * 0.4,
                      maxLength: 4,
                    ),
                    Gaps.h6,
                    DateTextField(
                      focusNode: fieldTwo,
                      isAutofocus: false,
                      birthdayController: _birthMonthController,
                      birthHintText: "MM",
                      boxWidth: displayWidth * 0.2,
                      maxLength: 2,
                    ),
                    Gaps.h6,
                    DateTextField(
                      focusNode: fieldThree,
                      isAutofocus: false,
                      birthdayController: _birthDayController,
                      birthHintText: "DD",
                      boxWidth: displayWidth * 0.2,
                      maxLength: 2,
                    ),
                  ],
                ),
                Gaps.v24,
                const Text(
                  "성별",
                  style: TextStyle(
                    color: Color(0xFF223A5E),
                    fontSize: Sizes.size20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gaps.v16,
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Radio(
                            value: 0,
                            groupValue: _gender,
                            onChanged: (value) {
                              setState(() {
                                _gender = value!;
                              });
                            },
                          ),
                          const Text(
                            '남자',
                            style: TextStyle(
                              color: Color(0xFF223A5E),
                              fontSize: Sizes.size20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Radio(
                            value: 1,
                            groupValue: _gender,
                            onChanged: (value) {
                              setState(() {
                                _gender = value!;
                              });
                            },
                          ),
                          const Text(
                            '여자',
                            style: TextStyle(
                              color: Color(0xFF223A5E),
                              fontSize: Sizes.size20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Gaps.v52,
                const Text(
                  "진단 정보",
                  style: TextStyle(
                    color: Color(0xFF223A5E),
                    fontSize: Sizes.size32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gaps.v36,
                const Text(
                  "진단명",
                  style: TextStyle(
                    color: Color(0xFF223A5E),
                    fontSize: Sizes.size20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gaps.v16,
                PatientTextfield(
                  focusNode: fieldOne,
                  isAutofocus: true,
                  birthdayController: _diagnosisController,
                  birthHintText: "",
                  boxWidth: displayWidth * 0.84,
                  maxLength: 4,
                ),
                Gaps.v24,
                const Text(
                  "진단 일자",
                  style: TextStyle(
                    color: Color(0xFF223A5E),
                    fontSize: Sizes.size20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gaps.v16,
                Row(
                  children: [
                    DateTextField(
                      focusNode: fieldOne,
                      isAutofocus: false,
                      birthdayController: _diagnosisYearController,
                      birthHintText: "YYYY",
                      boxWidth: displayWidth * 0.4,
                      maxLength: 4,
                    ),
                    Gaps.h6,
                    DateTextField(
                      focusNode: fieldTwo,
                      isAutofocus: false,
                      birthdayController: _diagnosisMonthController,
                      birthHintText: "MM",
                      boxWidth: displayWidth * 0.2,
                      maxLength: 2,
                    ),
                    Gaps.h6,
                    DateTextField(
                      focusNode: fieldThree,
                      isAutofocus: false,
                      birthdayController: _diagnosisDayController,
                      birthHintText: "DD",
                      boxWidth: displayWidth * 0.2,
                      maxLength: 2,
                    ),
                  ],
                ),
                Gaps.v24,
                const Text(
                  "수술 일자",
                  style: TextStyle(
                    color: Color(0xFF223A5E),
                    fontSize: Sizes.size20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gaps.v16,
                Row(
                  children: [
                    DateTextField(
                      focusNode: fieldOne,
                      isAutofocus: false,
                      birthdayController: _surgeryYearController,
                      birthHintText: "YYYY",
                      boxWidth: displayWidth * 0.4,
                      maxLength: 4,
                    ),
                    Gaps.h6,
                    DateTextField(
                      focusNode: fieldTwo,
                      isAutofocus: false,
                      birthdayController: _surgeryMonthController,
                      birthHintText: "MM",
                      boxWidth: displayWidth * 0.2,
                      maxLength: 2,
                    ),
                    Gaps.h6,
                    DateTextField(
                      focusNode: fieldThree,
                      isAutofocus: false,
                      birthdayController: _surgeryDayController,
                      birthHintText: "DD",
                      boxWidth: displayWidth * 0.2,
                      maxLength: 2,
                    ),
                  ],
                ),
                Gaps.v24,
                const Text(
                  "복용 약물",
                  style: TextStyle(
                    color: Color(0xFF223A5E),
                    fontSize: Sizes.size20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gaps.v16,
                PatientTextfield(
                  focusNode: fieldOne,
                  isAutofocus: true,
                  birthdayController: _medicationController,
                  birthHintText: "",
                  boxWidth: displayWidth * 0.84,
                  maxLength: 4,
                ),
                Gaps.v52,
                Center(
                  child: GestureDetector(
                    onTap: () {
                      _addPatient();
                    },
                    child: const PatientButton(
                      screenName: StaffScreen(),
                      isAddScreen: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
