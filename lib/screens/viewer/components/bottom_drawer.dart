import 'package:flutter/material.dart';

class BottomDrawer extends StatefulWidget {
  final Widget child;

  const BottomDrawer({required this.child, super.key});

  @override
  State<BottomDrawer> createState() => _BottomDrawerState();
}

class _BottomDrawerState extends State<BottomDrawer> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    const double height = 193;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(8),
        ),
      ),
      width: width,
      height: height,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 100, right: 100, top: 4),
            width: 93,
            height: 3,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: const BorderRadius.all(
                Radius.circular(2),
              ),
            ),
          ),
          widget.child
        ],
      ),
    );
  }
}
