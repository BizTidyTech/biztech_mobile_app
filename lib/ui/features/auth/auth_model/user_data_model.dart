class UserData {
  String? userId;
  String? email;
  String? name;
  String? photoUrl;
  String? password;

  UserData({
    this.userId,
    this.email,
    this.name,
    this.photoUrl,
    this.password,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userId: json['userId'],
      email: json['email'],
      name: json['name'],
      photoUrl: json['photoUrl'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['email'] = email;
    data['name'] = name;
    data['photoUrl'] = photoUrl;
    data['password'] = password;
    return data;
  }
}
