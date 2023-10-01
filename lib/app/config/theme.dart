import 'package:flutter/material.dart';
import 'config.dart';

class ThemeConfig {
  static ThemeData lightTheme = ThemeData(
    fontFamily: 'Lato',
    iconTheme:  IconThemeData(
        color: ColorResources.primary700
    ),
    brightness: Brightness.light,
    primaryColor: ColorResources.primary700,
    buttonTheme: ButtonThemeData(
        buttonColor: ColorResources.primary500,
        textTheme: ButtonTextTheme.primary
    ), colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: ColorResources.primary700,
    secondary: ColorResources.background,
    surface: ColorResources.background,
    background: ColorResources.background,
    error: ColorResources.textError,
    onPrimary: ColorResources.text500,
    onSecondary: ColorResources.text50,
    onSurface: ColorResources.background,
    onBackground: ColorResources.background,
    onError: ColorResources.textError,
  ),
  );
}
