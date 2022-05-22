import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const String appTitle = "Literaturamo";

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
    required Color bottomNavBarColor,
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
        backgroundColor: bottomNavBarColor,
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
      ),
    );
  }

  static var basicDark = _makeTheme(
    appBarColor: LibColors.hagueBlue,
    appBarElevation: 0,
    appBarBorderColor: LibColors.peach,
    appBarIconColor: Colors.white,
    appBarBorderWidth: 1,
    titleTextStyle: GoogleFonts.playfairDisplay(
      fontSize: 20,
      color: Colors.white,
    ),
    bottomNavBarElevation: 1,
    bottomNavBarColor: LibColors.hagueBlue.withAlpha(139),
    bottomNavBarSelectedItemColor: LibColors.peach,
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
    subtitle1: GoogleFonts.playfairDisplay(
      color: Colors.white,
    ),
    subtitle2: GoogleFonts.playfairDisplay(
      color: Colors.grey,
    ),
  );

  static var basicLight = _makeTheme(
    appBarColor: Colors.white,
    appBarElevation: 0,
    appBarBorderColor: LibColors.hagueBlue,
    appBarIconColor: Colors.black,
    appBarBorderWidth: 1,
    titleTextStyle: GoogleFonts.playfairDisplay(
      fontSize: 20,
      color: Colors.black,
    ),
    bottomNavBarElevation: 1,
    bottomNavBarColor: Colors.white.withAlpha(139),
    bottomNavBarSelectedItemColor: LibColors.hagueBlue,
    bottomNavBarUnselectedItemColor: Colors.white,
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

  static var test = ThemeData(
    appBarTheme: AppBarTheme(
      color: LibColors.hagueBlue,
      elevation: 1,
      shape: const Border(
        bottom: BorderSide(
          color: LibColors.peach,
          width: 1,
        ),
      ),
      titleTextStyle: GoogleFonts.playfairDisplay(
        fontSize: 20,
        color: Colors.black,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 1,
      backgroundColor: LibColors.hagueBlue,
      selectedItemColor: LibColors.peach,
      selectedLabelStyle: TextStyle(
        color: Colors.black,
        fontStyle: FontStyle.italic,
      ),
      unselectedItemColor: LibColors.gray,
      unselectedLabelStyle: TextStyle(
        color: LibColors.gray,
      ),
    ),
    scaffoldBackgroundColor: LibColors.hagueBlue,
    primaryColor: LibColors.hagueBlue,
    iconTheme: const IconThemeData(color: LibColors.peach),
    textTheme: TextTheme(
      bodyText2: GoogleFonts.playfairDisplay(
        color: Colors.black,
      ),
      subtitle1: GoogleFonts.playfairDisplay(
        color: Colors.black,
      ),
      subtitle2: GoogleFonts.playfairDisplay(
        color: Colors.grey,
      ),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      selectionHandleColor: LibColors.hagueBlue,
    ),
  );

  static var solarizedDark = _makeTheme(
    appBarColor: LibColors.solarizedLightBlue,
    appBarElevation: 0,
    appBarBorderColor: LibColors.waterBlue,
    appBarIconColor: LibColors.waterBlue,
    appBarBorderWidth: 1,
    titleTextStyle: GoogleFonts.playfairDisplay(
      fontSize: 20,
      color: Colors.white,
    ),
    bottomNavBarElevation: 1,
    bottomNavBarColor: LibColors.solarizedLightBlue,
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

  static var slate = _makeTheme(
    appBarColor: LibColors.slate,
    appBarElevation: 1,
    appBarBorderColor: LibColors.darkGray,
    appBarIconColor: Colors.white,
    appBarBorderWidth: 1,
    titleTextStyle: GoogleFonts.playfairDisplay(
      fontSize: 20,
      color: Colors.white,
    ),
    bottomNavBarElevation: 1,
    bottomNavBarColor: LibColors.slate,
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
