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
              // For index 1, keep the background white
              childWidget = Container(
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
              );
            } else if (index == 3) {
              // For index 3, display an image at the center
              childWidget = Container(
                decoration: BoxDecoration(
                  color: const Color(0xfff0e5c8),
                  border: Border.all(
                    color: const Color(0xFF332F23),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/redcone.png',
                    width: 100, // Set width as desired
                    height: 100, // Set height as desired
                  ),
                ),
              );
            } else {
              // For other indexes, display a text
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
