import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothModel {
  List<BluetoothDiscoveryResult> results;
  List<int> coneMatrixMsg;
  bool? isConnecting;
  bool? isCalibrating;
  bool? isOffsetting;
  bool? isGraming;

  BluetoothModel(
      {required this.results,
      required this.coneMatrixMsg,
      this.isConnecting,
      this.isCalibrating,
      this.isOffsetting,
      this.isGraming});

  BluetoothModel copyWith({
    List<BluetoothDiscoveryResult>? results,
    List<int>? coneMatrixMsg,
    bool? isConnecting,
    bool? isCalibrating,
    bool? isOffsetting,
    bool? isGraming,
  }) {
    return BluetoothModel(
        results: results ?? this.results,
        coneMatrixMsg: coneMatrixMsg ?? this.coneMatrixMsg,
        isConnecting: isConnecting ?? this.isConnecting,
        isCalibrating: isCalibrating ?? this.isCalibrating,
        isOffsetting: isOffsetting ?? this.isOffsetting,
        isGraming: isGraming ?? this.isGraming);
  }
}
