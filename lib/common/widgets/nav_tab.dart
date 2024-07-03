import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class NavigationTab extends StatefulWidget {
  final String name;
  final IconData icon;
  final int page;
  final double height;
  final double width;
  final bool selected;
  final Function? onTap;

  const NavigationTab({
    super.key,
    this.name = 'home',
    this.icon = Icons.home,
    this.page = 0,
    this.height = 60,
    this.width = 100,
    this.selected = false,
    this.onTap,
  });

  @override
  State<NavigationTab> createState() => _NavigationTabState();
}

class _NavigationTabState extends State<NavigationTab> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      child: SizedBox(
        height: widget.height,
        width: widget.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              color: widget.selected
                  ? const Color(0xFF223A5E)
                  : Colors.grey.shade500,
            ),
            Text(
              widget.name,
              style: TextStyle(
                color: widget.selected
                    ? const Color(0xFF223A5E)
                    : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      )
          .animate(
            target: widget.selected ? 1 : 0,
          )
          .scale(
            begin: const Offset(1, 1),
            end: const Offset(1.2, 1.2),
            duration: 300.ms,
            curve: Curves.easeInOut,
          )
          .slideY(
            begin: 0,
            end: -0.1,
            curve: Curves.bounceInOut,
          ),
    );
  }
}
