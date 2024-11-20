import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/features/staff/widgets/showErrorSnack.dart';
import 'package:stacking_cone_prototype/services/bluetooth_service/utils/bluetooth_device_entry.dart';
import 'package:stacking_cone_prototype/services/bluetooth_service/view_models/bluetooth_service.dart';

class BluetoothDialog extends ConsumerStatefulWidget {
  const BluetoothDialog({super.key});

  @override
  ConsumerState<BluetoothDialog> createState() => _BluetoothDialogState();
}

class _BluetoothDialogState extends ConsumerState<BluetoothDialog> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.015;
    return ref.watch(bluetoothServiceProvider).when(
          data: (btModel) {
            final results = btModel.results;
            results.sort((a, b) => a.device.isBonded ? -1 : 1);

            return Dialog(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.all(5),
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        final result = results[index];
                        final device = result.device;
                        final rssi = result.rssi;
                        final address = device.address;
                        return BluetoothDeviceListEntry(
                          width: width,
                          context: context,
                          device: device,
                          rssi: rssi,
                          onTap: () {
                            ref
                                .read(bluetoothServiceProvider.notifier)
                                .connectToDevice(device: device);
                            Navigator.of(context).pop();
                            showErrorSnack(context, '블루투스에 연결되었습니다!');
                          },
                          onLongPress: () async {
                            try {
                              bool bonded = false;
                              if (device.isBonded) {
                                await FlutterBluetoothSerial.instance
                                    .removeDeviceBondWithAddress(address);
                              } else {
                                bonded = (await FlutterBluetoothSerial.instance
                                    .bondDeviceAtAddress(address))!;
                              }
                              setState(() {
                                results[results.indexOf(result)] =
                                    BluetoothDiscoveryResult(
                                        device: BluetoothDevice(
                                          name: device.name ?? '',
                                          address: address,
                                          type: device.type,
                                          bondState: bonded
                                              ? BluetoothBondState.bonded
                                              : BluetoothBondState.none,
                                        ),
                                        rssi: result.rssi);
                              });
                            } catch (ex) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                        'Error occured while bonding'),
                                    content: Text(ex.toString()),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text("Close"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                        ).animate().fadeIn(
                              begin: 0,
                              curve: Curves.easeInCubic,
                              duration: const Duration(milliseconds: 400),
                            );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                      itemCount: results.length,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(bluetoothServiceProvider.notifier)
                          .startDiscovery();
                      setState(() {});
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.refresh),
                        SizedBox(width: 10),
                        Text("Refresh"),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text(
              error.toString(),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
        );
  }
}
