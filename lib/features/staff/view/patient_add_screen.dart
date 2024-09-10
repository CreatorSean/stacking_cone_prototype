import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:stacking_cone_prototype/common/constants/gaps.dart';
import 'package:stacking_cone_prototype/common/constants/sizes.dart';
import 'package:stacking_cone_prototype/features/staff/view/staff_screen.dart';
import 'package:stacking_cone_prototype/features/staff/view_model/staff_screen_view_model.dart';
import 'package:stacking_cone_prototype/features/staff/widgets/date_textField.dart';
import 'package:stacking_cone_prototype/features/staff/widgets/patient_button.dart';
import 'package:stacking_cone_prototype/features/staff/widgets/patient_textField.dart';

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
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _diagnosisDateController =
      TextEditingController();
  final TextEditingController _surgeryDateController = TextEditingController();

  FocusNode fieldOne = FocusNode();
  FocusNode fieldTwo = FocusNode();
  FocusNode fieldThree = FocusNode();

  String _userName = "";
  int _gender = 0;
  String _birth = "";
  String _diagnosis = "";
  String _diagnosisDate = "";
  String _surgeryDate = "";
  String _medication = "";

  void _addPatient() {
    _birth = _birthDateController.text;
    _diagnosisDate = _diagnosisDateController.text;
    _surgeryDate = _surgeryDateController.text;

    if (_userNameController.text.isEmpty || _birth.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              "Please write your user information!",
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ),
          duration: 1.seconds,
        ),
      );
      return;
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

    Logger().i({
      'userName': _userName,
      'gender': _gender,
      'birth': _birth,
      'diagnosis': _diagnosis,
      'diagnosisDate': _diagnosisDate,
      'surgeryDate': _surgeryDate,
      'medication': _medication,
    });

    ref.read(staffScreenViewModelProvider.notifier).insertPatient(context);

    // 환자 정보 추가 후 staff_screen.dart 이동
    Navigator.pop(context, true); // true 값을 반환 -> 데이터 추가 알림
  }

  @override
  void initState() {
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
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return SizedBox(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    'Select Date',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const Divider(
                height: 1,
                thickness: 1,
              ),
              Expanded(
                child: CupertinoDatePicker(
                  minimumDate: DateTime(1950),
                  maximumDate: DateTime(2030),
                  initialDateTime: DateTime.now(),
                  onDateTimeChanged: (DateTime newDate) {
                    setState(() {
                      controller.text =
                          "${newDate.year.toString()}.${newDate.month.toString().padLeft(2, '0')}.${newDate.day.toString().padLeft(2, '0')}";
                    });
                  },
                  mode: CupertinoDatePickerMode.date,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Done'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
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
                const Row(
                  children: [
                    Text(
                      "개인 정보",
                      style: TextStyle(
                        color: Color.fromARGB(255, 34, 35, 36),
                        fontSize: Sizes.size32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "(필수 사항)",
                          style: TextStyle(
                            color: Color(0xFF223A5E),
                            fontSize: Sizes.size16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
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
                  maxLength: 20,
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
                GestureDetector(
                  onTap: () => _selectDate(context, _birthDateController),
                  child: AbsorbPointer(
                    child: DateTextField(
                      focusNode: fieldOne,
                      isAutofocus: false,
                      birthdayController: _birthDateController,
                      birthHintText: "YYYY.MM.DD",
                      boxWidth: displayWidth * 0.84,
                      maxLength: 10,
                    ),
                  ),
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
                Gaps.v24,
                Divider(
                  thickness: 0.3,
                  color: Theme.of(context).primaryColor,
                ),
                Gaps.v24,
                const Row(
                  children: [
                    Text(
                      "진단 정보",
                      style: TextStyle(
                        color: Color.fromARGB(255, 34, 35, 36),
                        fontSize: Sizes.size32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "(선택 사항)",
                          style: TextStyle(
                            color: Color(0xFF223A5E),
                            fontSize: Sizes.size16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
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
                  maxLength: 20,
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
                GestureDetector(
                  onTap: () => _selectDate(context, _diagnosisDateController),
                  child: AbsorbPointer(
                    child: DateTextField(
                      focusNode: fieldOne,
                      isAutofocus: false,
                      birthdayController: _diagnosisDateController,
                      birthHintText: "YYYY.MM.DD",
                      boxWidth: displayWidth * 0.84,
                      maxLength: 10,
                    ),
                  ),
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
                GestureDetector(
                  onTap: () => _selectDate(context, _surgeryDateController),
                  child: AbsorbPointer(
                    child: DateTextField(
                      focusNode: fieldOne,
                      isAutofocus: false,
                      birthdayController: _surgeryDateController,
                      birthHintText: "YYYY.MM.DD",
                      boxWidth: displayWidth * 0.84,
                      maxLength: 10,
                    ),
                  ),
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
                  maxLength: 20,
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
