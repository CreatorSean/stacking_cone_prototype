import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/common/constants/gaps.dart';
import 'package:stacking_cone_prototype/common/constants/sizes.dart';
import 'package:stacking_cone_prototype/features/staff/view_model/selected_patient_view_model.dart';
import 'package:stacking_cone_prototype/services/database/models/patient_model.dart';

class PatientContainer extends ConsumerStatefulWidget {
  final BuildContext context;
  final PatientModel patient;
  final bool selected;
  final int index;
  final Function? selectFunc;

  const PatientContainer({
    super.key,
    required this.context,
    required this.patient,
    this.index = -1,
    this.selected = false,
    this.selectFunc,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PatientContainerState();
}

class _PatientContainerState extends ConsumerState<PatientContainer>
    with SingleTickerProviderStateMixin {
  bool isSelecting = false;
  bool isChecked = false;

  void onSelectTap() {
    isSelecting = !isSelecting;
    if (isSelecting && widget.selectFunc != null) {
      widget.selectFunc!(widget.index, widget.patient, false);
      if (widget.patient.id ==
          ref
              .read(SelectedPatientViewModelProvider.notifier)
              .getSelectedPatient()
              .id) {
        isChecked = true;
      } else {
        isChecked = false;
      }
    }
    setState(() {});
  }

  void onUserCheckTap() {
    if (isSelecting && widget.selectFunc != null) {
      widget.selectFunc!(widget.index, widget.patient, true);
      setState(() {});
    }
  }

  String _gender = "";
  void _maleOrFemale() {
    if (widget.patient.gender == 0) {
      _gender = "남";
    } else {
      _gender = "여";
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    _maleOrFemale();

    if (!widget.selected) {
      isSelecting = false;
      setState(() {});
    }
    if (widget.patient.id ==
        ref
            .read(SelectedPatientViewModelProvider.notifier)
            .getSelectedPatient()
            .id) {
      isChecked = true;
    }

    return GestureDetector(
      onTap: onSelectTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: screenHeight * 0.1,
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 4.0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).primaryColor,
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 12, left: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.patient.userName,
                        style: const TextStyle(
                          color: Color(0xFFF8F9FA),
                          fontSize: Sizes.size16,
                          fontFamily: 'NotosansKR-Medium',
                        ),
                      ),
                      Gaps.h20,
                      Text(
                        widget.patient.birth,
                        style: const TextStyle(
                          color: Color(0xFFF8F9FA),
                          fontSize: Sizes.size16,
                          fontFamily: 'NotosansKR-Medium',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        _gender,
                        style: const TextStyle(
                          color: Color(0xFFF8F9FA),
                          fontSize: Sizes.size16,
                          fontFamily: 'NotosansKR-Medium',
                        ),
                      ),
                      Gaps.h10,
                      Text(
                        "${widget.patient.age}",
                        style: const TextStyle(
                          color: Color(0xFFF8F9FA),
                          fontSize: Sizes.size16,
                          fontFamily: 'NotosansKR-Medium',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // .animate()
          // .then(delay: (widget.idx * 50).ms)
          // .fadeIn(
          //   duration: 300.ms,
          //   curve: Curves.easeInOut,
          // )
          // .flipV(
          //   begin: -0.25,
          //   end: 0,
          //   duration: 300.ms,
          //   curve: Curves.easeInOut,
          // ),
          //==================== 선택 됐을 때 ====================
          Positioned(
            child: Container(
              width: screenWidth * 0.84,
              height: screenHeight * 0.09,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.2),
              ),
            ),
          ).animate(target: isSelecting ? 1.0 : 0.0).fadeIn(
                duration: 500.ms,
              ),
          Positioned(
            child: SizedBox(
              width: screenWidth * 0.84,
              height: screenHeight * 0.09,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Gaps.h10,
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).cardColor),
                      child: Icon(
                        Icons.edit,
                        color: Theme.of(context).primaryColor,
                        size: 35,
                      ),
                    )
                        .animate(target: isSelecting ? 1.0 : 0.0)
                        .then(delay: 100.ms)
                        .fadeIn(duration: 250.ms, curve: Curves.easeInOut)
                        .slide(
                          begin: const Offset(0, 1),
                          end: Offset.zero,
                        )
                        .flipH(begin: 1, end: 0.0),
                  ),
                  Gaps.h10,
                  GestureDetector(
                    onTap: () => onUserCheckTap(),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isChecked
                              ? Colors.green
                              : Theme.of(context).cardColor),
                      child: Icon(
                        Icons.check,
                        color: isChecked
                            ? Theme.of(context).cardColor
                            : Theme.of(context).primaryColor,
                        size: 40,
                      ),
                    ),
                  )
                      .animate(target: isSelecting ? 1.0 : 0.0)
                      .then(delay: 200.ms)
                      .fadeIn(duration: 250.ms, curve: Curves.easeInOut)
                      .slide(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      )
                      .flipH(begin: 1, end: 0.0),
                  Gaps.h20,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
