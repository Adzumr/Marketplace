import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marketplace/models/product_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProductController extends GetxController {
  final _dishCollection = FirebaseFirestore.instance.collection('dishes');
  ProductModel? userModel;
  final Reference storageReference = FirebaseStorage.instance.ref();
  Future addProduct({
    required ProductModel? dish,
    required XFile? dishImage,
  }) async {
    String? imageUrl;
    String? fileName;

    if (dishImage != null) {
      fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference fileReference = storageReference.child('dishes/$fileName');

      TaskSnapshot uploadTask = await fileReference
          .putFile(
            File(dishImage.path),
          )
          .timeout(
            const Duration(seconds: 10),
          );

      imageUrl = await uploadTask.ref.getDownloadURL();
      debugPrint("Image URL: $imageUrl");
    }

    // Use the same DocumentReference for both adding the stylist and getting the ID
    DocumentReference documentRef = _dishCollection.doc();
    dish!.id = documentRef.id;

    // Set stylist with image URL to Firestore
    await documentRef.set({
      ...dish.toJson(),
      'picture': imageUrl,
    }).then(
      (value) async {
        getProductsStream();
      },
    );
    Get.back();
  }

  Future deleteProduct({
    ProductModel? dish,
  }) async {
    try {
      DocumentReference documentRef = _dishCollection.doc(dish!.id);
      await documentRef.delete().then(
            (value) => getProductsStream(),
          );
      if (dish.picture!.isNotEmpty) {
        // Get a reference to the image in Firebase Storage
        Reference imageRef = FirebaseStorage.instance.refFromURL(dish.picture!);

        // Delete the image from Firebase Storage
        await imageRef.delete();
      }
    } on FirebaseException catch (e) {
      exceptionError(
        exception: e,
      );
    } finally {
      Get.back();
    }
  }

  Stream<List<ProductModel>> getProductsStream() {
    return _dishCollection.snapshots().map((querySnapshot) {
      List<ProductModel> dishes = [];
      for (var documentSnapshot in querySnapshot.docs) {
        ProductModel dish = ProductModel.fromJson(documentSnapshot.data());
        dishes.add(dish);
      }
      return dishes;
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
