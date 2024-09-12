import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/services/bluetooth_service/models/bluetooth_model.dart';

class BluetoothService extends AsyncNotifier<BluetoothModel> {
  late BluetoothModel btModel;
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
      // 데이터 스트림을 받는 중 오류로
      // <, >가 반대로 들어오는 경우를 방지
      if (rawMsg.indexOf('<') > rawMsg.indexOf('>')) {
        rawMsg = "";
      } else {
        String temp =
            rawMsg.substring(rawMsg.indexOf('<') + 1, rawMsg.indexOf('>'));
        refinedMsg = temp;
        print(refinedMsg);

        List<int> coneMatrixMsg = refinedMsg
            .split(',')
            .map((e) => int.parse(e))
            .toList(); // [0, 0, 0]

        print(coneMatrixMsg);

        btModel =
            BluetoothModel(results: results, coneMatrixMsg: coneMatrixMsg);
        state = AsyncValue.data(btModel);
        rawMsg = '';
      }
    }
  }

  Future<void> onSendData(List<int> gameRuleList) async {
    if (connection != null && connection!.isConnected) {
      // List<int>를 "1,2" 형태의 문자열로 변환
      String message = gameRuleList.join(",");
      String messages = '[$message]';
      // 문자열을 UTF-8 바이트로 인코딩하여 전송
      connection!.output.add(Uint8List.fromList(utf8.encode(messages)));
      await connection!.output.allSent;
      print('Success');
    } else {
      print('Cannot send message, no connection established');
    }
  }

  Future<void> doCalibration(String calibrationCommand) async {
    try {
      if (connection != null && connection!.isConnected) {
        // 문자열을 UTF-8로 인코딩한 후 바이트 배열로 변환하여 전송
        connection!.output
            .add(Uint8List.fromList(utf8.encode(calibrationCommand)));
        await connection!.output.allSent; // 전송 완료 대기
        print('Calibration Success');
        print(calibrationCommand);
      } else {
        print("Can't do Calibration: No active connection.");
      }
    } catch (e) {
      print("Calibration failed: $e");
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
        btModel = BluetoothModel(
            results: results, coneMatrixMsg: [0, 0, 0, 0, 0, 0, 0, 0, 0]);

        state = AsyncValue.data(btModel);
      }
    });

    _streamSubscription!.onDone(() {
      isDiscovering = false;
      btModel = BluetoothModel(
          results: results, coneMatrixMsg: [0, 0, 0, 0, 0, 0, 0, 0, 0]);
      state = AsyncValue.data(btModel);
    });
  }

  @override
  FutureOr<BluetoothModel> build() {
    btModel = BluetoothModel(
        results: results, coneMatrixMsg: [0, 0, 0, 0, 0, 0, 0, 0, 0]);
    startDiscovery();

    return btModel;
  }
}

final bluetoothServiceProvider =
    AsyncNotifierProvider<BluetoothService, BluetoothModel>(
        () => BluetoothService());
