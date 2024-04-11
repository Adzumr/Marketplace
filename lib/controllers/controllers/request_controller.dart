import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marketplace/models/product_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class RequestController extends GetxController {
  final _requestCollection = FirebaseFirestore.instance.collection('requests');
  RequestModel? userModel;
  final Reference storageReference = FirebaseStorage.instance.ref();
  Future addRequest({
    required RequestModel? request,
  }) async {
    // Use the same DocumentReference for both adding the stylist and getting the ID
    DocumentReference documentRef = _requestCollection.doc();
    request!.id = documentRef.id;

    // Set stylist with image URL to Firestore
    await documentRef.set({
      ...request.toJson(),
    }).then(
      (value) async {
        getRequestsStream();
      },
    );
    Get.back();
  }

  Future deleteRequest({
    RequestModel? dish,
  }) async {
    try {
      DocumentReference documentRef = _requestCollection.doc(dish!.id);
      await documentRef.delete().then(
            (value) => getRequestsStream(),
          );
    } on FirebaseException catch (e) {
      exceptionError(
        exception: e,
      );
    } finally {
      Get.back();
    }
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
