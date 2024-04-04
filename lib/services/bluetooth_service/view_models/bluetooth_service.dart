import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BluetoothService extends AsyncNotifier<List<BluetoothDiscoveryResult>> {
  StreamSubscription<BluetoothDiscoveryResult>? _streamSubscription;
  List<BluetoothDiscoveryResult> results =
      List<BluetoothDiscoveryResult>.empty(growable: true);
  bool isDiscovering = false;
  bool isConnecting = false;
  BluetoothConnection? connection;
  String rawMsg = '';
  String refinedMsg = '';
  String selectedAddress = '';

  void _onDataReceived(Uint8List data) {
    // encoding the data received from the bluetooth device
    final dataString = String.fromCharCodes(data);
    rawMsg += dataString;
    if (rawMsg.contains('<') && rawMsg.contains('>')) {
      String temp =
          rawMsg.substring(rawMsg.indexOf('<') + 1, rawMsg.indexOf('>'));

      refinedMsg = temp;

      print(refinedMsg);
      rawMsg = '';
    }
  }

  void connectToDevice({required BluetoothDevice device}) {
    selectedAddress = device.address;
    BluetoothConnection.toAddress(device.address).then((connection) {
      this.connection = connection;

      connection.input!.listen(_onDataReceived);
    });
  }

  void dispose() {
    _streamSubscription?.cancel();
    connection?.dispose();
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
  }

  void startDiscovery() {
    if (isDiscovering) {
      return;
    }

    _streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      final existingIndex = results
          .indexWhere((element) => element.device.address == r.device.address);
      if (existingIndex >= 0) {
        results[existingIndex] = r;
      } else {
        results.add(r);
        state = AsyncValue.data(results);
      }
    });

    _streamSubscription!.onDone(() {
      isDiscovering = false;
      state = AsyncValue.data(results);
    });
  }

  @override
  FutureOr<List<BluetoothDiscoveryResult>> build() {
    startDiscovery();

    return results;
  }
}

final bluetoothServiceProvider =
    AsyncNotifierProvider<BluetoothService, List<BluetoothDiscoveryResult>>(
        () => BluetoothService());
