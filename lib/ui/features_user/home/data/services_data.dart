import 'package:biztidy_mobile_app/ui/features_user/home/home_model/services_model.dart';

enum CleaningCategory { all, commercial, residential, industrial, specialty }

// Commercial Cleaning — ₦50,000 / $50
List<ServiceModel> commercialServices = [
  ServiceModel(imageUrl: 'assets/office.jpeg', name: 'Office', baseCost: 50000, usdCost: 50),
  ServiceModel(imageUrl: 'assets/showroom.jpeg', name: 'Showroom', baseCost: 50000, usdCost: 50),
  ServiceModel(imageUrl: 'assets/salon.jpeg', name: 'Salon', baseCost: 50000, usdCost: 50),
];

// Residential Cleaning — Individual pricing per property type
List<ServiceModel> residentialServices = [
  ServiceModel(imageUrl: 'assets/2-bedroom.jpeg', name: '2-Bedroom Flat', baseCost: 50000, usdCost: 50),
  ServiceModel(imageUrl: 'assets/3-bedroom-duplex.jpeg', name: '3-Bedroom Duplex', baseCost: 90000, usdCost: 90),
  ServiceModel(imageUrl: 'assets/3-bedroom-duplexBq.jpeg', name: "3-Bedroom Duplex with Boys' Quarters", baseCost: 120000, usdCost: 120),
  ServiceModel(imageUrl: 'assets/3-bedroom_flat.jpeg', name: '3-Bedroom Flat', baseCost: 50000, usdCost: 50),
  ServiceModel(imageUrl: 'assets/4-bedroom_duplex.jpeg', name: '4 Bedroom Duplex', baseCost: 160000, usdCost: 160),
  ServiceModel(imageUrl: 'assets/4-bedroom_duplexBq.jpeg', name: "4 Bedroom Duplex with Boys' Quarters", baseCost: 190000, usdCost: 190),
  ServiceModel(imageUrl: 'assets/move_in_out_home.png', name: 'Move In/Move Out', baseCost: 100000, usdCost: 100),
];

// Industrial Cleaning — ₦200,000 / $200
List<ServiceModel> industrialServices = [
  ServiceModel(imageUrl: 'assets/factory.jpeg', name: 'Factory', baseCost: 200000, usdCost: 200),
  ServiceModel(imageUrl: 'assets/workshop.jpeg', name: 'Workshop', baseCost: 200000, usdCost: 200),
  ServiceModel(imageUrl: 'assets/maintenance.png', name: 'Maintenance', baseCost: 200000, usdCost: 200),
];

// Specialty Cleaning — ₦400,000 / $400
List<ServiceModel> specialtyServices = [
  ServiceModel(imageUrl: 'assets/post_construction.jpeg', name: 'Post Construction', baseCost: 400000, usdCost: 400),
  ServiceModel(imageUrl: 'assets/event.jpeg', name: 'Event', baseCost: 400000, usdCost: 400),
];

List<ServiceModel> popularServices = [
  ServiceModel(imageUrl: 'assets/2-bedroom.jpeg', name: '2-Bedroom Flat', baseCost: 50000, usdCost: 50),
  ServiceModel(imageUrl: 'assets/3-bedroom_flat.jpeg', name: '3-Bedroom Flat', baseCost: 50000, usdCost: 50),
  ServiceModel(imageUrl: 'assets/office.jpeg', name: 'Office', baseCost: 50000, usdCost: 50),
  ServiceModel(imageUrl: 'assets/factory.jpeg', name: 'Factory', baseCost: 200000, usdCost: 200),
  ServiceModel(imageUrl: 'assets/workshop.jpeg', name: 'Workshop', baseCost: 200000, usdCost: 200),
  ServiceModel(imageUrl: 'assets/event.jpeg', name: 'Event', baseCost: 400000, usdCost: 400),
];