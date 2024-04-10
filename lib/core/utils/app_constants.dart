import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

/// create a class for app constants  usinhg signleton pattern
///
class AppConstants {
  static final AppConstants instance = AppConstants._internal();

  factory AppConstants() {
    return instance;
  }

  AppConstants._internal();

  final String appName = "Marketplace";
  final String phoneNumber = "+2348130762880";
  final String emailAddress = "adzumrjada@gmail.com";

  void throwError(String? errorMessage) {
    debugPrint("Error: $errorMessage");
    Fluttertoast.showToast(
      msg: "$errorMessage",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
    );
    throw errorMessage!;
  }

  /// Contact Support Function
  ///
  /// This Flutter function enables users to easily contact our support team via email. It is designed to improve user engagement
  /// and encourage inquiries about our services. By setting a meaningful subject and message body, we aim to provide a better
  /// user experience.
  ///
  /// To use this function, simply call `sendEmail()`. It will open the user's default email client with a pre-filled email
  /// to our support team.
  Future sendEmail() async {
    // Define the email parameters
    final Uri emailParams = Uri(
      scheme: 'mailto',
      path: AppConstants().emailAddress,
      query:
          'subject=Inquiry%20About%20Support&body=How%20may%20we%20help%20you%3F', // Subject and message
    );

    // Generate the email URL
    final String emailUrl = emailParams.toString();

    // Check if the email client is available
    if (await canLaunchUrl(Uri.parse(emailUrl))) {
      // If available, launch the email client
      await launchUrl(
        Uri.parse(emailUrl),
      );
    } else {
      // If not available, throw an error
      throw 'Could not launch $emailUrl. Please check your email configuration.';
    }
  }

  /// Send SMS Function
  ///
  /// This Flutter function allows users to send an SMS to our support team for quick assistance. It simplifies the process
  /// of reaching out for help using a predefined phone number. By using this function, we aim to enhance user engagement
  /// and improve the support experience.
  ///
  /// To use this function, simply call `sendSMS()`. It will open the user's default SMS app with a pre-filled message to
  /// our support team.
  Future sendSMS() async {
    // Define the phone number

    // Create the SMS URL
    String smsUrl = 'sms:${AppConstants().phoneNumber}';

    // Check if the SMS app can be launched
    try {
      if (await canLaunchUrl(Uri.parse(smsUrl))) {
        // If possible, launch the SMS app
        await launchUrl(Uri.parse(smsUrl));
      }
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  /// Make Phone Call Function
  ///
  /// This Flutter function allows users to make a phone call to our support team for immediate assistance. It simplifies
  /// the process of reaching out for help using a predefined phone number. By providing this function, we aim to enhance
  /// user engagement and provide a convenient way for users to access support.
  ///
  /// To use this function, simply call `makeCall()`. It will initiate a phone call to our support team.
  Future makeCall({
    required String? telephoneNumber,
  }) async {
    // Create the phone call URL
    String callUrl = 'tel:${AppConstants().phoneNumber}';

    // Check if the phone call can be initiated
    try {
      if (await canLaunchUrl(
        Uri.parse(
          callUrl,
        ),
      )) {
        // If possible, initiate the phone call
        await launchUrl(
          Uri.parse(
            callUrl,
          ),
        );
      }
    } on Exception catch (e) {
      throw Exception(e);
    }
  }
}
