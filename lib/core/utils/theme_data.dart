import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_system/core/utils/app_colors.dart';

import 'app_styles.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.whiteColor,
    fontFamily: GoogleFonts.poppins().fontFamily,
    textTheme: TextTheme(
      titleLarge: AppStyles.primaryTextStyle.copyWith(
        fontSize: 30,
      ),
      titleMedium: AppStyles.primaryTextStyle,
      bodyMedium: AppStyles.suptitleTextStyle,
    ),
  );
}
