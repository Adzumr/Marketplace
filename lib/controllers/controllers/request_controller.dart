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
  Future<String> getAccessToken() async {
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
      Client(),
    );

    final authClient = authenticatedClient(Client(), credentials);
    final token = authClient.credentials.accessToken.data;
    return token;
  }

  Future sendNotification({
    required String? token,
  }) async {
    final String accessToken = await getAccessToken();
    final header = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken",
    };

    final body = {
      "message": {
        "token": token,
        "notification": {
          "title": "New Matching Requirement",
          "body": "A new requirement matching your tags has been posted",
        },
        "data": {
          "title": "New Matching Requirement",
          "body": "A new requirement matching your tags has been posted",
        },
      }
    };
    try {
      debugPrint("Sending...");
      await http
          .post(
        Uri.parse(AppConstants().endPoint),
        headers: header,
        body: jsonEncode(body),
      )
          .then((value) {
        debugPrint("Response: ${value.body}");
      });
    } on Exception catch (e) {
      debugPrint("Error: $e");
    }
  }

  Future addRequest({
    required RequestModel? request,
    required String? token,
  }) async {
    // Use the same DocumentReference for both adding the stylist and getting the ID
    DocumentReference documentRef = _requestCollection.doc();
    request!.id = documentRef.id;

    // Set stylist with image URL to Firestore
    await documentRef.set({
      ...request.toJson(),
    }).then(
      (value) async {
        await sendNotification(token: token);
        getRequestsStream();
      },
    );
    Get.back();
  }

  Stream<List<RequestModel>> getRequestsStream() {
    return _requestCollection.snapshots().map((querySnapshot) {
      List<RequestModel> requests = [];
      for (var documentSnapshot in querySnapshot.docs) {
        RequestModel request = RequestModel.fromJson(documentSnapshot.data());
        requests.add(request);
      }
      return requests;
    });
  }

  void exceptionError({
    FirebaseException? exception,
  }) {
    Get.snackbar(
      "Error",
      exception!.code,
    );
    throw Exception(exception.message);
  }
}
