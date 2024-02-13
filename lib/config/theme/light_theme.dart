import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent),
    fontFamily: 'Rubik',
    colorScheme: const ColorScheme.light(
        background: Color(0xFFF0F2F6),
        primary: Color(0xFF8C2EEE),
        secondary: Color(0xFFC7C7C7),
        onBackground: Color(0xFFEEE6F5),
        secondaryContainer: Colors.black54,
    ),
    textTheme: const TextTheme(
        displayLarge: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w500,
        ),
        displayMedium: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
        ),
        displaySmall: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
        ),
        headlineMedium: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
        ),
        headlineSmall: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
        ),
        titleLarge: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w400,
        ),
        bodyLarge: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w400,
        ),
        labelSmall: TextStyle(
            color: Color(0xFFC7C7C7),
            fontSize: 8,
            fontWeight: FontWeight.normal
        ),
        bodySmall: TextStyle(
            color: Colors.white,
            fontSize: 6,
            fontWeight: FontWeight.bold
        ),

    )
);