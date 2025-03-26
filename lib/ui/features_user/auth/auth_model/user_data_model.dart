import 'dart:convert';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
  String? userId;
  String? email;
  String? name;
  String? password;
  String? photoUrl;
  String? phoneNumber;
  String? address;
  String? country;
  DateTime? timeCreated;

  UserData({
    this.userId,
    this.email,
    this.name,
    this.password,
    this.photoUrl,
    this.timeCreated,
    this.phoneNumber,
    this.address,
    this.country,
  });

  UserData copyWith({
    String? userId,
    String? email,
    String? name,
    String? password,
    String? photoUrl,
    String? phoneNumber,
    String? address,
    String? country,
    DateTime? timeCreated,
  }) =>
      UserData(
        userId: userId ?? this.userId,
        email: email ?? this.email,
        name: name ?? this.name,
        password: password ?? this.password,
        photoUrl: photoUrl ?? this.photoUrl,
        timeCreated: timeCreated ?? this.timeCreated,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        address: address ?? this.address,
        country: country ?? this.country,
      );

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        userId: json["userId"],
        email: json["email"],
        name: json["name"],
        password: json["password"],
        photoUrl: json["photoUrl"],
        phoneNumber: json["phoneNumber"],
        address: json["address"],
        country: json["country"],
        timeCreated: json["timeCreated"] == null
            ? null
            : DateTime.parse(json["timeCreated"]),
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "email": email,
        "name": name,
        "password": password,
        "photoUrl": photoUrl,
        "phoneNumber": phoneNumber,
        "address": address,
        "country": country,
        "timeCreated": timeCreated?.toIso8601String(),
      };
}
