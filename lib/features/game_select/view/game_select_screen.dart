import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/common/constants/gaps.dart';
import 'package:stacking_cone_prototype/common/constants/sizes.dart';

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
      body: Column(
        children: [
          Gaps.v24,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "select Game",
                style: TextStyle(
                  fontSize: Sizes.size16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
