import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stacking_cone_prototype/features/bluetooth/model/bluetooth_devices_model.dart';
import 'package:stacking_cone_prototype/features/bluetooth/view_model/selected_device_view_model.dart';

class BluetoothDevicesViewModel extends AsyncNotifier<BluetoothDevicesModel> {
  BluetoothDevicesModel model = BluetoothDevicesModel();
  final FlutterBluePlus flutterBlue = FlutterBluePlus.instance;

  void initBLE() {
    flutterBlue.isScanning.listen((isScanning) {
      print("isScanning: $isScanning");
    });
  }

  List<ScanResult> sortDevices(List<ScanResult> result) {
    List<ScanResult> names =
        result.where((r) => r.device.name.isNotEmpty).toList();

    names.addAll(result
        .where((r) =>
            r.advertisementData.localName.isNotEmpty && r.device.name.isEmpty)
        .toList());
    final noNames = result
        .where((r) =>
            r.device.name.isEmpty && r.advertisementData.localName.isEmpty)
        .toList();

    names.sort((a, b) => a.device.name.compareTo(b.device.name));

    names.addAll(noNames);

    return names;
  }

  Future<void> selectDevice(ScanResult device) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      model = model.copyWith(selectedDevice: device);
      List<ScanResult> scanResultList = model.scanResultList;

      if (model.selectedDevice != null) {
        scanResultList.removeWhere((element) =>
            element.device.id.id == model.selectedDevice!.device.id.id);

        model = model.copyWith(
            scanResultList: [model.selectedDevice!] + scanResultList);
      }

      for (final device2 in model.scanResultList) {
        await device2.device.disconnect();
      }

      ref.read(selectedDeviceViewModelProvider.notifier).select(
            model.selectedDevice!.device,
          );

      return model;
    });
  }

  Future<void> scanDevices() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        List<ScanResult> scanResultList = <ScanResult>[];
        scanResultList.clear();
        // 스캔 결과 리스너
        flutterBlue.scanResults.listen((results) {
          scanResultList = results;
        });
        // 스캔 시작, 제한 시간 4초
        await flutterBlue.startScan(timeout: const Duration(seconds: 4));

        scanResultList = sortDevices(scanResultList);

        model = model.copyWith(scanResultList: scanResultList);

        for (final device in model.scanResultList) {
          await device.device.disconnect();
        }

        return model;
      } catch (e) {
        return model;
      }
    });
  }

  @override
  FutureOr<BluetoothDevicesModel> build() {
    return model;
  }
}

final bluetooDevicesthViewModelProvider =
    AsyncNotifierProvider<BluetoothDevicesViewModel, BluetoothDevicesModel>(
  () => BluetoothDevicesViewModel(),
);
