import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothModel {
  List<BluetoothDiscoveryResult> results;
  List<int> coneMatrixMsg;

  BluetoothModel({
    required this.results,
    required this.coneMatrixMsg,
  });
}
