import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/features/bluetooth/model/selected_device_model.dart';
import 'package:stacking_cone_prototype/features/bluetooth/view_model/bluetooth_devices_view_model.dart';
import 'package:stacking_cone_prototype/features/bluetooth/view_model/selected_device_view_model.dart';

class BluetoothListTile extends ConsumerStatefulWidget {
  final ScanResult r;
  final int index;
  final bool selected;

  const BluetoothListTile({
    super.key,
    required this.r,
    required this.index,
    this.selected = false,
  });

  @override
  ConsumerState<BluetoothListTile> createState() => _BluetoothListTileState();
}

class _BluetoothListTileState extends ConsumerState<BluetoothListTile> {
  /*  장치의 신호값 위젯  */
  Widget deviceSignal({required ScanResult r, SelectedDeviceModel? model}) {
    if (!widget.selected) {
      return Text(
        r.rssi.toString(),
        style: const TextStyle(
          color: Colors.white,
        ),
      );
    } else {
      switch (model!.deviceState) {
        case BluetoothDeviceState.connected:
          return const Icon(
            Icons.bluetooth_audio_outlined,
            color: Colors.blueAccent,
          );
        case BluetoothDeviceState.connecting:
          return const Icon(
            Icons.bluetooth_audio_outlined,
            color: Colors.white,
          );
        case BluetoothDeviceState.disconnected:
          return const Icon(
            Icons.bluetooth_disabled,
            color: Colors.grey,
          );
        case BluetoothDeviceState.disconnecting:
          return const Icon(
            Icons.bluetooth_disabled,
            color: Colors.white,
          );
      }
    }
  }

  /* 장치의 MAC 주소 위젯  */
  Widget deviceMacAddress({required ScanResult r, SelectedDeviceModel? model}) {
    return Text(
      widget.selected ? model!.stateText : r.device.id.id,
      style: const TextStyle(
        color: Colors.white,
      ),
    );
  }

  /* 장치의 명 위젯  */
  Widget deviceName({required ScanResult r, SelectedDeviceModel? model}) {
    String name = '';

    if (r.device.name.isNotEmpty) {
      // device.name에 값이 있다면
      name = r.device.name;
    } else if (r.advertisementData.localName.isNotEmpty) {
      // advertisementData.localName에 값이 있다면
      name = r.advertisementData.localName;
    } else {
      // 둘다 없다면 이름 알 수 없음...
      name = 'N/A';
    }
    return Text(
      name,
      style: const TextStyle(
        color: Colors.white,
      ),
    );
  }

  /* BLE 아이콘 위젯 */
  Widget leading({required ScanResult r, SelectedDeviceModel? model}) {
    return CircleAvatar(
      backgroundColor: widget.selected ? Colors.blueAccent : Colors.grey,
      child: const Icon(
        Icons.bluetooth,
        color: Colors.white,
      ),
    );
  }

  /* 장치 아이템을 탭 했을때 호출 되는 함수 */
  void onTap({required ScanResult r, SelectedDeviceModel? model}) {
    ref.read(bluetooDevicesthViewModelProvider.notifier).selectDevice(r);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selected) {
      return ref.watch(selectedDeviceViewModelProvider).when(
            data: (selectedDeviceModel) {
              return ListTile(
                onTap: () => onTap(r: widget.r, model: selectedDeviceModel),
                leading: leading(r: widget.r, model: selectedDeviceModel),
                title: deviceName(r: widget.r, model: selectedDeviceModel),
                subtitle:
                    deviceMacAddress(r: widget.r, model: selectedDeviceModel),
                trailing: deviceSignal(r: widget.r, model: selectedDeviceModel),
              )
                  .animate()
                  .then(
                    delay: (widget.index * 50).ms,
                  )
                  .flipV(
                    begin: -1,
                    end: 0,
                    duration: 500.ms,
                    curve: Curves.easeOutCubic,
                  )
                  .fadeIn();
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stackTrace) => const Center(
              child: Text('error'),
            ),
          );
    } else {
      return ListTile(
        onTap: () => onTap(r: widget.r),
        leading: leading(r: widget.r),
        title: deviceName(r: widget.r),
        subtitle: deviceMacAddress(r: widget.r),
        trailing: deviceSignal(r: widget.r),
      )
          .animate()
          .then(
            delay: (widget.index * 50).ms,
          )
          .flipV(
            begin: -1,
            end: 0,
            duration: 500.ms,
            curve: Curves.easeOutCubic,
          )
          .fadeIn();
    }
  }
}
