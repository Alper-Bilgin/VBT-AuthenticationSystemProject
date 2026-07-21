class UserModel {
  final int id;
  final String email;
  final String role;
  final String createdAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.role,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      email: json["email"],
      role: json["role"],
      createdAt: json["createdAt"],
    );
  }
}