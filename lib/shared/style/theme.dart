import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData defaultTheme = ThemeData(
  primarySwatch: Colors.blue,
  appBarTheme: AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle()),
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.white,
  textTheme: const TextTheme(
    displayLarge: TextStyle(
        fontFamily: 'BalooThambi2',
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: Color(0xFF4A4A4A)),
    displayMedium: TextStyle(
        fontFamily: 'BalooThambi2',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFF4A4A4A)),
    titleLarge: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 60,
      color: Color(0xFF4A4A4A),
    ),
    titleMedium: TextStyle(
        fontWeight: FontWeight.bold, fontSize: 30, color: Color(0xFF4A4A4A)),
    titleSmall: TextStyle(
        fontWeight: FontWeight.bold, fontSize: 27, color: Color(0xFF4A4A4A)),
  ),
  fontFamily: 'Segoe UI',
);
