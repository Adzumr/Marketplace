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

  final String serverKey =
      "AAAAIIP3xMA:APA91bHJnQTyojm9RW41L-mk4WJizoRg40m5l7iUlc1FVxsVQ4lbXQ-txez4nTmyQR_Z08F4AMdemcJeg7osQL2Mx1BcLWriiFQqLEnvITeXR6MyIkUe6by2yqpn0vjPNV4hT-SA9ep4";

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
