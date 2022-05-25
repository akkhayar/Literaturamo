import 'package:fable/utils/api.dart';
import 'package:fable/utils/constants.dart';
import 'package:fable/screens/home.dart';
import 'package:flutter/material.dart';

/// TODO:
///   1. Work on night mode PDF rendering
///   2. Work on better animated retrival of the
///     appbar on tap
///   3. Setup overlay that shows the definition of a
///     word on select
///   4. Fix flexible error

void main() {
  loadExtensions();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: LibThemes.basicDark,
      home: const HomeScreen(),
    );
  }
}
