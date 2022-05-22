import 'package:fable/constants.dart';
import 'package:fable/screens/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Literaturamo());
}

class Literaturamo extends StatelessWidget {
  const Literaturamo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: LibThemes.basicDark,
      home: const HomeScreen(),
    );
  }
}
