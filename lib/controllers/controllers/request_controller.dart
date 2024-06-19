import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:marketplace/core/utils/app_constants.dart';
import 'package:marketplace/models/product_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show Client;

class RequestController extends GetxController {
  final _requestCollection = FirebaseFirestore.instance.collection('requests');
  RequestModel? userModel;
  final Reference storageReference = FirebaseStorage.instance.ref();

  /// Fetches an access token for accessing Firebase Messaging services.
  ///
  /// This function uses a service account to obtain credentials via OAuth 2.0,
  /// which is then used to create an authenticated HTTP client. This client is
  /// used to retrieve the access token required to make authenticated requests
  /// to Firebase Messaging services.
  ///
  /// Returns:
  ///   A `Future<String>` that completes with the access token as a string.
  Future<String> getAccessToken() async {
    // Obtain OAuth 2.0 access credentials from a service account.
    // This requires providing JSON data for the service account credentials,
    // which should typically include the private key and other necessary details.
    final credentials = await obtainAccessCredentialsViaServiceAccount(
      ServiceAccountCredentials.fromJson(
        {
          "type": "service_account",
          "project_id": "marketplace-45dcc",
          "private_key_id": "b005d50b85ac90e83bb92bb5e364dd0cc4756054",
          "private_key":
              "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC9VvtSF46pKJ7a\nZT+RJ4zvhPj03kNJx5F7QhZ4hVi7c8v7G+dNq33cUk320dGc10eudKfNI9CGaoQ0\n3OJ0ZqBmRrD/pt6x7LI8FGy+R5UwIzKrOk+T5L6HdeRH47joJljbYShxZdG6Qc+C\nliMLLQD78IjXTA/gKg9/kyIY1jWYIqt1wouYhG3sVk+VZI+uOQ1jgGBkHRX2zbpn\nMvQorQhM1eIU68ARsUpyX9OnjgWrShaaUL9EXTHpv/wY9IetZ1SzM9E2dhmVegMW\nJVDkWyknJKgDqYiqIsF6ksl1xsHMey1JxoXRbdeiJ2oreN5ZD7z8l7U9ruVLFT1c\nfg71WLUTAgMBAAECggEABOBwqLSioAjDzqw87ugt4R1zrBrtcMELJjmVipUkq+9X\nmagmVQHNxBb6mxjcZUXGOuAWUlpRzKSBszrdOlJKX1gCxxLtOXf3P0TnaB8/4HWH\noJFn609A+Qw4TQG4iYIzV7Mw73rH5Bw91Ac579fA5rxTSfhTkFqE+6w2fJ1H1BtF\nJ9nxwtrOT6hziJwRf3Dxu13W95jZA4eQDUDqBMG7AsYwGDxOjX3tWrCQWeKnhGWB\n2efcfJ9TL+nKvT4LWqm7VyD0rEtNO2Yw8L58gRotVELpQI4FiMllioj7Ttgi9DsL\nZeX5b1vSgj7VyIhpQt12IY+Z4ZLUzeFCUO9fy6D5AQKBgQDdp0VOOgMDWnHwxLoh\nY7VKscFooOjD0LRGMCrM+UM43Ii077eKKkCYavfVp1CtM77S9KOs8nYrzwFmnu5E\nn3LPfQgSRRLiBS7orzHCwUwBhWiVQzm/5YDEkZFQmhCOM8yLKVi5ne84n6L7f5D3\nuy+epg6ZeZJhiRKAle+PAeNcMQKBgQDard4OiX2Zg4VAUovHinKYyhOK9Pn9xPNM\nqO7I50MFWkfjX/yVeseehebspMnfSK2AZlOIilkZoeAnNyz/AQ0WrGt4/YYroMKP\nCZ3Ukaqw99ckbNTGhbRwya9L/l/JYSzepa4zu8v8uYRtjdkRzCxnSFH9QZOpQuk6\nn3nDcE8IgwKBgQCjCAGGBE1rDf94pHpzTK9v/UbQ+mm6favbZFpW4ZB8Jlm3HArX\n6TQR57vavnIssz7MU3yAHOamWmAhZwzCFLWRv9lL9tpovH9ATnw/T4XkKIhAIW48\no0YPTzKfInLC5X6xbPwBqxTlhSWP7shmLpxcCK/8Wts8OmINijrl6PGeQQKBgDZm\n6sdTDRwTzCKkZoHNv5SjMRlwuICZbq2zmTQB1HqQazH1vzCwyth1F23n0RDrU76N\ntlpRkLj/vHQFFfyallb9rf77k1VnOP+8tLcdRgmgnrVBHe4FdU5Z3nJZZhsDQdZi\nAWR9Y9ILlRZsI4R59tH6++q1VbbWHo+m/PPSDNdhAoGBAKkDMZ33XpdAQRnCn09w\n3mOwwJ6lI8HYVtIXF0/yyFRFbWiwiYfzvo39gRtJYL0uXk6iD/enq992vRKJXwst\ntMP+1qtX4JPIQXrpYt+3fwR7pnSuCzDt3WMR/TlGtIPYUe10e5a7kvf8veTVsqMO\nVDI30HZ112lfIfyVadgUUAH+\n-----END PRIVATE KEY-----\n",
          "client_email": "fcm-admin@marketplace-45dcc.iam.gserviceaccount.com",
          "client_id": "104514110218510561232",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url":
              "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url":
              "https://www.googleapis.com/robot/v1/metadata/x509/fcm-admin%40marketplace-45dcc.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        },
      ),
      ['https://www.googleapis.com/auth/firebase.messaging'],
      Client(), // Create a new HTTP client to send requests.
    );

    // Create an authenticated client using the obtained credentials.
    // This client adds necessary authentication headers to each request.
    final authClient = authenticatedClient(Client(), credentials);

    // Extract the access token from the credentials.
    final token = authClient.credentials.accessToken.data;

    // Return the access token as a string.
    return token;
  }

  /// Sends a notification to a specific device identified by its FCM token.
  ///
  /// This method utilizes Firebase Cloud Messaging (FCM) to send a notification
  /// to the device associated with the provided FCM token. The notification includes
  /// a title and body text which are predefined. The function first fetches an access
  /// token, then constructs and sends a HTTP POST request with the appropriate headers
  /// and body to the FCM endpoint.
  ///
  /// The method handles any exceptions that might occur during the HTTP request process
  /// and prints debug statements for tracing request sending and responses or errors.
  ///
  /// Parameters:
  ///   token (String?) - The FCM token of the device to which the notification is to be sent.
  ///                     This parameter must not be null when called, but is marked as nullable
  ///                     to align with possible API response changes or calling contexts.
  ///
  /// Usage:
  ///   await sendNotification(token: "<FCM_device_token>");
  ///
  /// Returns:
  ///   void: This method returns no data but executes asynchronously.
  Future sendNotification({
    required String? token,
  }) async {
    // Obtain an access token for authorization
    final String accessToken = await getAccessToken();

    // Define the header for the HTTP request including authorization information
    final header = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken",
    };

    // Construct the body of the HTTP request with notification details
    final body = {
      "message": {
        "token": token,
        "notification": {
          "title": "New Requirement",
          "body": "A new requirement matching your tag has been posted",
        },
        "data": {
          "title": "New Requirement",
          "body": "A new requirement matching your tag has been posted",
        },
      }
    };

    // Attempt to send the notification via HTTP POST request
    try {
      debugPrint("Sending...");
      await http
          .post(
        Uri.parse(AppConstants().endPoint),
        headers: header,
        body: jsonEncode(body),
      )
          .then((value) {
        // Debug print to trace the response from the server
        debugPrint("Status: ${value.statusCode}");
        debugPrint("Response: ${value.body}");
      });
    } on Exception catch (e) {
      // Handle and print any exceptions that occur during the HTTP request
      debugPrint("Error: $e");
    }
  }

  /// Adds a new request to Firestore and returns to the previous screen.
  ///
  /// This function takes a potentially nullable [request] of type `RequestModel`.
  /// It handles nullability checks, writes the request to Firestore, and then returns
  /// to the previous screen using the `Get.back()` method from the GetX library.
  ///
  /// Args:
  ///   request (RequestModel?): The request details to add to Firestore.
  ///     This parameter is marked as required but nullable to accommodate certain design choices,
  ///     although typically it should be non-null when invoking this function.
  ///
  /// The function operates asynchronously and employs Firestore for data storage.
  /// It ensures the Firestore document ID is assigned to the request's ID before saving.
  ///
  /// The typical process includes:
  /// 1. Creating a new document reference in Firestore for the request.
  /// 2. Assigning the Firestore document ID to the request's ID.
  /// 3. Setting the request data in Firestore.
  /// 4. Refreshing the request stream to update any listeners with the new request data.
  ///
  /// Usage:
  /// To use this function, provide a non-null `RequestModel` instance:
  /// ```dart
  /// RequestModel myRequest = RequestModel(...);
  /// await addRequest(request: myRequest);
  /// ```
  Future addRequest({
    required RequestModel? request,
  }) async {
    // Use the same DocumentReference for both adding the request and getting the ID
    DocumentReference documentRef = _requestCollection.doc();
    if (request != null) {
      request.id = documentRef.id;

      // Set the request with additional details (converted to JSON) to Firestore
      await documentRef.set(request.toJson()).then(
        (value) async {
          // Update the requests stream with the new data
          getRequestsStream();
        },
      );
    }
  }

  /// Retrieves a stream of request data from a Firestore collection.
  ///
  /// This function listens to the real-time updates from the `_requestCollection`
  /// Firestore collection and maps each snapshot to a list of `RequestModel` objects.
  ///
  /// Returns:
  ///   A stream of lists of `RequestModel`. Each list corresponds to the current
  ///   snapshot of requests in the Firestore collection, reflecting any additions,
  ///   removals, or modifications.
  Stream<List<RequestModel>> getRequestsStream() {
    // Access the snapshots of the request collection from Firestore.
    return _requestCollection.snapshots().map((querySnapshot) {
      // Initialize an empty list of RequestModel instances.
      List<RequestModel> requests = [];

      // Iterate over each document in the current snapshot.
      for (var documentSnapshot in querySnapshot.docs) {
        // Convert the document data into a RequestModel instance.
        RequestModel request = RequestModel.fromJson(documentSnapshot.data());

        // Add the newly created request model to the list of requests.
        requests.add(request);
      }

      // Return the list of requests, which now contains all the current requests
      // represented as RequestModel instances from the snapshot.
      return requests;
    });
  }
}
