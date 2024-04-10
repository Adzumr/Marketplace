import 'package:marketplace/models/user_model.dart';

import 'item_model.dart';

class MyOrderModel {
  String? id;
  final UserModel? user;
  final List<ItemModel>? items;
  final String? date;
  final double? totalAmount;
  final String? paymentStatus;
  final String? orderStatus;

  MyOrderModel({
    this.id,
    this.user,
    this.items,
    this.date,
    this.totalAmount,
    this.paymentStatus,
    this.orderStatus,
  });

  MyOrderModel.fromJson(Map<String, dynamic> json)
      : id = json['order_id'] as String?,
        user = (json['user'] as Map<String, dynamic>?) != null
            ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
            : null,
        items = (json['items'] as List?)
            ?.map((dynamic e) => ItemModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        date = json['date'] as String?,
        totalAmount = json['totalAmount'] as double?,
        paymentStatus = json['payment_status'] as String?,
        orderStatus = json['order_status'] as String?;

  Map<String, dynamic> toJson() => {
        'order_id': id,
        'user': user?.toJson(),
        'items': items?.map((e) => e.toJson()).toList(),
        'date': date,
        'totalAmount': totalAmount,
        'payment_status': paymentStatus,
        'order_status': orderStatus
      };
}
