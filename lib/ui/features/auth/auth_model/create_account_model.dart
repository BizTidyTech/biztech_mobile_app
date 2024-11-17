import 'dart:convert';

import 'package:equatable/equatable.dart';

UserAccountModel userAccountModelFromJson(String str) =>
    UserAccountModel.fromJson(json.decode(str));

String userAccountModelToJson(UserAccountModel data) =>
    json.encode(data.toJson());

class UserAccountModel extends Equatable {
  const UserAccountModel({this.name, this.email, this.password});

  final String? name;
  final String? email;
  final String? password;

  UserAccountModel copyWith({
    String? name,
    String? password,
    String? email,
  }) =>
      UserAccountModel(
        name: name ?? this.name,
        password: password ?? this.password,
        email: email ?? this.email,
      );

  factory UserAccountModel.fromJson(Map<String, dynamic> json) =>
      UserAccountModel(
        name: json["name"],
        password: json["password"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "password": password,
        "email": email,
      };

  @override
  List<Object?> get props => [name, password, email];
}
