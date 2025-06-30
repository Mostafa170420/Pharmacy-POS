import 'package:flutter/material.dart';

class ResponsiveHelper {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 900;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 900 && width < 1350;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1350;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static EdgeInsets getScreenPadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(16);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(24);
    } else {
      return const EdgeInsets.all(32);
    }
  }

  static int getProductGridColumns(BuildContext context) {
    if (isMobile(context)) {
      if (getScreenWidth(context) < 500) {
        return 1;
      } else {
        return 2;
      }
    } else if (isTablet(context)) {
      return 2;
    } else {
      return 3;
    }
  }

  static double getSidebarWidth(BuildContext context) {
    if (isMobile(context)) {
      return 60;
    } else {
      return 80;
    }
  }

  static double getCartSidebarWidth(BuildContext context) {
    if (isMobile(context)) {
      return MediaQuery.of(context).size.width * 0.9;
    } else if (isTablet(context)) {
      return 350;
    } else {
      return 400;
    }
  }

  static double getTextSize(BuildContext context,
      {required double mobileSize,
      required double tabletSize,
      required double desktopSize}) {
    if (isMobile(context)) {
      return mobileSize;
    } else if (isTablet(context)) {
      return tabletSize;
    } else {
      return desktopSize;
    }
  }
}
