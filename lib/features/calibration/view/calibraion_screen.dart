import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/common/constants/gaps.dart';
import 'package:stacking_cone_prototype/common/main_appbar.dart';
import 'package:stacking_cone_prototype/features/calibration/widgets/calibrationCone.dart';

class CalibraionScreen extends ConsumerStatefulWidget {
  const CalibraionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CalibraionScreenState();
}

class _CalibraionScreenState extends ConsumerState<CalibraionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: MainAppBar(
            isSelectScreen: false,
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Text(
                  "Calibration",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Gaps.v40,
                const Calibrationcone(),
              ],
            ),
          ),
        ));
  }
}
