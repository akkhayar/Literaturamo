import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:literaturamo/constants.dart';
import 'package:provider/provider.dart';

class LocalProvider extends ChangeNotifier {
  Locale _locale = Locale(Language.english.code);

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!AppLocalizations.supportedLocales.contains(locale)) return;
    _locale = locale;
    notifyListeners();
  }

  void clearLocale() {
    _locale = Locale(Language.english.code);
    notifyListeners();
  }
}

class LanguagePicker extends StatelessWidget {
  const LanguagePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocalProvider>(context);
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        dropdownColor:
            Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        value: provider.locale,
        icon: Container(width: 12),
        items: AppLocalizations.supportedLocales
            .map(
              (locale) => DropdownMenuItem(
                value: locale,
                child: Center(
                  child: Text(Language.fromCode(locale.languageCode)
                          ?.code
                          .toUpperCase() ??
                      ""),
                ),
                onTap: () => provider.setLocale(locale),
              ),
            )
            .toList(),
        onChanged: (_) {},
      ),
    );
  }
}
