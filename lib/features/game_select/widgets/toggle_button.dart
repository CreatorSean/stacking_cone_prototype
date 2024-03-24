import 'package:flutter/cupertino.dart';

class ToggleButton extends StatefulWidget {
  const ToggleButton({super.key});

  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
      value: _isChecked,
      onChanged: (bool? value) {
        setState(() {
          _isChecked = value ?? false;
        });
      },
    );
  }
}
