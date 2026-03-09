import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothModel {
  List<BluetoothDiscoveryResult> results;
  List<int> coneMatrixMsg;
  bool? isConnecting;
  bool? isCalibrating;
  bool? isOffsetting;

  BluetoothModel({
    required this.results,
    required this.coneMatrixMsg,
    this.isConnecting,
    this.isCalibrating,
    this.isOffsetting,
  });

  BluetoothModel copyWith({
    List<BluetoothDiscoveryResult>? results,
    List<int>? coneMatrixMsg,
    bool? isConnecting,
    bool? isCalibrating,
    bool? isOffsetting,
  }) {
    return BluetoothModel(
      results: results ?? this.results,
      coneMatrixMsg: coneMatrixMsg ?? this.coneMatrixMsg,
      isConnecting: isConnecting ?? this.isConnecting,
      isCalibrating: isCalibrating ?? this.isCalibrating,
      isOffsetting: isOffsetting ?? this.isOffsetting,
    );
  }
}
