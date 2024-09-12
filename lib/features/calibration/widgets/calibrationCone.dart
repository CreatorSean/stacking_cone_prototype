import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/services/bluetooth_service/view_models/bluetooth_service.dart';

class Calibrationcone extends ConsumerStatefulWidget {
  const Calibrationcone({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CalibrationconeState();
}

class _CalibrationconeState extends ConsumerState<Calibrationcone> {
  List<int> coneMatrix = [0, 0, 0, 0, 0, 0, 0, 0, 0];

  void _setIndex(int index) {
    // coneMatrix 배열에서 해당 index 값이 1을 넘으면 아무 작업도 하지 않음
    if (coneMatrix[index] > 1) {
      return;
    }
    coneMatrix[index]++; // 해당 index의 값을 증가
    final calibrationCommand = 'C,$index';
    ref
        .read(bluetoothServiceProvider.notifier)
        .doCalibration(calibrationCommand);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 1.0,
      children: List.generate(
        9,
        (index) {
          return _buildGridItem(context, index);
        },
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => _setIndex(index),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 176, 233, 247),
              border: Border.all(
                color: Colors.black,
                width: 1.5,
              ),
            ),
          ),
          if (coneMatrix[index] > 0)
            Positioned.fill(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(color: Colors.transparent),
                  ),
                  if (coneMatrix[index] > 0)
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 105, 221, 238),
                        border: Border.all(
                          color: Colors.black,
                          width: 1.5,
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
