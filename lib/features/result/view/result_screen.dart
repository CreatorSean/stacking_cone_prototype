import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/common/constants/sizes.dart';

class ResultScreen extends ConsumerStatefulWidget {
  static String routeURL = '/result';
  static String routeName = 'result';
  const ResultScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Result Screen',
          style: TextStyle(
            color: Color(0xFFF8F9FA),
            fontSize: Sizes.size24,
          ),
        ),
      ),
    );
  }
}
