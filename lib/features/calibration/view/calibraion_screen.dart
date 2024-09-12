import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/common/main_appbar.dart';

class CalibraionScreen extends ConsumerStatefulWidget {
  const CalibraionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CalibraionScreenState();
}

class _CalibraionScreenState extends ConsumerState<CalibraionScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: MainAppBar(
          isSelectScreen: false,
        ),
      ),
    );
  }
}
