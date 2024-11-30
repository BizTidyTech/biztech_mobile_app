import 'dart:convert';

AdminAuthModel adminAuthModelFromJson(String str) =>
    AdminAuthModel.fromJson(json.decode(str));

String adminAuthModelToJson(AdminAuthModel data) => json.encode(data.toJson());

class AdminAuthModel {
  final String? id;
  final String? password;

  AdminAuthModel({
    this.id,
    this.password,
  });

  AdminAuthModel copyWith({
    String? id,
    String? password,
  }) =>
      AdminAuthModel(
        id: id ?? this.id,
        password: password ?? this.password,
      );

  factory AdminAuthModel.fromJson(Map<String, dynamic> json) => AdminAuthModel(
        id: json["id"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "password": password,
      };
}
