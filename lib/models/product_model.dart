class ProductModel {
  String? id;
  final String? name;
  final String? picture;
  final double? price;
  final String? description;

  ProductModel({
    this.id,
    required this.name,
    this.picture,
    required this.price,
    required this.description,
  });

  ProductModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String?,
        name = json['name'] as String?,
        picture = json['picture'] as String?,
        price = json['price'] as double?,
        description = json['description'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'picture': picture,
        'price': price,
        'description': description,
      };
}
