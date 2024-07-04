import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/common/constants/gaps.dart';
import 'package:stacking_cone_prototype/features/staff/view/patient_add_screen.dart';
import 'package:stacking_cone_prototype/features/staff/view_model/selected_patient_view_model.dart';
import 'package:stacking_cone_prototype/services/database/models/patient_model.dart';

class UserCard extends ConsumerStatefulWidget {
  final PatientModel userModel;
  final bool isHome;
  final bool selected;
  final int index;
  final Function? selectFunc;

  const UserCard({
    super.key,
    required this.userModel,
    required this.isHome,
    this.index = -1,
    this.selected = false,
    this.selectFunc,
  });

  @override
  ConsumerState<UserCard> createState() => _UserCardState();
}

class _UserCardState extends ConsumerState<UserCard>
    with SingleTickerProviderStateMixin {
  int userAge = 0;

  bool isSelecting = false;
  bool isChecked = false;

  void onSelectTap() {
    isSelecting = !isSelecting;
    if (isSelecting && widget.selectFunc != null) {
      widget.selectFunc!(widget.index, widget.userModel, false);
      if (widget.userModel.id ==
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
      widget.selectFunc!(widget.index, widget.userModel, true);
      setState(() {});
    }
  }

  // void onModifyTap(PatientModel user) async {
  //   await Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => PatientAddScreen(isAdd: false, user: user),
  //     ),
  //   );

  // await Future.delayed(1000.ms);
  // if (mounted) {
  //   if (widget.userModel.id ==
  //       ref.read(selectedUserViewModelProvider.notifier).selectedUser.id) {
  //     onUserCheckTap();
  //   } else {
  //     onSelectTap();
  //   }
  // }
  //}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    const cardSizeRatio = 0.08;

    if (!widget.selected) {
      isSelecting = false;
      setState(() {});
    }
    if (widget.userModel.id ==
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
            height: screenHeight * cardSizeRatio,
            // padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border.symmetric(
                horizontal: BorderSide(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  width: 0.3,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gaps.h10,
                widget.userModel.img.contains("asset")
                    ? CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage(widget.userModel.img))
                    : CircleAvatar(
                        radius: 25,
                        backgroundImage: FileImage(File(widget.userModel.img))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.userModel.userName,
                        style: const TextStyle(
                          fontFamily: 'NotosansKR-Medium',
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        "${widget.userModel.gender == 0 ? "man" : "woman"} ${widget.userModel.age} years old",
                        style: TextStyle(
                          fontFamily: 'NotosansKR-Regular',
                          fontSize: 13,
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          //==================== 선택 됐을 때 ====================
          Positioned(
            child: Container(
              height: screenHeight * cardSizeRatio,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.2),
              ),
            ),
          ).animate(target: isSelecting ? 1.0 : 0.0).fadeIn(
                duration: 500.ms,
              ),
          Positioned(
            child: SizedBox(
              height: screenHeight * cardSizeRatio,
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
