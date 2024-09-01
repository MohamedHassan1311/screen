import 'package:flutter/material.dart';
import '../core/utils/app_strings.dart';
import '../core/utils/color_resources.dart';
import '../core/utils/dimensions.dart';
import '../core/utils/text_styles.dart';

ThemeData light = ThemeData(
  fontFamily: AppStrings.fontFamily,
  useMaterial3: true,
  primaryColor: ColorResources.PRIMARY_COLOR,
  brightness: Brightness.light,

  // accentColor: Colors.white,
  colorScheme: const ColorScheme.light(
      primary: ColorResources.PRIMARY_COLOR,
      secondary: ColorResources.PRIMARY_COLOR),

  scaffoldBackgroundColor: ColorResources.BACKGROUND_COLOR,
  focusColor: const Color(0xFFADC4C8),
  hintColor: ColorResources.HINT_COLOR,
  disabledColor: ColorResources.DISABLED,
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
    foregroundColor: ColorResources.PRIMARY_COLOR, textStyle: AppTextStyles.w400.copyWith(
      color: ColorResources.WHITE_COLOR,
    ),
  )),

  pageTransitionsTheme: const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
    },
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    titleTextStyle: TextStyle(
        color: ColorResources.PRIMARY_COLOR,
        fontSize: 25,
        fontFamily: AppStrings.fontFamily),
  ),
  textTheme: const TextTheme(
    labelLarge: TextStyle(color: ColorResources.PRIMARY_COLOR),
    displayLarge: TextStyle(
      fontWeight: FontWeight.w300,
      fontSize: Dimensions.FONT_SIZE_DEFAULT,
      fontFamily: AppStrings.fontFamily,
    ),
    displayMedium: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: Dimensions.FONT_SIZE_DEFAULT,
      fontFamily: AppStrings.fontFamily,
    ),
    displaySmall: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: Dimensions.FONT_SIZE_DEFAULT,
      fontFamily: AppStrings.fontFamily,
    ),
    headlineMedium: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: Dimensions.FONT_SIZE_DEFAULT,
      fontFamily: AppStrings.fontFamily,
    ),
    headlineSmall: TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: Dimensions.FONT_SIZE_DEFAULT,
      fontFamily: AppStrings.fontFamily,
    ),
    titleLarge: TextStyle(
      fontWeight: FontWeight.w800,
      fontSize: Dimensions.FONT_SIZE_DEFAULT,
      fontFamily: AppStrings.fontFamily,
    ),
    bodySmall: TextStyle(
      fontWeight: FontWeight.w900,
      fontSize: Dimensions.FONT_SIZE_DEFAULT,
      fontFamily: AppStrings.fontFamily,
    ),
    titleMedium: TextStyle(
      fontSize: 15.0,
      fontWeight: FontWeight.w500,
      fontFamily: AppStrings.fontFamily,
    ),
    bodyMedium: TextStyle(fontSize: 12.0),
    bodyLarge: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      fontFamily: AppStrings.fontFamily,
    ),
  ),
);
