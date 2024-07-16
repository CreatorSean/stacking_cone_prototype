import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/features/staff/view_model/selected_patient_view_model.dart';
import 'package:stacking_cone_prototype/features/staff/view_model/staff_screen_view_model.dart';
import 'package:stacking_cone_prototype/services/database/models/patient_model.dart';

import '../../../common/constants/sizes.dart';

class InfoContainer extends ConsumerStatefulWidget {
  final PatientModel selectedPatient;
  final bool isSetting;

  const InfoContainer({
    super.key,
    required this.selectedPatient,
    required this.isSetting,
  });

  @override
  ConsumerState<InfoContainer> createState() => _InfoContainerState();
}

class _InfoContainerState extends ConsumerState<InfoContainer> {
  @override
  Widget build(BuildContext context) {
    void onClosedTap() {
      Navigator.pop(context);
    }

    Future<void> onSavedTap(String updateMemo) async {
      String imgPath = widget.selectedPatient.img;
      if (imgPath.contains("assets")) {
        if (widget.selectedPatient.gender == 0) {
          imgPath = "assets/images/man.png";
        } else {
          imgPath = "assets/images/woman.png";
        }
      }
      PatientModel updateUser = PatientModel(
        id: widget.selectedPatient.id,
        userName: widget.selectedPatient.userName,
        gender: widget.selectedPatient.gender,
        birth: widget.selectedPatient.birth,
        age: widget.selectedPatient.age,
        img: imgPath,
        memo: updateMemo,
        diagnosis: widget.selectedPatient.diagnosis,
        diagnosisDate: widget.selectedPatient.diagnosisDate,
        surgeryDate: widget.selectedPatient.surgeryDate,
        medication: widget.selectedPatient.medication,
      );

      ref.read(staffScreenViewModelProvider.notifier).updateUser(updateUser);
      ref
          .read(SelectedPatientViewModelProvider.notifier)
          .setSelectedPatient(updateUser);

      Navigator.pop(context);
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return ref.watch(SelectedPatientViewModelProvider).when(
      data: (seletedUser) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.02,
            vertical: screenHeight * 0.01,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ========================이미지===========================
              Flexible(
                flex: 2,
                child: Container(
                  height: 100,
                  width: 100,
                  margin: const EdgeInsets.only(right: 20),
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: widget.selectedPatient.img.contains("assets")
                      ? Image.asset(
                          widget.selectedPatient.img,
                          fit: BoxFit.cover,
                          scale: 1,
                        )
                      : Image.file(
                          File(widget.selectedPatient.img),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              // ========================정보===========================
              Flexible(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.selectedPatient.userName,
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontSize: screenHeight * 0.03,
                                  ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(3),
                            onTap: () => showMemo(context, onClosedTap,
                                onSavedTap, widget.selectedPatient.memo),
                            child: SizedBox(
                              width: 30,
                              height: 30,
                              child: Icon(
                                Icons.description,
                                size: screenHeight * 0.03,
                                color: Theme.of(context).disabledColor,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: Sizes.size7),
                      width: screenWidth * 0.55,
                      child: Divider(
                        color: Colors.grey.shade400,
                        thickness: 1.5,
                        height: 1,
                      ),
                    ),
                    Text(
                      "Age: ${widget.selectedPatient.age}",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontSize: 13, color: Colors.grey.shade600),
                    ),
                    Text(
                      "Sex: ${widget.selectedPatient.gender == 0 ? "Male" : "Female"}",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontSize: 13, color: Colors.grey.shade600),
                    ),
                    Text(
                      "Date of birth: ${widget.selectedPatient.birth}",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontSize: 13, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
      error: (error, stackTrace) {
        return Column(
          children: [
            const Text("An error occurred while retrieving user information."),
            Text("err: $error"),
            Text("stackTrace: $stackTrace"),
          ],
        );
      },
      loading: () {
        return const Center(
          child: CupertinoActivityIndicator(),
        );
      },
    );
  }

  void showMemo(BuildContext context, onClosedTap, onSavedTap, memo) {
    String inputMemo = memo;
    String initMemo = memo;
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          final screenWidth = MediaQuery.of(context).size.width;
          final screenHeight = MediaQuery.of(context).size.height;
          return Dialog(
            backgroundColor: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Container(
                padding: EdgeInsets.all(screenWidth * 0.05),
                width: screenWidth * 0.75, //왜 안먹지
                height: screenHeight * 0.5,
                decoration: BoxDecoration(
                  color: Theme.of(context).dialogBackgroundColor,
                  borderRadius: BorderRadius.circular(7),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Text(
                          "Memo",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  fontSize: Sizes.size20,
                                  color: Theme.of(context).primaryColorLight),
                        ),
                        Divider(
                          thickness: 1,
                          color: Theme.of(context).primaryColorLight,
                        ),
                        SizedBox(
                          height: screenHeight * 0.33,
                          child: TextField(
                            controller: TextEditingController(text: initMemo),
                            maxLines: null,
                            minLines: null,
                            expands: true,
                            textInputAction: TextInputAction.newline,
                            cursorColor: Theme.of(context).secondaryHeaderColor,
                            decoration: InputDecoration(
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                      color: Theme.of(context).disabledColor),
                              hintText: "* Type more details",
                              filled: true,
                              border: InputBorder.none,
                              fillColor: Theme.of(context).cardColor,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: Sizes.size10,
                              ),
                            ),
                            onChanged: (value) {
                              inputMemo = value;
                              initMemo = value;
                            },
                          ),
                        ),
                      ],
                    ),
                    //======================== X 버튼 =========================
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: onClosedTap,
                        child: Icon(
                          Icons.close_rounded,
                          size: Sizes.size28,
                          color: Theme.of(context).primaryColorLight,
                        ),
                      ),
                    ),
                    //======================== 저장버튼 =========================

                    Align(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          onTap: () => widget.isSetting
                              ? onSavedTap(inputMemo)
                              : onClosedTap(),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            width: screenWidth * 0.6,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Theme.of(context).primaryColorLight
                                  : Theme.of(context).primaryColorDark,
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.grey.shade600
                                      : Colors.grey.shade500.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                            child: Center(
                                child: Text(
                              widget.isSetting ? "Save" : "Close",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(fontSize: 16),
                            )),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ).animate().scaleY(
                begin: 0,
                end: 1,
                duration: 100.ms,
              );
        });
  }
}
