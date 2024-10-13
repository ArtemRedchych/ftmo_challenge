import 'package:flutter/material.dart';
import 'package:ftmo/src/themes/app_colors.dart';

// Default text theme
const kDefaultTheme = TextTheme(
  headlineLarge: TextStyle(
    fontSize: 30,
    decoration: TextDecoration.none,
  ),
  headlineSmall: TextStyle(
    fontSize: 24,
    decoration: TextDecoration.none,
  ),
  bodyMedium: TextStyle(
    fontSize: 16,
    decoration: TextDecoration.none,
  ),
);

OutlineInputBorder borderFromColor(Color color) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color, width: 1),
    );

// Light theme colors
const appDarkColors = AppColors(
  contentPrimary: Color(0xFFFFFFFF),
  contentSecondary: Color(0xFFE9E9E9),
  contentTertiatry: Color(0xFFC1C7D3),
  functionalSuccess: Color(0xFF03C7B4),
  functionalDanger: Color(0xFFFF3648),
  background: Color(0xFF1E1E1E),
  primaryActive: Color(0xFF0781FE),
  primaryActiveHover: Color(0xFF399AFE),
  primaryActivePressed: Color(0xFF015FC0),
  primaryBase: Color(0xFF36373B),
  primaryHover: Color(0xFF686868),
  primaryPressed: Color(0xFF1E1E1E),
  primaryDisabled: Color(0xFF36373B),
  dataCellBackground: Color(0xFF252527),
);

// Dark theme definition
final darkTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'Inter',
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: appDarkColors.background,
    surface: appDarkColors.background,
    onSurface: appDarkColors.contentPrimary,
    secondary: appDarkColors.primaryBase,
    onSecondary: appDarkColors.contentSecondary,
    error: appDarkColors.functionalDanger,
    onError: appDarkColors.functionalDanger,
    primaryContainer: appDarkColors.primaryActive,
    primary: appDarkColors.primaryActive,
    onPrimary: appDarkColors.contentPrimary,
  ),
  extensions: const <ThemeExtension<dynamic>>[appDarkColors],
  textTheme: kDefaultTheme.copyWith(
    headlineLarge: kDefaultTheme.headlineLarge!
        .copyWith(color: appDarkColors.contentPrimary),
    headlineSmall: kDefaultTheme.headlineSmall!
        .copyWith(color: appDarkColors.contentPrimary),
    bodyMedium:
        kDefaultTheme.bodyMedium!.copyWith(color: appDarkColors.contentPrimary),
  ),
  iconTheme: IconThemeData(color: appDarkColors.contentPrimary),
  focusColor: Colors.white,
  disabledColor: appDarkColors.contentSecondary,
);
