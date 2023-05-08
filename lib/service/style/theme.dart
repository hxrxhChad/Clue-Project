import 'package:clue/service/style/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

lightTheme(context) {
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: blueC,
    canvasColor: blueC,
    shadowColor: darkC,
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: blueC),
    textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
        .apply(bodyColor: darkC)
        .copyWith(
          bodyLarge: const TextStyle(
            color: darkC,
          ),
          bodyMedium: const TextStyle(
            color: darkC,
          ),
        ),
  );
}

darkTheme(context) {
  return ThemeData(
    scaffoldBackgroundColor: darkC,
    primaryColor: blueC,
    canvasColor: blueC,
    shadowColor: Colors.white,
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: blueC),
    textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
        .apply(bodyColor: Colors.white)
        .copyWith(
          bodyLarge: const TextStyle(
            color: Colors.white,
          ),
          bodyMedium: const TextStyle(
            color: Colors.white,
          ),
        ),
  );
}
