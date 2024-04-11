class RequestModel {
  String? id;
  final String? name;
  final String? tag;
  final String? description;
  final String? customerId;

  RequestModel({
    this.id,
    required this.name,
    required this.tag,
    required this.description,
    required this.customerId,
  });

  RequestModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String?,
        name = json['name'] as String?,
        tag = json['tag'] as String?,
        description = json['description'] as String?,
        customerId = json['customer_id'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'tag': tag,
        'description': description,
        'customer_id': customerId,
      };
}
