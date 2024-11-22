import 'dart:convert';

ServiceModel serviceModelFromJson(String str) =>
    ServiceModel.fromJson(json.decode(str));

String serviceModelToJson(ServiceModel data) => json.encode(data.toJson());

class ServiceModel {
  final String? imageUrl;
  final String? name;
  final double? baseCost;

  ServiceModel({
    this.imageUrl,
    this.name,
    this.baseCost,
  });

  ServiceModel copyWith({
    String? imageUrl,
    String? name,
    double? baseCost,
  }) =>
      ServiceModel(
        imageUrl: imageUrl ?? this.imageUrl,
        name: name ?? this.name,
        baseCost: baseCost ?? this.baseCost,
      );

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
        imageUrl: json["imageUrl"],
        name: json["name"],
        baseCost: json["baseCost"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "imageUrl": imageUrl,
        "name": name,
        "baseCost": baseCost,
      };
}
