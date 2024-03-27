//아두이노와 통신하기 위한 임의의 코드입니다.
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothArduinoConnector extends StatefulWidget {
  const BluetoothArduinoConnector({super.key});

  @override
  _BluetoothArduinoConnectorState createState() =>
      _BluetoothArduinoConnectorState();
}

class _BluetoothArduinoConnectorState extends State<BluetoothArduinoConnector> {
  BluetoothConnection? connection;
  List<BluetoothDevice> devicesList = [];
  BluetoothDevice? selectedDevice;
  bool isConnecting = true;

  @override
  void initState() {
    super.initState();
    FlutterBluetoothSerial.instance
        .getBondedDevices()
        .then((List<BluetoothDevice> bondedDevices) {
      setState(() {
        devicesList = bondedDevices;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth HC-05 Connector'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Available Devices'),
            trailing: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () async {
                final List<BluetoothDevice> bondedDevices =
                    await FlutterBluetoothSerial.instance.getBondedDevices();
                setState(() {
                  devicesList = bondedDevices;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: devicesList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(devicesList[index].name ?? "Unknown device"),
                  subtitle: Text(devicesList[index].address.toString()),
                  onTap: () async {
                    selectedDevice = devicesList[index];
                    await _connect();
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed:
                isConnecting ? null : () => _sendMessage("Hello from Flutter!"),
            child: const Text('Send Message to HC-05'),
          ),
        ],
      ),
    );
  }

  Future<void> _connect() async {
    if (selectedDevice == null) return;

    setState(() {
      isConnecting = true;
    });

    await BluetoothConnection.toAddress(selectedDevice!.address)
        .then((connection) {
      print('Connected to the device');
      connection = connection;
    }).catchError((error) {
      print('Cannot connect, exception occurred');
      print(error);
    });

    setState(() {
      isConnecting = false;
    });

    connection!.input!.listen(_onDataReceived).onDone(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _onDataReceived(Uint8List data) {
    // Handle data when received
    print('Data incoming: ${ascii.decode(data)}');
  }

  void _sendMessage(String message) async {
    connection!.output.add(Uint8List.fromList(utf8.encode(message)));
    await connection!.output.allSent;
    print('Message sent');
  }

  @override
  void dispose() {
    connection?.dispose();
    super.dispose();
  }
}
