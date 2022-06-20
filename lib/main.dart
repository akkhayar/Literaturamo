import 'package:literaturamo/utils/constants.dart';
import 'package:literaturamo/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:literaturamo/utils/tasks.dart' as tasks;
import 'package:flutter/services.dart';
import 'package:literaturamo/widgets/lang_picker.dart';
import 'package:provider/provider.dart';

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
      SystemUiOverlayStyle(
        statusBarColor: theme.appBarTheme.backgroundColor,
      ),
    );
    return ChangeNotifierProvider(
      create: (context) => LocalProvider(),
      builder: (context, child) {
        final provider = Provider.of<LocalProvider>(context);
        return MaterialApp(
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          title: appTitle,
          locale: provider.locale,
          theme: theme,
          home: const HomeScreen(),
        );
      },
    );
  }
}
