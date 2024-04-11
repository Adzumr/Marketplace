import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../core/routing/route_names.dart';
import '../../core/utils/app_constants.dart';
import '../../main.dart';
import '../../models/user_model.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Reference storageReference = FirebaseStorage.instance.ref();
  final _usersCollection = FirebaseFirestore.instance.collection('users');

  UserModel? userModel;

  /// Registers a new user with Firebase Authentication and Firestore.
  ///
  /// This function performs the following steps:
  /// 1. Retrieves a device token using FirebaseMessaging.
  /// 2. Create user with email and password
  /// 3. Store additional user data in Firestore
  /// 4. Retrieve user data from Firestore
  /// 5. Creates a `UserModel` object from the retrieved data and returns it.
  ///
  /// Throws an exception if an error occurs during the registration process.
  ///
  Future<UserModel?> registerUser({
    /// The user's email address.
    required String? emailAddress,

    /// The user's password.
    required String? password,

    /// The user's full name.
    required String? fullName,

    /// The user's tag (optional).
    required String? tag,

    /// The user's role (e.g., "admin", "user").
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
      await _usersCollection.doc(userCredential.user!.uid).set({
        'id': userCredential.user!.uid,
        'role': role,
        'name': fullName,
        'email': emailAddress,
        'tag': tag,
        'token': token,
      });

      // Step 3: Retrieve user data from Firestore
      DocumentSnapshot userSnapshot =
          await _usersCollection.doc(userCredential.user!.uid).get();
      Map<String, dynamic>? userData =
          userSnapshot.data() as Map<String, dynamic>?;

      // Step 4: Create a User model and return it
      if (userData != null) {
        final userModel = UserModel.fromJson(userData);
        debugPrint("Token: ${userModel.token}");
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

  /// Attempts to login a user with a given email and password.
  ///
  /// This function performs the following steps:
  /// 1. Retrieves a device token using FirebaseMessaging.
  /// 2. Signs in the user with email and password using FirebaseAuth.
  /// 3. Updates the device token for the user in Firestore.
  /// 4. Retrieves the user data from Firestore based on the logged-in user ID.
  /// 5. Creates a `UserModel` object from the retrieved data and returns it.
  ///
  /// Throws an exception if an error occurs during the login process.
  ///
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

  /// Updates a user's information in Firestore and retrieves the updated data.
  ///
  /// This function performs the following steps:
  /// 1. Get device token
  /// 2. Update user in Firestore with new data
  /// 3. Retrieve updated user data from Firestore
  /// 4. Create a User model and return it
  ///
  /// Throws an exception if an error occurs during the login process.
  ///
  Future<UserModel?> updateUser({
    /// The user's new name. Can be null if not updating.
    required String? name,

    /// The user's new tag. Can be null if not updating.
    required String? tag,
  }) async {
    try {
      // Step 0: Get device token
      final token = await FirebaseMessaging.instance.getToken();

      // Step 1: Update user in Firestore with new data
      await _usersCollection.doc(userModel!.id!).update({
        'token': token,
        'name': name,
        'tag': tag ?? "",
      });

      // Step 2: Retrieve updated user data from Firestore
      DocumentSnapshot updatedUserSnapshot =
          await _usersCollection.doc(userModel!.id).get();
      Map<String, dynamic>? updatedUserData =
          updatedUserSnapshot.data() as Map<String, dynamic>?;

      // Step 3: Create a User model and return it
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

  /// Fetches all users from the Firestore 'users' collection and returns them as a list of `UserModel`.
  ///
  /// This function asynchronously retrieves a snapshot of the 'users' collection from Firestore,
  /// then maps each document snapshot to a `UserModel` using the model's `fromJson` factory method.
  /// It finally returns a list of `UserModel` objects representing all users in the collection.
  ///
  /// Returns:
  ///   A `Future<List<UserModel>>` that resolves to a list of `UserModel` instances representing all users.
  ///
  /// Example:
  ///   To fetch all users and handle them in your application, you can use:
  ///   ```dart
  ///   getUsers().then((users) {
  ///     for (var user in users) {
  ///       print(user.name); // Assuming UserModel has a name field
  ///     }
  ///   });
  ///   ```
  Future<List<UserModel>> getUsers() async {
    // Getting the snapshot of the 'users' collection
    final snapshot = await _usersCollection.get();

    // Mapping each document snapshot to a UserModel instance
    final users = snapshot.docs.map((doc) {
      // Extract data from each document snapshot
      final data = doc.data();

      // Create a UserModel from the data
      return UserModel.fromJson(data);
    }).toList(); // Convert the result to a List<UserModel>

    // Return the list of user models
    return users;
  }

  /// Signs out the current user and navigates to the login screen.
  ///
  /// This method calls the underlying authentication provider's signOut method
  /// to end the current user session. After successful sign out, it displays a
  /// snackbar message and navigates to the login screen using `Get.offAllNamed`.
  ///
  /// If a FirebaseAuthException occurs during sign out, it is caught and passed
  /// to the `exceptionError` function for handling. Any other exceptions are caught
  /// and displayed in a snackbar message before being re-thrown.
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

  /// Handles a Firebase exception by displaying a snackbar with the error code
  /// and re-throws the exception for further handling.
  ///
  void exceptionError({
    FirebaseException? exception,
  }) {
    if (exception != null) {
      Get.snackbar(
        "Error",
        exception.code,
      );
      throw Exception(exception.message);
    }
  }
}
