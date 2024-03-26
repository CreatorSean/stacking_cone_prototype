import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class SelectedDeviceModel {
  BluetoothDevice? device;
  BluetoothDeviceState deviceState;
  String stateText;

  SelectedDeviceModel({
    this.device,
    this.deviceState = BluetoothDeviceState.disconnected,
    this.stateText = '연결 해제됨',
  });
}
