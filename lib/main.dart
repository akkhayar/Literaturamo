import 'package:fable/utils/constants.dart';
import 'package:fable/screens/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: LibThemes.basicLight,
      home: const HomeScreen(),
    );
  }
}
