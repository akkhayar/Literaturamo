import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const String appTitle = "Literaturamo";
const String recentDocsBoxName = "recent50docs";
const String settingsBoxName = "settings";
const int docHiveTypeId = 0;
const int docTypeHiveTypeId = 1;

class SettingBoxOptions {
  SettingBoxOptions._();

  static const defaultPageIndex = "defaultPageIndex";
  static const defaultFileViewerInversion = "defaultFileViewerInversion";
}

Color saturate(Color original, int amount) {
  final copy = original;
  return copy
      .withBlue(copy.blue + amount)
      .withGreen(copy.green + amount)
      .withRed(copy.red + amount);
}

/// A set of preconfigured library colors.
class LibColors {
  LibColors._();

  static const peach = Color.fromARGB(255, 246, 176, 146);
  static const gray = Color(0xFF727779);
  static const lightGray = Color(0xFF93A1A1);
  static const darkGray = Color(0xFF5C5E5B);
  static const hagueBlue = Color.fromARGB(255, 23, 27, 29);
  static const lightHagueBlue = Color(0xFF262a2c);
  static const lighterHagueBlue = Color(0xFF35393b);
  static const solarizedBlue = Color(0xFF002B36);
  static const solarizedLightBlue = Color(0xFF073642);
  static const beige = Color(0xFFFDF6E3);
  static const waterBlue = Color(0xFF268AD1);
  static const indigo = Color(0xFF3F51B5);
  static const slate = Color(0xFF607D8B);
}

/// A set of preconfigured library themes.
class LibThemes {
  LibThemes._();

  static ThemeData _makeTheme({
    required Color accentColor,
    required Color onAccent,
    required Color backgroundColor,
    required Color onBackground,
    required Color lightBackgroundColor,
    required Color onLighterBackground,
    required Color lightestBackgroundColor,
    required Color onLightestBackground,
    required Color lighterBackgroundColor,
    required TextStyle subtitle1,
    required TextStyle subtitle2,
    required TextStyle bodyText2,
  }) {
    return ThemeData(
      appBarTheme: AppBarTheme(
        color: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: accentColor,
        ),
        actionsIconTheme: IconThemeData(
          color: onBackground,
        ),
        shape: Border(
          bottom: BorderSide(
            color: accentColor,
            width: 1,
          ),
        ),
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 20,
          color: onBackground,
          fontWeight: FontWeight.bold,
        ),
      ),
      dialogBackgroundColor: lightestBackgroundColor,
      dialogTheme: DialogTheme(
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 20,
          color: onLightestBackground,
          fontWeight: FontWeight.bold,
        ),
      ),
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: backgroundColor,
        onPrimary: onBackground,
        secondary: accentColor,
        onSecondary: onAccent,
        error: Colors.red,
        onError: Colors.yellow,
        background: backgroundColor,
        onBackground: onBackground,
        surface: lighterBackgroundColor,
        onSurface: onLighterBackground,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 1,
        backgroundColor: lightBackgroundColor,
        selectedItemColor: accentColor,
        selectedLabelStyle: TextStyle(
          color: accentColor,
        ),
        unselectedItemColor: lighterBackgroundColor,
        unselectedLabelStyle: TextStyle(
          color: lighterBackgroundColor,
        ),
      ),
      scaffoldBackgroundColor: backgroundColor,
      iconTheme: IconThemeData(color: accentColor),
      textTheme: TextTheme(
        bodyText2: bodyText2,
        subtitle1: subtitle1,
        subtitle2: subtitle2,
      ),
    );
  }

  static final basicDark = _makeTheme(
    accentColor: LibColors.peach,
    onAccent: Colors.white,
    backgroundColor: LibColors.hagueBlue,
    onBackground: Colors.white,
    lightBackgroundColor: const Color(0xFF262a2C),
    lighterBackgroundColor: const Color(0xFF646768),
    onLighterBackground: Colors.white,
    lightestBackgroundColor: const Color(0xFF35393B),
    onLightestBackground: Colors.white,
    bodyText2: GoogleFonts.playfairDisplay(
      color: Colors.white,
    ),
    subtitle1: GoogleFonts.playfairDisplay(color: Colors.white),
    subtitle2: GoogleFonts.playfairDisplay(color: Colors.grey),
  );

  // static final solarizedDark = _makeTheme(
  //   appBarColor: LibColors.solarizedLightBlue,
  //   appBarElevation: 0,
  //   appBarBorderColor: LibColors.waterBlue,
  //   appBarIconColor: LibColors.waterBlue,
  //   appBarBorderWidth: 1,
  //   titleTextStyle: GoogleFonts.playfairDisplay(
  //     fontSize: 20,
  //     color: Colors.white,
  //     fontWeight: FontWeight.bold,
  //   ),
  //   bottomNavBarElevation: 1,
  //   bottomNavBarSelectedItemColor: LibColors.waterBlue,
  //   bottomNavBarUnselectedItemColor: LibColors.lightGray,
  //   bottomNavBarSelectedLabelStyle: const TextStyle(
  //     color: Colors.white,
  //     fontStyle: FontStyle.italic,
  //   ),
  //   bottomNavBarUnselectedLabelStyle: const TextStyle(
  //     color: LibColors.lightGray,
  //   ),
  //   backgroundColor: LibColors.solarizedBlue,
  //   primaryColor: LibColors.solarizedLightBlue,
  //   iconColor: LibColors.waterBlue,
  //   bodyText2: GoogleFonts.playfairDisplay(
  //     color: Colors.white,
  //   ),
  //   subtitle1: GoogleFonts.playfairDisplay(
  //     color: Colors.white,
  //   ),
  //   subtitle2: GoogleFonts.playfairDisplay(
  //     color: Colors.grey,
  //   ),
  // );
}

enum Language {
  afrikaans("af"),
  albanian("sq"),
  amharic("am"),
  arabic("ar"),
  armenian("hy"),
  azerbaijani("az"),
  basque("eu"),
  belarusian("be"),
  bengali("bn"),
  bosnian("bs"),
  bulgarian("bg"),
  catalan("ca"),
  cebuano("ceb"),
  chichewa("ny"),
  chineseSimplified("zh-cn"),
  chineseTraditional("zh-tw"),
  corsican("co"),
  croatian("hr"),
  czech("cs"),
  danish("da"),
  dutch("nl"),
  english("en"),
  esperanto("eo"),
  estonian("et"),
  filipino("tl"),
  finnish("fi"),
  french("fr"),
  frisian("fy"),
  galician("gl"),
  georgian("ka"),
  german("de"),
  greek("el"),
  gujarati("gu"),
  haitianCreole("ht"),
  hausa("ha"),
  hawaiian("haw"),
  hebrew("he"),
  hindi("hi"),
  hmong("hmn"),
  hungarian("hu"),
  icelandic("is"),
  igbo("ig"),
  indonesian("id"),
  irish("ga"),
  italian("it"),
  japanese("ja"),
  javanese("jw"),
  kannada("kn"),
  kazakh("kk"),
  khmer("km"),
  korean("ko"),
  kurdishKurmanji("ku"),
  kyrgyz("ky"),
  lao("lo"),
  latin("la"),
  latvian("lv"),
  lithuanian("lt"),
  luxembourgish("lb"),
  macedonian("mk"),
  malagasy("mg"),
  malay("ms"),
  malayalam("ml"),
  maltese("mt"),
  maori("mi"),
  marathi("mr"),
  mongolian("mn"),
  myanmar("my"),
  burmese("my"),
  nepali("ne"),
  norwegian("no"),
  odia("or"),
  pashto("ps"),
  persian("fa"),
  polish("pl"),
  portuguese("pt"),
  punjabi("pa"),
  romanian("ro"),
  russian("ru"),
  samoan("sm"),
  scotsGaelic("gd"),
  serbian("sr"),
  sesotho("st"),
  shona("sn"),
  sindhi("sd"),
  sinhala("si"),
  slovak("sk"),
  slovenian("sl"),
  somali("so"),
  spanish("es"),
  sundanese("su"),
  swahili("sw"),
  swedish("sv"),
  tajik("tg"),
  tamil("ta"),
  telugu("te"),
  thai("th"),
  turkish("tr"),
  ukrainian("uk"),
  urdu("ur"),
  uyghur("ug"),
  uzbek("uz"),
  vietnamese("vi"),
  welsh("cy"),
  xhosa("xh"),
  yiddish("yi"),
  yoruba("yo"),
  zulu("zu");

  final String code;
  const Language(this.code);
}
