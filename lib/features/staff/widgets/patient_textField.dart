import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PatientTextfield extends StatefulWidget {
  TextEditingController birthdayController;
  String birthHintText;
  double boxWidth;
  int maxLength;
  bool isAutofocus;
  FocusNode focusNode;
  PatientTextfield({
    super.key,
    required this.birthdayController,
    required this.birthHintText,
    required this.boxWidth,
    required this.maxLength,
    required this.isAutofocus,
    required this.focusNode,
  });

  @override
  State<PatientTextfield> createState() => _PatientTextfieldState();
}

class _PatientTextfieldState extends State<PatientTextfield> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.boxWidth,
      height: 50,
      child: TextFormField(
        textInputAction: TextInputAction.next,
        autofocus: widget.isAutofocus,
        controller: widget.birthdayController,
        decoration: InputDecoration(
          counterText: '',
          hintText: widget.birthHintText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0), // 모서리 둥글게 설정
            borderSide: BorderSide(
              color: Colors.grey.shade400,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 16.0,
          ), // 내부 여백 설정
        ),
        inputFormatters: const [],
        cursorColor: Theme.of(context).primaryColor,
        onFieldSubmitted: (value) {
          FocusScope.of(context).requestFocus();
        },
      ),
    );
  }
}
