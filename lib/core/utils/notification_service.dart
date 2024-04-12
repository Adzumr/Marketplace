import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  NotificationServices() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = const AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  /// Initializes notifications for the application.
  ///
  /// This function requests notification permissions from the user and sets up
  /// handlers for different types of notification events, such as background
  /// and foreground notifications.
  ///
  /// Steps:
  /// 1. Requests the necessary permissions for showing notifications on the device.
  /// 2. Sets up a background message handler that will be called when a notification
  ///    is received while the app is in the background.
  /// 3. Registers an event listener that triggers when a notification is received
  ///    while the app is in the foreground, and displays it using the default sound.
  ///
  /// Usage:
  /// Call this function during your application initialization to ensure notifications
  /// are set up before the app is used.
  ///
  /// ```dart
  /// void main() {
  ///   runApp(MyApp());
  ///   initNotifications();
  /// }
  /// ```
  Future<void> initNotifications() async {
    // Request notification permissions from the user.
    await _firebaseMessaging.requestPermission();

    // Set up the handler for background notifications.
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Set up a listener for notifications that are received while the app is in the foreground.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Display the notification with a default sound.
      _showNotificationWithDefaultSound(message);
    });
  }

  /// Displays a local notification with the default sound based on a received remote message.
  ///
  /// This method sets up notification channel details specific to Android devices,
  /// including the channel ID, name, and description along with its importance and priority,
  /// to ensure it is treated as a high priority notification. Then, it triggers the local notification
  /// using the `flutterLocalNotificationsPlugin`.
  ///
  /// Args:
  ///   message (RemoteMessage): The message received from a remote source (e.g., Firebase Cloud Messaging),
  ///   which contains the notification title and body.
  ///
  /// The notification ID used is `0`, indicating that it does not need to maintain uniqueness in this context.
  /// The payload attached to the notification is set as 'Default_Sound'.
  ///
  /// Usage:
  /// You should have `flutterLocalNotificationsPlugin` initialized and configured elsewhere in your
  /// application setup code before calling this method.
  ///
  /// Example:
  /// ```dart
  /// RemoteMessage message = RemoteMessage(
  ///   notification: RemoteNotification(title: 'Hello', body: 'World'),
  /// );
  /// await _showNotificationWithDefaultSound(message);
  /// ```
  Future<void> _showNotificationWithDefaultSound(RemoteMessage message) async {
    // Define the notification details for Android with a specific channel ID, name,
    // description, and set the importance and priority to high to ensure it's handled
    // as a high-priority notification.
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
    );

    // Create a NotificationDetails object using the Android-specific details.
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    // Display the notification with a specified ID (0 in this case),
    // using the title and body provided in the message, and set the payload to 'Default_Sound'.
    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }
}

/// Handles incoming Firebase Messaging messages when the app is in the background.
///
/// This function is intended to be registered as a background message handler in
/// Firebase Messaging setup. It is triggered when a message is received while the
/// app is not in the foreground.
///
/// Args:
///   message (RemoteMessage): The message received from Firebase Messaging.
///     This object contains various details about the message such as data, notification
///     content, and message ID.
///
/// Usage:
/// To set up this function as a handler for background messages, you would typically
/// register it in your main Dart file or during the initialization of your app, like so:
/// ```dart
/// FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
/// ```
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Print the ID of the message to the console to verify reception and handling.
  debugPrint("Handling a background message: ${message.messageId}");
}
