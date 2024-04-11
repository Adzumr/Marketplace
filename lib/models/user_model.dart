class UserModel {
  final String? id;
  final String? token;
  final String? role;
  final String? name;
  final String? email;
  final String? tag;

  UserModel({
    this.id,
    this.token,
    this.role,
    this.name,
    this.email,
    this.tag,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String?,
        token = json['token'] as String?,
        role = json['role'] as String?,
        name = json['name'] as String?,
        email = json['email'] as String?,
        tag = json['tag'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'token': token,
        'role': role,
        'name': name,
        'email': email,
        'tag': tag,
      };
}
