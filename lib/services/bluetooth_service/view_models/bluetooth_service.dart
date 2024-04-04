import 'dart:async';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BluetoothService extends AsyncNotifier<List<BluetoothDiscoveryResult>> {
  StreamSubscription<BluetoothDiscoveryResult>? _streamSubscription;
  List<BluetoothDiscoveryResult> results =
      List<BluetoothDiscoveryResult>.empty(growable: true);
  bool isDiscovering = false;

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
