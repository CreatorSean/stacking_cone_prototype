import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/bluetooth_service/view_models/bluetooth_service.dart';

class GramScreen extends ConsumerStatefulWidget {
  const GramScreen({super.key});

  @override
  ConsumerState<GramScreen> createState() => _GramScreenState();
}

class _GramScreenState extends ConsumerState<GramScreen> {
  Future<void> _onButtonPressed(String command, String label) async {
    await ref.read(bluetoothServiceProvider.notifier).doGram(command);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label 명령을 전송했습니다.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttons = [
      {'label': 'Gram 1', 'command': '1'},
      {'label': 'Gram 2', 'command': '2'},
      {'label': 'Gram 3', 'command': '3'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gram Screen'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: buttons.map((button) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => _onButtonPressed(
                      button['command']!,
                      button['label']!,
                    ),
                    child: Text(button['label']!),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
