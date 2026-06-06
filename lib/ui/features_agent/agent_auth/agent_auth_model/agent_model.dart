import 'dart:convert';

AgentModel agentModelFromJson(String str) =>
    AgentModel.fromJson(json.decode(str));

String agentModelToJson(AgentModel data) => json.encode(data.toJson());

class AgentModel {
  final String? agentId;
  final String? name;
  final String? email;
  final String? password;
  final String? phoneNumber;
  final String? address;
  final String? photoUrl;
  final String? status; // 'offline', 'online', 'on_job'
  final double? rating;
  final int? totalJobsCompleted;
  final double? totalEarnings;
  final DateTime? timeCreated;
  final bool? isApproved;

  AgentModel({
    this.agentId,
    this.name,
    this.email,
    this.password,
    this.phoneNumber,
    this.address,
    this.photoUrl,
    this.status,
    this.rating,
    this.totalJobsCompleted,
    this.totalEarnings,
    this.timeCreated,
    this.isApproved,
  });

  AgentModel copyWith({
    String? agentId,
    String? name,
    String? email,
    String? password,
    String? phoneNumber,
    String? address,
    String? photoUrl,
    String? status,
    double? rating,
    int? totalJobsCompleted,
    double? totalEarnings,
    DateTime? timeCreated,
    bool? isApproved,
  }) =>
      AgentModel(
        agentId: agentId ?? this.agentId,
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        address: address ?? this.address,
        photoUrl: photoUrl ?? this.photoUrl,
        status: status ?? this.status,
        rating: rating ?? this.rating,
        totalJobsCompleted: totalJobsCompleted ?? this.totalJobsCompleted,
        totalEarnings: totalEarnings ?? this.totalEarnings,
        timeCreated: timeCreated ?? this.timeCreated,
        isApproved: isApproved ?? this.isApproved,
      );

  factory AgentModel.fromJson(Map<String, dynamic> json) => AgentModel(
        agentId: json['agentId'],
        name: json['name'],
        email: json['email'],
        password: json['password'],
        phoneNumber: json['phoneNumber'],
        address: json['address'],
        photoUrl: json['photoUrl'],
        status: json['status'] ?? 'offline',
        rating: json['rating']?.toDouble() ?? 5.0,
        totalJobsCompleted: json['totalJobsCompleted'] ?? 0,
        totalEarnings: json['totalEarnings']?.toDouble() ?? 0.0,
        isApproved: json['isApproved'] ?? false,
        timeCreated: json['timeCreated'] == null
            ? null
            : DateTime.parse(json['timeCreated']),
      );

  Map<String, dynamic> toJson() => {
        'agentId': agentId,
        'name': name,
        'email': email,
        'password': password,
        'phoneNumber': phoneNumber,
        'address': address,
        'photoUrl': photoUrl,
        'status': status,
        'rating': rating,
        'totalJobsCompleted': totalJobsCompleted,
        'totalEarnings': totalEarnings,
        'timeCreated': timeCreated?.toIso8601String(),
        'isApproved': isApproved ?? false,
      };
}
