import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothModel {
  List<BluetoothDiscoveryResult> results;
  List<int> coneMatrixMsg;
  bool? isConnecting;
  bool? isCalibrating;

  BluetoothModel({
    required this.results,
    required this.coneMatrixMsg,
    this.isConnecting,
    this.isCalibrating,
  });

  BluetoothModel copyWith({
    List<BluetoothDiscoveryResult>? results,
    List<int>? coneMatrixMsg,
    bool? isConnecting,
    bool? isCalibrating,
  }) {
    return BluetoothModel(
      results: results ?? this.results,
      coneMatrixMsg: coneMatrixMsg ?? this.coneMatrixMsg,
      isConnecting: isConnecting ?? this.isConnecting,
      isCalibrating: isCalibrating ?? this.isCalibrating,
    );
  }
}
