import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class EditorRibbon extends StatelessWidget {
  const EditorRibbon({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 30,
      child: Container(
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        child: const Text("Ribbon"),
      ),
    );
  }
}
