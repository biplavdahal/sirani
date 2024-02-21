import 'package:flutter/material.dart';
import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColor {
  static const Color scaffold = Color(0xFFEFF4F6);
  static const Color primary = Color(0xFF287A8E);
  static const Color accent = Color(0xFFF4B100);
  static const Color primaryTextColor = Color(0xFF333333);
  static const Color secondaryTextColor = Color(0xFF666666);
  static const Color appTitleTextColor = Color(0xFFFFFFFF);
  static const Color appTitleIconColor = Color(0xFFFFFFFF);
  static const Color primaryButtonTextColor = Color(0xFFFFFFFF);
}

getThemeDataTheme(BuildContext context) {
  return ThemeData(
    scaffoldBackgroundColor: AppColor.scaffold,
    primaryColor: AppColor.primary,
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.poppins(
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColor.appTitleTextColor,
        ),
      ),
      iconTheme: IconThemeData(
        color: AppColor.appTitleIconColor,
        size: 16.sp,
      ),
      backgroundColor: AppColor.primary,
      actionsIconTheme: IconThemeData(
        color: AppColor.appTitleIconColor,
        size: 16.sp,
      ),
    ),
    textTheme: GoogleFonts.poppinsTextTheme(
      Theme.of(context).textTheme,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        primary: AppColor.primary,
        onSurface: AppColor.primary,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(
        color: AppColor.primary,
      ),
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      hintStyle: TextStyle(
        color: Colors.black45,
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColor.primary),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColor.primary),
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black45),
      ),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: AppColor.accent),
  );
}
