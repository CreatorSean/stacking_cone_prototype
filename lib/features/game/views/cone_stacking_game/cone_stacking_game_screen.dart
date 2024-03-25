import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/common/constants/gaps.dart';
import 'package:stacking_cone_prototype/common/main_appbar.dart';
import 'package:stacking_cone_prototype/features/game/widgets/cone_container_widget.dart';
import 'package:stacking_cone_prototype/features/game_select/widgets/stop_button.dart';

class ConeStackingGameScreen extends ConsumerStatefulWidget {
  const ConeStackingGameScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConeStackingGameScreenState();
}

class _ConeStackingGameScreenState
    extends ConsumerState<ConeStackingGameScreen> {
  @override
  Widget build(BuildContext context) {
    // `const` 키워드를 제거하여 SingleChildScrollView가 제대로 작동하도록 합니다.
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: MainAppBar(
          isSelectScreen: false,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          // Column을 SingleChildScrollView로 감싸 스크롤 가능하게 합니다.
          child: Column(
            mainAxisSize: MainAxisSize.min, // Column에 mainAxisSize를 추가합니다.
            children: [
              Text(
                "단일 모드",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Gaps.v6,
              Text(
                "LED MODE",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Gaps.v120,
              const ConContainerWidget(),
              Gaps.v150,
              Row(
                // const StopButton(),
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const StopButton(),
                  const SizedBox(width: 200),
                  Text(
                    "남은 시간 : ",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
