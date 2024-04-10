class UserModel {
  final String? id;
  final String? token;
  final String? picture;
  final String? role;
  final String? name;
  final String? email;
  final String? phone;
  final String? tag;

  UserModel({
    this.id,
    this.token,
    this.picture,
    this.role,
    this.name,
    this.email,
    this.phone,
    this.tag,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String?,
        token = json['token'] as String?,
        picture = json['picture'] as String?,
        role = json['role'] as String?,
        name = json['name'] as String?,
        email = json['email'] as String?,
        phone = json['phone'] as String?,
        tag = json['tag'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'token': token,
        'picture': picture,
        'role': role,
        'name': name,
        'email': email,
        'phone': phone,
        'tag': tag,
      };
}
