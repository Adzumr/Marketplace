import 'package:flutter/material.dart';
import '../../core/utils/app_assets.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    this.height = 32,
    super.key,
  });
  final double? height;
  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage(
        AppAssets().logo,
      ),
      height: height,
    );
  }
}
