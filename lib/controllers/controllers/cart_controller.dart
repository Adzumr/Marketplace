import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/core/utils/app_constants.dart';
import 'package:marketplace/models/item_model.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final _cartCollection = FirebaseFirestore.instance.collection('carts');
  Future<void> addItem({
    required ItemModel? item,
    required String? userId,
  }) async {
    try {
      // Query the Firestore database to check if the item already exists in the user's cart
      QuerySnapshot existingItemsSnapshot = await _cartCollection
          .doc(userId)
          .collection("cart")
          .where("product", isEqualTo: item!.product!)
          .get();

      // Check if the item already exists in the cart
      if (existingItemsSnapshot.docs.isNotEmpty) {
        // Item already exists, you can handle this case as needed

        AppConstants().throwError("Item already exists");
        return; // Exit the method
      }

      // Item does not exist in the cart, proceed to add it
      DocumentReference documentRef =
          _cartCollection.doc(userId).collection("cart").doc();
      item.id = documentRef.id;

      // Set stylist with image URL to Firestore
      await documentRef.set({
        ...item.toJson(),
      }).then(
        (value) async {
          // Refresh cart stream
          getCartsStream(userId: userId);
        },
      );
      Get.back(); // Assuming this method closes the current screen or dialog
    } on FirebaseException catch (e) {
      AppConstants().throwError("${e.message}");
      debugPrint("FirebaseException: ${e.message}");
    } catch (e) {
      AppConstants().throwError("$e");
      debugPrint("Catch Exception: $e");
    }
  }

  Future deleteItem({
    ItemModel? item,
    required String? userId,
  }) async {
    try {
      DocumentReference documentRef =
          _cartCollection.doc(userId).collection("cart").doc(
                item!.id,
              );

      await documentRef.delete().then(
            (value) => getCartsStream(
              userId: userId,
            ),
          );
    } on FirebaseException catch (e) {
      exceptionError(
        exception: e,
      );
    } finally {
      Get.back();
    }
  }

  Stream<List<ItemModel>> getCartsStream({
    required String? userId,
  }) {
    return _cartCollection
        .doc(userId)
        .collection("cart")
        .snapshots()
        .map((querySnapshot) {
      List<ItemModel> items = [];
      for (var documentSnapshot in querySnapshot.docs) {
        ItemModel item = ItemModel.fromJson(documentSnapshot.data());
        items.add(item);
      }
      return items;
    });
  }

  Future<void> clearCart({required String? userId}) async {
    try {
      // Get all documents in the user's cart subcollection
      QuerySnapshot cartItemsSnapshot =
          await _cartCollection.doc(userId).collection("cart").get();

      // Loop through each document and delete it
      for (DocumentSnapshot document in cartItemsSnapshot.docs) {
        await document.reference.delete();
      }

      // Optionally, you may want to notify listeners or perform any other necessary actions after clearing the cart
      // For example:
      // Refresh cart stream
      getCartsStream(userId: userId);
    } on FirebaseException catch (e) {
      exceptionError(exception: e);
    } catch (e) {
      AppConstants().throwError("$e");
      debugPrint("Catch Exception: $e");
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
