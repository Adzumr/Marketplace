import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/routing/route_names.dart';
import '../../core/utils/app_constants.dart';
import '../../main.dart';
import '../../models/user_model.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Reference storageReference = FirebaseStorage.instance.ref();
  final _usersCollection = FirebaseFirestore.instance.collection('users');

  UserModel? userModel;
  Future<UserModel?> registerUser({
    required String? emailAddress,
    required String? password,
    required String? fullName,
    required String? tag,
    required String? role,
  }) async {
    try {
      // Step 0: Get device token
      final token = await FirebaseMessaging.instance.getToken();

      // Step 1: Create user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailAddress!,
        password: password!,
      );

      // Step 2: Store additional user data in Firestore
      await _usersCollection.doc(userCredential.user!.uid).set(
        {
          'id': userCredential.user!.uid,
          'role': role,
          'name': fullName,
          'email': emailAddress,
          'tag': tag,
          'token': token,
          "picture": "",
        },
      );

      // Step 3: Retrieve user data from Firestore
      DocumentSnapshot userSnapshot =
          await _usersCollection.doc(userCredential.user!.uid).get();
      Map<String, dynamic>? userData =
          userSnapshot.data() as Map<String, dynamic>?;

      // Step 4: Create a User model and return it
      if (userData != null) {
        userModel = UserModel.fromJson(userData);
        debugPrint("Phone: ${userModel!.phone}");
        debugPrint("Token: ${userModel!.token}");
        await sharedPreferences!.setBool("skipIntro", true);
        Get.toNamed(AppRouteNames.main);
      }
    } on FirebaseAuthException catch (exception) {
      exceptionError(
        exception: exception,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "$e",
      );
      throw Exception(e);
    }
    return userModel;
  }

  Future<UserModel?> loginUser({
    required String? email,
    required String? password,
  }) async {
    try {
      // Step 0: Get device token
      final token = await FirebaseMessaging.instance.getToken();

      // Step 1: Sign in user with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );

      // Step 2: Update device token in Firestore
      await _usersCollection.doc(userCredential.user!.uid).update({
        'token': token,
      });

      // Step 3: Retrieve user data from Firestore
      DocumentSnapshot userSnapshot =
          await _usersCollection.doc(userCredential.user!.uid).get();
      Map<String, dynamic>? userData =
          userSnapshot.data() as Map<String, dynamic>?;

      // Step 4: Create a User model and return it
      if (userData != null) {
        userModel = UserModel.fromJson(userData);
        debugPrint("Phone: ${userModel!.phone}");
        debugPrint("Token: ${userModel!.token}");
        await sharedPreferences!.setBool("skipIntro", true);
        Get.toNamed(AppRouteNames.main);
      } else {
        AppConstants().throwError(
          "User not found",
        );
      }
    } on FirebaseException catch (exception) {
      exceptionError(
        exception: exception,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "$e",
      );
      throw Exception(e);
    }
    return userModel;
  }

  Future<UserModel?> updateUser({
    required String? name,
    required String? phone,
    required String? address,
    XFile? imageFile,
  }) async {
    try {
      // Step 0: Get device token
      final token = await FirebaseMessaging.instance.getToken();

      // Step 2: Fetch current user data
      DocumentSnapshot userSnapshot =
          await _usersCollection.doc(userModel!.id).get();
      Map<String, dynamic>? currentUserData =
          userSnapshot.data() as Map<String, dynamic>?;

      // Step 3: Check if there's an existing profile picture URL
      String? previousImageUrl = currentUserData?['picture'];

      // Step 4: Upload new image
      String? newImageUrl;
      if (imageFile != null) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference fileReference = storageReference.child('users/$fileName');

        TaskSnapshot uploadTask = await fileReference
            .putFile(
              File(imageFile.path),
            )
            .timeout(
              const Duration(seconds: 10),
            );

        newImageUrl = await uploadTask.ref.getDownloadURL();
        debugPrint("New Image URL: $newImageUrl");
      }

      // Step 5: If there's an existing profile picture, delete it
      if (previousImageUrl != null) {
        try {
          await FirebaseStorage.instance.refFromURL(previousImageUrl).delete();
          debugPrint("Previous Image deleted successfully");
        } catch (e) {
          debugPrint("Error deleting previous image: $e");
        }
      }

      // Step 6: Update user in Firestore with new data
      await _usersCollection.doc(userModel!.id!).update({
        'token': token,
        'name': name,
        'phone': phone,
        'address': address,
        'picture': newImageUrl ?? previousImageUrl,
      });

      // Step 7: Retrieve updated user data from Firestore
      DocumentSnapshot updatedUserSnapshot =
          await _usersCollection.doc(userModel!.id).get();
      Map<String, dynamic>? updatedUserData =
          updatedUserSnapshot.data() as Map<String, dynamic>?;

      // Step 8: Create a User model and return it
      if (updatedUserData != null) {
        userModel = UserModel.fromJson(updatedUserData);
        debugPrint("Token: ${userModel!.token}");
        Get.back();
      } else {
        return null;
      }
    } on FirebaseAuthException catch (exception) {
      // Handle FirebaseAuthException (authentication-related errors)
      exceptionError(
        exception: exception,
      );
      return null;
    } catch (e) {
      // Handle other exceptions
      Get.snackbar(
        "Error",
        "$e",
      );
      throw Exception(e);
    }
    return null;
  }

  Stream<List<UserModel>> getUsersStream() {
    return _usersCollection.snapshots().map((querySnapshot) {
      List<UserModel> users = [];
      for (var documentSnapshot in querySnapshot.docs) {
        UserModel user = UserModel.fromJson(documentSnapshot.data());
        if (user.role != "shopkeeper") {
          users.add(user);
        }
      }
      return users;
    });
  }

  Future signOut() async {
    try {
      await _auth.signOut().then(
        (value) {
          Get.snackbar(
            "Log out",
            "Successfully logged out.",
          );
          Get.offAllNamed(AppRouteNames.login);
        },
      );
    } on FirebaseAuthException catch (exception) {
      exceptionError(
        exception: exception,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "$e",
      );
      throw Exception(e);
    }
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
