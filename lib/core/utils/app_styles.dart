import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_system/core/utils/app_colors.dart';

class AppStyles {
  static TextStyle primaryTextStyle = GoogleFonts.poppins(
    fontSize: 18,
    color: AppColors.primaryColor,
    fontWeight: FontWeight.w600,
  );
  static TextStyle suptitleTextStyle = GoogleFonts.poppins(
    fontSize: 16,
    color: AppColors.greyColor,
    fontWeight: FontWeight.w500,
  );
}
