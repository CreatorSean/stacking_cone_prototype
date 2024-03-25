import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacking_cone_prototype/common/constants/gaps.dart';
import 'package:stacking_cone_prototype/common/constants/sizes.dart';

class ToggleButton extends StatefulWidget {
  const ToggleButton({super.key});

  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          _isChecked ? "평가형" : "훈련형",
          style: const TextStyle(
            fontSize: Sizes.size20,
            fontWeight: FontWeight.w600,
            fontFamily: 'NotosansKR-Medium',
            color: Colors.black,
          ),
        ),
        Gaps.h4,
        CupertinoSwitch(
          trackColor: const Color(0xff4079E8),
          activeColor: const Color(0xff7DDD5C),
          value: _isChecked,
          onChanged: (bool? value) {
            setState(() {
              _isChecked = value ?? false;
            });
          },
        ),
        Gaps.h20,
      ],
    );
  }
}
