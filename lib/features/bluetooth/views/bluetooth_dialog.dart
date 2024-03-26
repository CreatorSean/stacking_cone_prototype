import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:stacking_cone_prototype/common/constants/gaps.dart';
import 'package:stacking_cone_prototype/features/bluetooth/view_model/bluetooth_devices_view_model.dart';
import 'package:stacking_cone_prototype/features/bluetooth/views/widgets/bluetooth_list_tile.dart';

class BluetoothDialog extends ConsumerStatefulWidget {
  const BluetoothDialog({super.key});

  @override
  ConsumerState<BluetoothDialog> createState() => _BluetoothState();
}

class _BluetoothState extends ConsumerState<BluetoothDialog> {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;

  void onScan(WidgetRef ref) async {
    ref.read(bluetooDevicesthViewModelProvider.notifier).scanDevices();
  }

  @override
  Widget build(BuildContext context) {
    final displayHeight = MediaQuery.of(context).size.height;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: displayHeight * 0.55,
        width: displayHeight * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Theme.of(context).primaryColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ref.watch(bluetooDevicesthViewModelProvider).when(
              data: (model) {
                final scanResultList = model.scanResultList;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Gaps.v12,
                    const Text(
                      '연결 할 기기 선택',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xffFFFFFF)),
                    ),
                    scanResultList.isEmpty
                        ? Lottie.asset(
                            'assets/lottie/ble.json',
                            animate: false,
                          )
                        : Expanded(
                            child: ListView.separated(
                              itemCount: scanResultList.length,
                              itemBuilder: (context, index) {
                                return BluetoothListTile(
                                  r: scanResultList[index],
                                  selected:
                                      model.selectedDevice?.device.id.id ==
                                          scanResultList[index].device.id.id,
                                  index: index,
                                );
                              },
                              separatorBuilder: (BuildContext context, index) {
                                return const Divider(
                                  color: Colors.white24,
                                );
                              },
                            ),
                          ),
                    CupertinoButton(
                      onPressed: () {
                        onScan(ref);
                      },
                      child: const Icon(
                        Icons.search,
                        size: 22,
                        color: Color(0xffffffff),
                      ),
                    ),
                  ],
                );
              },
              loading: () => Center(
                child: Lottie.asset(
                  'assets/lottie/ble.json',
                ),
              ),
              error: (error, stackTrace) => Column(
                children: [
                  const Expanded(
                    child: Text(
                      '에러 발생',
                      style: TextStyle(
                        color: Color(0xffffffff),
                      ),
                    ),
                  ),
                  CupertinoButton(
                    onPressed: () {
                      onScan(ref);
                    },
                    child: const Icon(
                      Icons.search,
                      size: 22,
                      color: Color(0xffffffff),
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
