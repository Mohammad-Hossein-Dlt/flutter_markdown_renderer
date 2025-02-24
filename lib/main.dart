import 'package:ai_app/constants/colors.dart';
import 'package:ai_app/screens/markdown_renderer.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const Root());
}

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const ArrayContent(),
    );
  }
}

ThemeData appTheme = ThemeData(
  primaryColor: black,
  fontFamily: "Shabnam",

  hintColor: grey,
  scaffoldBackgroundColor: white,
  iconTheme: const IconThemeData(color: black),
  dividerColor: lightGrey,
  dividerTheme: const DividerThemeData(color: lightGrey),

  appBarTheme: const AppBarTheme(
    backgroundColor: white,
    surfaceTintColor: Colors.transparent,
    shadowColor: white,
    elevation: 4,
  ),

  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: black),
    bodyMedium: TextStyle(color: black),
    bodySmall: TextStyle(color: black),
    displayLarge: TextStyle(color: black),
    displayMedium: TextStyle(color: black),
    displaySmall: TextStyle(color: black),
    headlineLarge: TextStyle(color: black),
    headlineMedium: TextStyle(color: black),
    headlineSmall: TextStyle(color: black),
    labelLarge: TextStyle(color: black),
    labelMedium: TextStyle(color: black),
    labelSmall: TextStyle(color: black),
    titleLarge: TextStyle(color: black),
    titleMedium: TextStyle(color: black),
    titleSmall: TextStyle(color: black),
  ),
  colorScheme: const ColorScheme.dark(
    shadow: lightGrey,
    primary: white,
    primaryContainer: lightGrey,
  ),
  // -------------------------------------------------------
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: white,
      backgroundColor: black,
      surfaceTintColor: Colors.transparent,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      surfaceTintColor: Colors.transparent,
    ),
  ),
  cardTheme: const CardTheme(
    color: black,
    surfaceTintColor: Colors.transparent,
    shadowColor: black,
  ),
  iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
    foregroundColor: grey,
  )),
);
