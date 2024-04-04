import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/services/bluetooth_BLE_service/model/selected_device_model.dart';

class SelectedDeviceViewModel extends AsyncNotifier<SelectedDeviceModel> {
  SelectedDeviceModel model = SelectedDeviceModel();
  List<BluetoothService> bluetoothService = [];
  Map<String, List<int>> notifyDatas = {};
  StreamSubscription<BluetoothDeviceState>? _stateListener;
  bool reading = false;
  Timer timer = Timer.periodic(const Duration(seconds: 1), (timer) {});

  void select(BluetoothDevice device) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      if (model.device != null) {
        model.device!.disconnect();
        model.device = null;
        return model;
      }

      _stateListener = device.state.listen((event) {
        if (model.deviceState == event) {
          return;
        }
        setBleConnectionState(event);
      });
      model.device = device;

      return model;
    });

    if (model.device == null) {
      return;
    }

    connect();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      readCharacteristic();
    });
  }

  void readCharacteristic() async {
    for (BluetoothService service in bluetoothService) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.uuid ==
                Guid("0000ffe0-0000-1000-8000-00805f9b34fb") ||
            characteristic.uuid ==
                Guid("0000fee7-0000-1000-8000-00805f9b34fb")) {
          if (!reading) {
            reading = true;
            List<int> value = await characteristic.read();
            // convet value to string from byte array
            final str = String.fromCharCodes(value);

            print('read value: $str');
            reading = false;
          }
          /////////////////////////
          if (characteristic.properties.notify &&
              characteristic.descriptors.isNotEmpty) {
            // 진짜 0x2902 가 있는지 단순 체크용!
            for (BluetoothDescriptor d in characteristic.descriptors) {
              print('BluetoothDescriptor uuid ${d.uuid}');
              if (d.uuid == BluetoothDescriptor.cccd) {
                print('d.lastValue: ${d.lastValue}');
              }
            }

            // notify가 설정 안되었다면...
            if (!characteristic.isNotifying) {
              try {
                await characteristic.setNotifyValue(true);
                // 받을 데이터 변수 Map 형식으로 키 생성
                notifyDatas[characteristic.uuid.toString()] = List.empty();
                characteristic.value.listen((value) {
                  // 데이터 읽기 처리!
                  print('${characteristic.uuid}: $value');

                  // 받은 데이터 저장 화면 표시용
                  notifyDatas[characteristic.uuid.toString()] = value;
                  print('this is notifyDatas : $notifyDatas');
                });

                // 설정 후 일정시간 지연
                await Future.delayed(const Duration(milliseconds: 500));
              } catch (e) {
                print('error ${characteristic.uuid} $e');
              }
            }
          }
          ///////////////////////
        }
      }
    }
  }

  /* 연결 상태 갱신 */
  void setBleConnectionState(BluetoothDeviceState event) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      switch (event) {
        case BluetoothDeviceState.disconnected:
          model.stateText = '연결 해제됨';
          // 버튼 상태 변경
          break;
        case BluetoothDeviceState.disconnecting:
          model.stateText = '연결 해제중';
          break;
        case BluetoothDeviceState.connected:
          model.stateText = '연결됨';
          // 버튼 상태 변경
          break;
        case BluetoothDeviceState.connecting:
          model.stateText = '연결중';
          break;
      }

      model.deviceState = event;

      return model;
    });
  }

  Future<bool> connect() async {
    Future<bool>? returnValue;

    setBleConnectionState(BluetoothDeviceState.connecting);

    await model.device!
        .connect(autoConnect: false)
        .timeout(const Duration(milliseconds: 15000), onTimeout: () {
      returnValue = Future.value(false);
      debugPrint('timeout failed');
      setBleConnectionState(BluetoothDeviceState.disconnected);
    }).then((data) async {
      bluetoothService.clear();
      if (returnValue == null) {
        //returnValue가 null이면 timeout이 발생한 것이 아니므로 연결 성공
        setBleConnectionState(BluetoothDeviceState.connected);
        debugPrint('connection successful');
        debugPrint('start discover service');
        List<BluetoothService> bleServices =
            await model.device!.discoverServices();

        bluetoothService = bleServices;

        returnValue = Future.value(true);
      }
    });

    return returnValue ?? Future.value(false);
  }

  void disconnect() {
    //timer.cancel();
    try {
      model.stateText = 'Disconnecting';
      if (model.device != null) {
        model.device!.disconnect();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  FutureOr<SelectedDeviceModel> build() {
    return model;
  }
}

final selectedDeviceViewModelProvider =
    AsyncNotifierProvider<SelectedDeviceViewModel, SelectedDeviceModel>(
  () => SelectedDeviceViewModel(),
);
