import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothDevicesModel {
  List<ScanResult> scanResultList = <ScanResult>[];
  ScanResult? selectedDevice;

  BluetoothDevicesModel({
    this.scanResultList = const <ScanResult>[],
    this.selectedDevice,
  });

  BluetoothDevicesModel copyWith({
    List<ScanResult>? scanResultList,
    ScanResult? selectedDevice,
  }) {
    return BluetoothDevicesModel(
      scanResultList: scanResultList ?? this.scanResultList,
      selectedDevice: selectedDevice ?? this.selectedDevice,
    );
  }
}
