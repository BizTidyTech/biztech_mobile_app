import 'package:biztidy_mobile_app/ui/features_user/home/home_model/services_model.dart';

enum CleaningCategory { all, commercial, residential, industrial, specialty }

// Commercial Cleaning — ₦50,000 / $50
List<ServiceModel> commercialServices = [
  ServiceModel(imageUrl: 'assets/office.png', name: 'Office', baseCost: 50000, usdCost: 50),
  ServiceModel(imageUrl: 'assets/showroom.png', name: 'Showroom', baseCost: 50000, usdCost: 50),
  ServiceModel(imageUrl: 'assets/salon.png', name: 'Salon', baseCost: 50000, usdCost: 50),
];

// Residential Cleaning — Individual pricing per property type
List<ServiceModel> residentialServices = [
  ServiceModel(imageUrl: 'assets/house.png', name: '3-Bedroom Duplex', baseCost: 90000, usdCost: 90),
  ServiceModel(imageUrl: 'assets/move_in_out.png', name: "3-Bedroom Duplex with Boys' Quarters", baseCost: 120000, usdCost: 120),
  ServiceModel(imageUrl: 'assets/apartment.png', name: '4-5 Bedroom Duplex', baseCost: 160000, usdCost: 160),
  ServiceModel(imageUrl: 'assets/house.png', name: "4-5 Bedroom Duplex with Boys' Quarters", baseCost: 190000, usdCost: 190),
  ServiceModel(imageUrl: 'assets/move_in_out.png', name: '3-Bedroom Flat', baseCost: 50000, usdCost: 50),
  ServiceModel(imageUrl: 'assets/apartment.png', name: '2-Bedroom Flat', baseCost: 40000, usdCost: 40),
];

// Industrial Cleaning — ₦200,000 / $200
List<ServiceModel> industrialServices = [
  ServiceModel(imageUrl: 'assets/factory.png', name: 'Factory', baseCost: 200000, usdCost: 200),
  ServiceModel(imageUrl: 'assets/workshop.png', name: 'Workshop', baseCost: 200000, usdCost: 200),
  ServiceModel(imageUrl: 'assets/maintenance.png', name: 'Maintenance', baseCost: 200000, usdCost: 200),
];

// Specialty Cleaning — ₦400,000 / $400
List<ServiceModel> specialtyServices = [
  ServiceModel(imageUrl: 'assets/post_construction.png', name: 'Post Construction', baseCost: 400000, usdCost: 400),
  ServiceModel(imageUrl: 'assets/event.png', name: 'Event', baseCost: 400000, usdCost: 400),
];

List<ServiceModel> popularServices = [
  ServiceModel(imageUrl: 'assets/apartment_home.png', name: '2-Bedroom Flat', baseCost: 40000, usdCost: 40),
  ServiceModel(imageUrl: 'assets/move_in_out_home.png', name: '3-Bedroom Flat', baseCost: 50000, usdCost: 50),
  ServiceModel(imageUrl: 'assets/office_home.png', name: 'Office', baseCost: 50000, usdCost: 50),
  ServiceModel(imageUrl: 'assets/factory.png', name: 'Factory', baseCost: 200000, usdCost: 200),
  ServiceModel(imageUrl: 'assets/workshop.png', name: 'Workshop', baseCost: 200000, usdCost: 200),
  ServiceModel(imageUrl: 'assets/event.png', name: 'Event', baseCost: 400000, usdCost: 400),
];
