import 'package:flutter/material.dart';
import 'package:uiam_personal/core/theme/variant_theme.dart';

import '../values/colors.dart';

final lightAppTheme = ThemeData(
    colorScheme: ColorScheme.light(
      primary: VariantTheme.primary.color,
      onPrimary: Colors.white,
      secondary: VariantTheme.secondary.color,
      onSecondary: Colors.white,
      surface: lightBackgroundColor,
      onSurface: lightTextColor,
      background: lightBackgroundColor,
      onBackground: lightTextColor,
      error: VariantTheme.danger.color,
      onError: Colors.white,
      brightness: Brightness.light,
    ),
    primaryColor: VariantTheme.primary.color,
    backgroundColor: lightBackgroundColor,
    scaffoldBackgroundColor: lightBackgroundColor,
    shadowColor: shadowColor);
