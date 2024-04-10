class UserModel {
  final String? id;
  final String? token;
  final String? picture;
  final bool? isAdmin;
  final String? name;
  final String? email;
  final String? phone;
  final String? address;

  UserModel({
    this.id,
    this.token,
    this.picture,
    this.isAdmin,
    this.name,
    this.email,
    this.phone,
    this.address,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String?,
        token = json['token'] as String?,
        picture = json['picture'] as String?,
        isAdmin = json['isAdmin'] as bool?,
        name = json['name'] as String?,
        email = json['email'] as String?,
        phone = json['phone'] as String?,
        address = json['address'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'token': token,
        'picture': picture,
        'isAdmin': isAdmin,
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
      };
}
