import 'dart:convert';

import 'package:tidytech/ui/features/home/home_model/services_model.dart';

BookingModel bookingModelFromJson(String str) =>
    BookingModel.fromJson(json.decode(str));

String bookingModelToJson(BookingModel data) => json.encode(data.toJson());

class BookingModel {
  final String? bookingId;
  final DateTime? dateTime;
  final String? locationName;
  final String? locationAddress;
  final int? rooms;
  final int? duration;
  final double? roomSqFt;
  final String? additionalInfo;
  final ServiceModel? service;
  final Customer? customer;

  BookingModel({
    this.bookingId,
    this.dateTime,
    this.locationName,
    this.locationAddress,
    this.rooms,
    this.duration,
    this.roomSqFt,
    this.additionalInfo,
    this.service,
    this.customer,
  });

  BookingModel copyWith({
    String? bookingId,
    DateTime? dateTime,
    String? locationName,
    String? locationAddress,
    int? rooms,
    int? duration,
    double? roomSqFt,
    String? additionalInfo,
    ServiceModel? service,
    Customer? customer,
  }) =>
      BookingModel(
        bookingId: bookingId ?? this.bookingId,
        dateTime: dateTime ?? this.dateTime,
        locationName: locationName ?? this.locationName,
        locationAddress: locationAddress ?? this.locationAddress,
        rooms: rooms ?? this.rooms,
        duration: duration ?? this.duration,
        roomSqFt: roomSqFt ?? this.roomSqFt,
        service: service ?? this.service,
        additionalInfo: additionalInfo ?? this.additionalInfo,
        customer: customer ?? this.customer,
      );

  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
        bookingId: json["bookingId"],
        dateTime:
            json["dateTime"] == null ? null : DateTime.parse(json["dateTime"]),
        locationName: json["locationName"],
        locationAddress: json["locationAddress"],
        rooms: json["rooms"],
        duration: json["duration"],
        roomSqFt: json["roomSqFt"]?.toDouble(),
        additionalInfo: json["additionalInfo"],
        service: json["service"] == null
            ? null
            : ServiceModel.fromJson(json["service"]),
        customer: json["customer"] == null
            ? null
            : Customer.fromJson(json["customer"]),
      );

  Map<String, dynamic> toJson() => {
        "bookingId": bookingId,
        "dateTime": dateTime?.toIso8601String(),
        "locationName": locationName,
        "locationAddress": locationAddress,
        "rooms": rooms,
        "duration": duration,
        "roomSqFt": roomSqFt,
        "additionalInfo": additionalInfo,
        "service": service?.toJson(),
        "customer": customer?.toJson(),
      };
}

class Customer {
  final String? userId;
  final String? name;
  final String? phoneNumber;

  Customer({
    this.userId,
    this.name,
    this.phoneNumber,
  });

  Customer copyWith({
    String? userId,
    String? name,
    String? phoneNumber,
  }) =>
      Customer(
        userId: userId ?? this.userId,
        name: name ?? this.name,
        phoneNumber: phoneNumber ?? this.phoneNumber,
      );

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        userId: json["userId"],
        name: json["name"],
        phoneNumber: json["phoneNumber"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "name": name,
        "phoneNumber": phoneNumber,
      };
}
