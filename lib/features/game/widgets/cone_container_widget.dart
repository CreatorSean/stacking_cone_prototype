import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConContainerWidget extends StatelessWidget {
  const ConContainerWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Center(
        child: Container(
          width: 360,
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFF332F23),
              width: 1.5,
            ),
          ),
          child: GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 0.8,
            children: List.generate(6, (index) {
              return Container(
                decoration: BoxDecoration(
                  color: const Color(0xfff0e5c8),
                  border: Border.all(
                    color: const Color(0xFF332F23),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    '$index',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
