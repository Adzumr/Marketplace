class OrderModel {
  String? orderId;
  final String? customerName;
  final String? customerId;
  final String? contact;
  final String? deliveryAddress;
  final String? dish;
  final String? dishPic;
  final int? quantity;
  final double? price;
  final double? total;
  final String? status;
  final bool? isAccepted;
  final String? date;

  OrderModel({
    this.orderId,
    required this.customerName,
    required this.customerId,
    required this.contact,
    required this.deliveryAddress,
    required this.dish,
    required this.dishPic,
    required this.quantity,
    required this.price,
    required this.total,
    required this.status,
    this.isAccepted = false,
    required this.date,
  });

  OrderModel.fromJson(Map<String, dynamic> json)
      : orderId = json['order_id'] as String?,
        customerName = json['customer_name'] as String?,
        customerId = json['customer_id'] as String?,
        contact = json['contact'] as String?,
        deliveryAddress = json['delivery_address'] as String?,
        dish = json['dish'] as String?,
        dishPic = json['dish_pic'] as String?,
        quantity = json['quantity'] as int?,
        price = json['price'] as double?,
        total = json['total'] as double?,
        status = json['status'] as String?,
        isAccepted = json['isAccepted'] as bool?,
        date = json['date'] as String?;

  Map<String, dynamic> toJson() => {
        'order_id': orderId,
        'customer_name': customerName,
        'customer_id': customerId,
        'contact': contact,
        'delivery_address': deliveryAddress,
        'dish': dish,
        'dish_pic': dishPic,
        'quantity': quantity,
        'price': price,
        'total': total,
        'status': status,
        'isAccepted': isAccepted,
        'date': date
      };
}
