import 'package:flutter/material.dart';

class ConContainerWidget extends StatelessWidget {
  const ConContainerWidget({Key? key});

  @override
  Widget build(BuildContext context) {
    return Center(
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
            Widget childWidget;
            if (index == 1) {
              // For index 1, display image over white background
              childWidget = Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xFF332F23),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$index',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/redcone.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            } else {
              // For other indexes, display text only
              childWidget = Container(
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
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              );
            }
            return childWidget;
          }),
        ),
      ),
    );
  }
}
