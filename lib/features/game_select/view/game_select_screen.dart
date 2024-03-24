import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/common/constants/gaps.dart';
import 'package:stacking_cone_prototype/common/constants/sizes.dart';
import 'package:stacking_cone_prototype/common/main_appbar.dart';

class GameSelectScreen extends ConsumerStatefulWidget {
  const GameSelectScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GameSelectScreenState();
}

class _GameSelectScreenState extends ConsumerState<GameSelectScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: MainAppBar(),
      ),
      body: Column(
        children: [
          Gaps.v60,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Select Game",
                style: TextStyle(
                  fontSize: Sizes.size48,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
