import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/features/game/view_model/cone_stacking_game_vm.dart';

class TargetindexSelectForm extends ConsumerStatefulWidget {
  const TargetindexSelectForm({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TargetindexSelectFormState();
}

class _TargetindexSelectFormState extends ConsumerState<TargetindexSelectForm>
    with TickerProviderStateMixin {
  List<int> coneMatrix = [0, 0, 0, 0, 0, 0, 0, 0, 0];

  void _setIndex(int index) {
    coneMatrix = [0, 0, 0, 0, 0, 0, 0, 0, 0];
    coneMatrix[index]++;
    ref.watch(gameProvider.notifier).setTargetIndex(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 1.0,
      children: List.generate(
        9,
        (index) {
          return _buildGridItem(context, index);
        },
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => _setIndex(index),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xfff0e5c8),
              border: Border.all(
                color: Colors.black,
                width: 1.5,
              ),
            ),
          ),
          if (coneMatrix[index] > 0)
            Positioned.fill(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(color: Colors.transparent),
                  ),
                  if (coneMatrix[index] > 0)
                    Image.asset(
                      'assets/images/redcone.png', // 이미지 경로를 설정하세요.
                      width: 180,
                      height: 180,
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
