import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppConstants {
  static final AppConstants instance = AppConstants._internal();

  factory AppConstants() {
    return instance;
  }

  AppConstants._internal();

  final String appName = "Marketplace";
  final String endPoint =
      "https://fcm.googleapis.com/v1/projects/marketplace-45dcc/messages:send";

  void throwError(String? errorMessage) {
    debugPrint("Error: $errorMessage");
    Fluttertoast.showToast(
      msg: "$errorMessage",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
    );
    throw errorMessage!;
  }
}
