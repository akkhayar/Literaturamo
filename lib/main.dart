import 'package:literaturamo/utils/constants.dart';
import 'package:literaturamo/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:literaturamo/utils/tasks.dart' as tasks;

/// TODO:
/// 1. Different colors for different formats
/// 2. Better skeleton loading for opening text files
/// 3. Too intensive textual parsing for

void main() async {
  await tasks.setup();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: appTitle,
      theme: LibThemes.basicDark,
      home: const HomeScreen(),
    );
  }
}
