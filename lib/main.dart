import 'package:literaturamo/utils/constants.dart';
import 'package:literaturamo/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:literaturamo/utils/tasks.dart' as tasks;
import 'package:flutter/services.dart';

void main() async {
  await tasks.setup();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = LibThemes.basicDark;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: theme.appBarTheme.backgroundColor),
    );
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: appTitle,
      theme: theme,
      home: const HomeScreen(),
    );
  }
}
