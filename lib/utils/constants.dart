import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const String appTitle = "Literaturamo";

/// A set of preconfigured library colors.
class LibColors {
  LibColors._();

  static const peach = Color.fromARGB(255, 246, 176, 146);
  static const gray = Color(0xFF727779);
  static const lightGray = Color(0xFF93A1A1);
  static const darkGray = Color(0xFF5C5E5B);
  static const hagueBlue = Color.fromARGB(255, 23, 27, 29);
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
    required Color appBarColor,
    required double appBarElevation,
    required Color appBarBorderColor,
    required Color appBarIconColor,
    required double appBarBorderWidth,
    required TextStyle titleTextStyle,
    required double bottomNavBarElevation,
    required Color bottomNavBarSelectedItemColor,
    required Color bottomNavBarUnselectedItemColor,
    required TextStyle bottomNavBarSelectedLabelStyle,
    required TextStyle bottomNavBarUnselectedLabelStyle,
    required Color scaffoldBackgroundColor,
    required Color primaryColor,
    required Color iconColor,
    required TextStyle bodyText2,
    required TextStyle subtitle1,
    required TextStyle subtitle2,
  }) {
    return ThemeData(
      appBarTheme: AppBarTheme(
        color: appBarColor,
        elevation: appBarElevation,
        iconTheme: IconThemeData(
          color: appBarIconColor,
        ),
        actionsIconTheme: IconThemeData(
          color: appBarIconColor,
        ),
        shape: Border(
          bottom: BorderSide(
            color: appBarBorderColor,
            width: appBarBorderWidth,
          ),
        ),
        titleTextStyle: titleTextStyle,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: bottomNavBarElevation,
        backgroundColor: scaffoldBackgroundColor,
        selectedItemColor: bottomNavBarSelectedItemColor,
        selectedLabelStyle: bottomNavBarSelectedLabelStyle,
        unselectedItemColor: bottomNavBarUnselectedItemColor,
        unselectedLabelStyle: bottomNavBarUnselectedLabelStyle,
      ),
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      primaryColor: primaryColor,
      iconTheme: IconThemeData(color: iconColor),
      textTheme: TextTheme(
        bodyText2: bodyText2,
        subtitle1: subtitle1,
        subtitle2: subtitle2,
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionHandleColor: appBarColor,
        selectionColor: appBarBorderColor.withAlpha(60),
      ),
    );
  }

  static final basicDark = _makeTheme(
    appBarColor: LibColors.hagueBlue,
    appBarElevation: 0,
    appBarBorderColor: LibColors.peach,
    appBarIconColor: Colors.white,
    appBarBorderWidth: 1,
    titleTextStyle: GoogleFonts.playfairDisplay(
      fontSize: 20,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    bottomNavBarElevation: 1,
    bottomNavBarSelectedItemColor: Colors.white,
    bottomNavBarUnselectedItemColor: LibColors.gray,
    bottomNavBarSelectedLabelStyle: const TextStyle(
      color: Colors.white,
      fontStyle: FontStyle.italic,
    ),
    bottomNavBarUnselectedLabelStyle: const TextStyle(
      color: LibColors.gray,
    ),
    scaffoldBackgroundColor: LibColors.hagueBlue,
    primaryColor: LibColors.peach,
    iconColor: LibColors.peach,
    bodyText2: GoogleFonts.playfairDisplay(
      color: Colors.white,
    ),
    subtitle1: GoogleFonts.playfairDisplay(color: Colors.white),
    subtitle2: GoogleFonts.playfairDisplay(color: Colors.grey),
  );

  static final basicLight = _makeTheme(
    appBarColor: Colors.white,
    appBarElevation: 0,
    appBarBorderColor: LibColors.hagueBlue,
    appBarIconColor: Colors.black,
    appBarBorderWidth: 1,
    titleTextStyle: GoogleFonts.playfairDisplay(
      fontSize: 20,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
    bottomNavBarElevation: 1,
    bottomNavBarSelectedItemColor: LibColors.hagueBlue,
    bottomNavBarUnselectedItemColor: Colors.grey,
    bottomNavBarSelectedLabelStyle: const TextStyle(
      color: Colors.black,
      fontStyle: FontStyle.italic,
    ),
    bottomNavBarUnselectedLabelStyle: const TextStyle(
      color: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.white,
    primaryColor: LibColors.hagueBlue,
    iconColor: LibColors.hagueBlue,
    bodyText2: GoogleFonts.playfairDisplay(
      color: Colors.black,
    ),
    subtitle1: GoogleFonts.playfairDisplay(
      color: Colors.black,
    ),
    subtitle2: GoogleFonts.playfairDisplay(
      color: Colors.grey,
    ),
  );

  static final solarizedDark = _makeTheme(
    appBarColor: LibColors.solarizedLightBlue,
    appBarElevation: 0,
    appBarBorderColor: LibColors.waterBlue,
    appBarIconColor: LibColors.waterBlue,
    appBarBorderWidth: 1,
    titleTextStyle: GoogleFonts.playfairDisplay(
      fontSize: 20,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    bottomNavBarElevation: 1,
    bottomNavBarSelectedItemColor: LibColors.waterBlue,
    bottomNavBarUnselectedItemColor: LibColors.lightGray,
    bottomNavBarSelectedLabelStyle: const TextStyle(
      color: Colors.white,
      fontStyle: FontStyle.italic,
    ),
    bottomNavBarUnselectedLabelStyle: const TextStyle(
      color: LibColors.lightGray,
    ),
    scaffoldBackgroundColor: LibColors.solarizedBlue,
    primaryColor: LibColors.solarizedLightBlue,
    iconColor: LibColors.waterBlue,
    bodyText2: GoogleFonts.playfairDisplay(
      color: Colors.white,
    ),
    subtitle1: GoogleFonts.playfairDisplay(
      color: Colors.white,
    ),
    subtitle2: GoogleFonts.playfairDisplay(
      color: Colors.grey,
    ),
  );

  static final slate = _makeTheme(
    appBarColor: LibColors.slate,
    appBarElevation: 1,
    appBarBorderColor: LibColors.darkGray,
    appBarIconColor: Colors.white,
    appBarBorderWidth: 1,
    titleTextStyle: GoogleFonts.playfairDisplay(
      fontSize: 20,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    bottomNavBarElevation: 1,
    bottomNavBarSelectedItemColor: Colors.white,
    bottomNavBarUnselectedItemColor: LibColors.darkGray,
    bottomNavBarSelectedLabelStyle: const TextStyle(
      color: Colors.white,
    ),
    bottomNavBarUnselectedLabelStyle: const TextStyle(
      color: LibColors.gray,
    ),
    scaffoldBackgroundColor: LibColors.indigo,
    primaryColor: LibColors.indigo,
    iconColor: Colors.white,
    bodyText2: GoogleFonts.playfairDisplay(
      color: Colors.white,
    ),
    subtitle1: GoogleFonts.playfairDisplay(
      color: Colors.white,
    ),
    subtitle2: GoogleFonts.playfairDisplay(
      color: Colors.grey,
    ),
  );
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
