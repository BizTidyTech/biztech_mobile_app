import 'dart:convert';

BookingModel bookingModelFromJson(String str) =>
    BookingModel.fromJson(json.decode(str));

String bookingModelToJson(BookingModel data) => json.encode(data.toJson());

class BookingModel {
  final String? serviceName;
  final double? baseCost;
  final DateTime? dateTime;
  final String? locationName;
  final String? locationAddress;
  final int? rooms;
  final int? durationInMins;
  final String? roomSqFt;

  BookingModel({
    this.serviceName,
    this.baseCost,
    this.dateTime,
    this.locationName,
    this.locationAddress,
    this.rooms,
    this.durationInMins,
    this.roomSqFt,
  });

  BookingModel copyWith({
    String? serviceName,
    double? baseCost,
    DateTime? dateTime,
    String? locationName,
    String? locationAddress,
    int? rooms,
    int? durationInMins,
    String? roomSqFt,
  }) =>
      BookingModel(
        serviceName: serviceName ?? this.serviceName,
        baseCost: baseCost ?? this.baseCost,
        dateTime: dateTime ?? this.dateTime,
        locationName: locationName ?? this.locationName,
        locationAddress: locationAddress ?? this.locationAddress,
        rooms: rooms ?? this.rooms,
        durationInMins: durationInMins ?? this.durationInMins,
        roomSqFt: roomSqFt ?? this.roomSqFt,
      );

  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
        serviceName: json["serviceName"],
        baseCost: json["baseCost"]?.toDouble(),
        dateTime:
            json["dateTime"] == null ? null : DateTime.parse(json["dateTime"]),
        locationName: json["locationName"],
        locationAddress: json["locationAddress"],
        rooms: json["rooms"],
        durationInMins: json["durationInMins"],
        roomSqFt: json["roomSqFt"],
      );

  Map<String, dynamic> toJson() => {
        "serviceName": serviceName,
        "baseCost": baseCost,
        "dateTime": dateTime?.toIso8601String(),
        "locationName": locationName,
        "locationAddress": locationAddress,
        "rooms": rooms,
        "durationInMins": durationInMins,
        "roomSqFt": roomSqFt,
      };
}
