import 'package:flutter/material.dart';
import 'package:uiam_personal/core/theme/variant_theme.dart';

import '../values/colors.dart';

final darkAppTheme = ThemeData(
    colorScheme: ColorScheme.dark(
      primary: VariantTheme.primary.color,
      onPrimary: Colors.white,
      secondary: VariantTheme.secondary.color,
      onSecondary: Colors.white,
      surface: darkBackgroundColor,
      onSurface: darkTextColor,
      background: darkBackgroundColor,
      onBackground: darkTextColor,
      error: VariantTheme.danger.color,
      onError: Colors.white,
      brightness: Brightness.dark,
    ),
    primaryColor: VariantTheme.primary.color,
    backgroundColor: darkBackgroundColor,
    scaffoldBackgroundColor: darkBackgroundColor,
    shadowColor: shadowColor);
