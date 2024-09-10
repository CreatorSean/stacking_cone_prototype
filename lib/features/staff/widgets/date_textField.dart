import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class DateTextField extends StatefulWidget {
  TextEditingController birthdayController;
  String birthHintText;
  double boxWidth;
  int maxLength;
  bool isAutofocus;
  FocusNode focusNode;
  DateTextField({
    super.key,
    required this.birthdayController,
    required this.birthHintText,
    required this.boxWidth,
    required this.maxLength,
    required this.isAutofocus,
    required this.focusNode,
  });

  @override
  State<DateTextField> createState() => _DateTextFieldState();
}

class _DateTextFieldState extends State<DateTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.boxWidth,
      height: 50,
      child: TextFormField(
        textInputAction: TextInputAction.next,
        autofocus: widget.isAutofocus,
        maxLength: widget.maxLength,
        keyboardType: TextInputType.number,
        controller: widget.birthdayController,
        decoration: InputDecoration(
          counterText: '',
          hintText: widget.birthHintText,
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
          ),
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
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
        cursorColor: Theme.of(context).primaryColor,
        onFieldSubmitted: (value) {
          FocusScope.of(context).requestFocus();
        },
      ),
    );
  }
}
