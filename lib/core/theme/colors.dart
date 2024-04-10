import 'package:flutter/material.dart';

class AppColor {
  static final AppColor _singleton = AppColor._internal();

  factory AppColor() {
    return _singleton;
  }

  AppColor._internal();

  final Color primary = const Color(0xFFFF9800);
  final Color onPrimary = const Color(0xFFFFFFFF);
  final Color secondary = const Color(0xFFADBC9F);
  final Color onSecondary = const Color(0xFF000000);
  final Color error = const Color(0xFFC2185B);
  final Color onError = const Color(0xFFFFFFFF);
  final Color background = const Color(0xFFFFFFFF);
  final Color blackColor = const Color(0xFF000000);
  final Color onSurface = const Color(0xFF000000);
  final Color tertiary = const Color(0XFFADBC9F);
  final Color onTertiary = const Color(0xFFFFFFFF);

  final Color darkPrimary = const Color(0xFFFF9800);
  final Color darkOnPrimary = const Color(0xFFFFFFFF);
  final Color darkSecondary = const Color(0xFFADBC9F);
  final Color darkOnSecondary = const Color(0xFF000000);
  final Color darkError = const Color(0xFFC2185B);
  final Color darkOnError = const Color(0xFFFFFFFF);
  final Color darkBackground = const Color(0xFF121212);
  final Color whiteColor = const Color(0xFFFFFFFF);
  final Color darkOnSurface = const Color(0xFFFFFFFF);
  final Color darkTertiary = const Color(0XFFADBC9F);
  final Color darkOnTertiary = const Color(0xFFFFFFFF);
}
