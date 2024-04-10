class ItemModel {
  String? id;
  final String? product;
  final double? price;
  final int? quantity;
  final String? picture;
  final double? total;

  ItemModel({
    this.id,
    this.product,
    this.price,
    this.quantity,
    this.picture,
    this.total,
  });

  ItemModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String?,
        product = json['product'] as String?,
        price = json['price'] as double?,
        quantity = json['quantity'] as int?,
        picture = json['picture'] as String?,
        total = json['total'] as double?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'product': product,
        'price': price,
        'quantity': quantity,
        'picture': picture,
        'total': total
      };
}
