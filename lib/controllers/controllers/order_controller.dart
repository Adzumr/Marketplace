import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marketplace/models/my_order_model.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  final _orderCollection = FirebaseFirestore.instance.collection('orders');
  Future placeOrder({
    required MyOrderModel? orderModel,
  }) async {
    // Use the same DocumentReference for both adding the stylist and getting the ID
    DocumentReference documentRef = _orderCollection.doc();
    orderModel!.id = documentRef.id;

    // Set stylist with image URL to Firestore
    await documentRef.set({
      ...orderModel.toJson(),
    }).then(
      (value) async {
        getOrdersStream();
      },
    );
    Get.back();
  }

  Future updateOrder({
    required String? orderId,
    required String? orderStatus,
    required String? paymentStatus,
  }) async {
    // Use the same DocumentReference for both adding the stylist and getting the ID
    DocumentReference documentRef = _orderCollection.doc(orderId);

    // Set stylist with image URL to Firestore
    await documentRef.update({
      "order_status": orderStatus,
      "payment_status": paymentStatus,
    }).then(
      (value) async {
        getOrdersStream();
      },
    );
    Get.back();
  }

  Stream<List<MyOrderModel>> getOrdersStream() {
    return _orderCollection.snapshots().map((querySnapshot) {
      List<MyOrderModel> orders = [];
      for (var documentSnapshot in querySnapshot.docs) {
        MyOrderModel order = MyOrderModel.fromJson(documentSnapshot.data());
        orders.add(order);
      }
      return orders;
    });
  }

  Stream<List<MyOrderModel>> myOrderStream({
    required String? customerId,
  }) {
    return _orderCollection.snapshots().map((querySnapshot) {
      List<MyOrderModel> orders = [];
      for (var documentSnapshot in querySnapshot.docs) {
        MyOrderModel order = MyOrderModel.fromJson(documentSnapshot.data());
        if (order.user!.id == customerId) {
          orders.add(order);
        }
      }
      return orders;
    });
  }
}
