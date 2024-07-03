import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/common/constants/sizes.dart';
import 'package:stacking_cone_prototype/features/staff/view/patient_add_screen.dart';

class PatientButton extends ConsumerStatefulWidget {
  final Widget screenName;
  final bool isAddScreen;

  const PatientButton({
    super.key,
    required this.screenName,
    required this.isAddScreen,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PatientButtonState();
}

class _PatientButtonState extends ConsumerState<PatientButton> {
  void _onPatientScreenTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget.screenName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.6,
      child: AnimatedContainer(
        height: 70,
        padding: const EdgeInsets.symmetric(
          vertical: Sizes.size16,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Sizes.size20),
          color: Theme.of(context).primaryColor,
        ),
        duration: const Duration(
          milliseconds: 300,
        ),
        child: AnimatedDefaultTextStyle(
          style: const TextStyle(
            color: Color(0xFFF8F9FA),
            fontWeight: FontWeight.w600,
          ),
          duration: const Duration(
            milliseconds: 300,
          ),
          child: Text(
            "신규환자 등록하기",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
      ),
    );
  }
}
