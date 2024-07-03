import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/common/constants/gaps.dart';
import 'package:stacking_cone_prototype/common/constants/sizes.dart';
import 'package:stacking_cone_prototype/services/database/models/patient_model.dart';

class PatientContainer extends ConsumerStatefulWidget {
  final int idx;
  final BuildContext context;
  final PatientModel patient;
  const PatientContainer({
    super.key,
    required this.idx,
    required this.context,
    required this.patient,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PatientContainerState();
}

class _PatientContainerState extends ConsumerState<PatientContainer> {
  String _gender = "";
  void _maleOrFemale() {
    if (widget.patient.gender == 0) {
      _gender = "남";
    } else {
      _gender = "여";
    }
  }

  @override
  Widget build(BuildContext context) {
    _maleOrFemale();
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: MediaQuery.of(context).size.width * 0.84,
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 12.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).primaryColor,
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 12, left: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.patient.userName,
                    style: const TextStyle(
                      color: Color(0xFFF8F9FA),
                      fontSize: Sizes.size24,
                    ),
                  ),
                  Gaps.h20,
                  Text(
                    widget.patient.birth,
                    style: const TextStyle(
                      color: Color(0xFFF8F9FA),
                      fontSize: Sizes.size24,
                    ),
                  ),
                ],
              ),
              Gaps.v16,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    _gender,
                    style: const TextStyle(
                      color: Color(0xFFF8F9FA),
                      fontSize: Sizes.size24,
                    ),
                  ),
                  Gaps.h20,
                  Text(
                    "${widget.patient.age}",
                    style: const TextStyle(
                      color: Color(0xFFF8F9FA),
                      fontSize: Sizes.size24,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )
          .animate()
          .then(delay: (widget.idx * 50).ms)
          .fadeIn(
            duration: 300.ms,
            curve: Curves.easeInOut,
          )
          .flipV(
            begin: -0.25,
            end: 0,
            duration: 300.ms,
            curve: Curves.easeInOut,
          ),
    );
  }
}
