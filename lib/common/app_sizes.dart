import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSizes {
  // Padding and margin sizes
  static double xs = 4.h;
  static double sm = 8.h;
  static double md = 16.h;
  static double lg = 24.h;
  static double xl = 32.h;
  static double sl = 48.h;

  // Icon sizes
  static double iconXs = 16.sp;
  static double iconSm = 20.sp;
  static double iconMd = 24.sp;
  static double iconLg = 32.sp;
  static double iconXl = 48.sp;

  // Font sizes
  static double fontSizeSm = 14.sp;
  static double fontSizeMd = 16.sp;
  static double fontSizeLg = 18.sp;

  // Button sizes
  static double buttonHeight = 50.h;
  static double buttonRadius = 12.r;
  static double buttonWidth = 120.w;
  static double buttonElevation = 4.w;

  // AppBar height
  static double appBarHeight = 56.h;

  // Image sizes
  static double imageThumbSize = 80.w;

  // Default spacing between sections
  static double defaultSpace = 24.h;
  static double smallSpace = 12.h;
  static double spaceBtwItems = 16.h;
  static double spaceBtwSections = 32.h;

  // Border radius
  static double borderRadiusSm = 4.r;
  static double borderRadiusMd = 8.r;
  static double borderRadiusLg = 12.r;
  static double borderRadiusXl = 48.r;

  // Divider height
  static double dividerHeight = 1.h;

  // Product item dimensions
  static double productImageSize = 120.w;
  static double productImageRadius = 16.r;
  static double productItemHeight = 160.h;

  // Input field
  static double inputFieldRadius = 12.r;
  static double spaceBtwInputFields = 16.h;
  static double fieldHeight = 85.h;

  // Card sizes
  static double cardRadiusLg = 16.r;
  static double cardRadiusMd = 12.r;
  static double cardRadiusSm = 10.r;
  static double cardRadiusXs = 6.r;
  static double cardElevation = 2.w;

  // Image carousel height
  static double imageCarouselHeight = 200.h;

  // Loading indicator size
  static double loadingIndicatorSize = 36.w;

  // Grid view spacing
  static double gridViewSpacing = 16.w;

  static TextTheme scaledTextTheme(TextTheme base) {
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        fontSize: base.displayLarge?.fontSize?.sp,
      ),
      displayMedium: base.displayMedium?.copyWith(
        fontSize: base.displayMedium?.fontSize?.sp,
      ),
      displaySmall: base.displaySmall?.copyWith(
        fontSize: base.displaySmall?.fontSize?.sp,
      ),
      headlineLarge: base.headlineLarge?.copyWith(
        fontSize: base.headlineLarge?.fontSize?.sp,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontSize: base.headlineMedium?.fontSize?.sp,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontSize: base.headlineSmall?.fontSize?.sp,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontSize: base.titleLarge?.fontSize?.sp,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontSize: base.titleMedium?.fontSize?.sp,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontSize: base.titleSmall?.fontSize?.sp,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: base.bodyLarge?.fontSize?.sp,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: base.bodyMedium?.fontSize?.sp,
      ),
      bodySmall: base.bodySmall?.copyWith(
        fontSize: base.bodySmall?.fontSize?.sp,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontSize: base.labelLarge?.fontSize?.sp,
      ),
      labelMedium: base.labelMedium?.copyWith(
        fontSize: base.labelMedium?.fontSize?.sp,
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontSize: base.labelSmall?.fontSize?.sp,
      ),
    );
  }
}
