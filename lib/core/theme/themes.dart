import 'package:flutter/material.dart';

import 'colors.dart';
import 'fonts.dart';
import 'schemes.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: AppColorScheme().lightColorScheme,
      dividerTheme: DividerThemeData(
        color: AppColor().secondary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColor().primary,
        iconTheme: IconThemeData(
          color: AppColor().onPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: AppColor().onPrimary,
          backgroundColor: AppColor().primary,
          textStyle: AppFont().labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(48),
          ),
          padding: const EdgeInsets.all(16),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColor().primary,
          textStyle: AppFont().labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(48),
          ),
          padding: const EdgeInsets.all(16),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: AppColor().onPrimary,
          backgroundColor: AppColor().primary,
          textStyle: AppFont().labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(48),
          ),
          padding: const EdgeInsets.all(16),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: AppColor().primary,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColor().primary,
          textStyle: AppFont().labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(48),
            side: BorderSide(
              color: AppColor().primary,
            ),
          ),
          padding: const EdgeInsets.all(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        prefixIconColor: AppColor().primary,
        contentPadding: const EdgeInsets.all(10),
        labelStyle: AppFont().labelMedium.copyWith(
              color: AppColor().primary,
            ),
        hintStyle: AppFont().labelMedium.copyWith(
              color: AppColor().primary,
            ),
        focusedBorder: enabledInputBorder,
        enabledBorder: outlinedInputBorder,
        border: outlinedInputBorder,
        disabledBorder: outlinedInputBorder,
      ),
      textTheme: TextTheme(
        headlineLarge: AppFont().headlineLarge,
        headlineMedium: AppFont().headlineMedium,
        headlineSmall: AppFont().headlineSmall,
        titleLarge: AppFont().titleLarge,
        titleMedium: AppFont().titleMedium,
        titleSmall: AppFont().titleSmall,
        bodyLarge: AppFont().bodyLarge,
        bodyMedium: AppFont().bodyMedium,
        bodySmall: AppFont().bodySmall,
        labelSmall: AppFont().labelSmall,
        labelMedium: AppFont().labelMedium,
        labelLarge: AppFont().labelLarge,
      ),
      useMaterial3: true,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: AppColorScheme().darkColorScheme,
      dividerTheme: DividerThemeData(
        color: AppColor().secondary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColor().darkBackground,
        iconTheme: IconThemeData(
          color: AppColor().whiteColor,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: AppColor().darkOnPrimary,
          backgroundColor: AppColor().darkPrimary,
          textStyle: AppFont().labelLarge.copyWith(
                color: AppColor().darkOnPrimary,
              ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(48),
          ),
          padding: const EdgeInsets.all(16),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: AppColor().darkOnPrimary,
          backgroundColor: AppColor().darkPrimary,
          textStyle: AppFont().labelLarge.copyWith(
                color: AppColor().darkOnPrimary,
              ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(48),
          ),
          padding: const EdgeInsets.all(16),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: AppColor().onPrimary,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColor().onPrimary,
          textStyle: AppFont().labelLarge.copyWith(
                color: AppColor().darkPrimary,
              ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(48),
          ),
          padding: const EdgeInsets.all(16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColor().onPrimary,
          textStyle: AppFont().labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(48),
            side: BorderSide(
              color: AppColor().primary,
            ),
          ),
          padding: const EdgeInsets.all(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        prefixIconColor: AppColor().primary,
        labelStyle: AppFont().labelMedium.copyWith(
              color: AppColor().whiteColor,
            ),
        hintStyle: AppFont().labelMedium.copyWith(
              color: AppColor().whiteColor,
            ),
        contentPadding: const EdgeInsets.all(10),
        focusedBorder: enabledInputBorder,
        enabledBorder: outlinedInputBorder,
        border: outlinedInputBorder,
        disabledBorder: outlinedInputBorder,
      ),
      textTheme: TextTheme(
        headlineLarge: AppFont().headlineLarge.copyWith(
              color: AppColor().whiteColor,
            ),
        headlineMedium: AppFont().headlineMedium.copyWith(
              color: AppColor().whiteColor,
            ),
        headlineSmall: AppFont().headlineSmall.copyWith(
              color: AppColor().whiteColor,
            ),
        titleLarge: AppFont().titleLarge.copyWith(
              color: AppColor().whiteColor,
            ),
        titleMedium: AppFont().titleMedium.copyWith(
              color: AppColor().whiteColor,
            ),
        titleSmall: AppFont().titleSmall.copyWith(
              color: AppColor().whiteColor,
            ),
        bodyLarge: AppFont().bodyLarge.copyWith(
              color: AppColor().whiteColor,
            ),
        bodyMedium: AppFont().bodyMedium.copyWith(
              color: AppColor().whiteColor,
            ),
        bodySmall: AppFont().bodySmall.copyWith(
              color: AppColor().whiteColor,
            ),
        labelLarge: AppFont().labelLarge.copyWith(
              color: AppColor().whiteColor,
            ),
        labelMedium: AppFont().labelMedium.copyWith(
              color: AppColor().whiteColor,
            ),
        labelSmall: AppFont().labelSmall.copyWith(
              color: AppColor().whiteColor,
            ),
      ),
      useMaterial3: true,
    );
  }
}

final outlinedInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(15),
  gapPadding: 10,
  borderSide: const BorderSide(
    color: Colors.grey,
    width: 1,
  ),
);
final enabledInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(15),
  gapPadding: 10,
  borderSide: BorderSide(
    color: AppColor().primary,
    width: 1,
  ),
);
