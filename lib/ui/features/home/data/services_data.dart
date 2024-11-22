import 'package:tidytech/ui/features/home/home_model/services_model.dart';

enum CleaningCategory { commercial, residential, industrial, specialty }

List<ServiceModel> commercialServices = [
  ServiceModel(
    imageUrl: 'assets/image.png',
    name: 'Office',
    baseCost: 200,
  ),
  ServiceModel(
    imageUrl: 'assets/image.png',
    name: 'Showroom',
    baseCost: 250,
  ),
  ServiceModel(
    imageUrl: 'assets/image.png',
    name: 'Salon',
    baseCost: 150,
  ),
];

List<ServiceModel> residentialServices = [
  ServiceModel(
    imageUrl: 'assets/image.png',
    name: 'Residential apartment',
    baseCost: 300,
  ),
  ServiceModel(
    imageUrl: 'assets/image.png',
    name: 'Residential house',
    baseCost: 350,
  ),
  ServiceModel(
    imageUrl: 'assets/image.png',
    name: 'Move in/out',
    baseCost: 400,
  ),
];

List<ServiceModel> industrialServices = [
  ServiceModel(
    imageUrl: 'assets/image.png',
    name: 'Factory',
    baseCost: 450,
  ),
  ServiceModel(
    imageUrl: 'assets/image.png',
    name: 'Workshop',
    baseCost: 300,
  ),
  ServiceModel(
    imageUrl: 'assets/image.png',
    name: 'Maintenance',
    baseCost: 200,
  ),
];

List<ServiceModel> specialtyServices = [
  ServiceModel(
    imageUrl: 'assets/image.png',
    name: 'AC',
    baseCost: 150,
  ),
  ServiceModel(
    imageUrl: 'assets/image.png',
    name: 'Post Construction',
    baseCost: 600,
  ),
  ServiceModel(
    imageUrl: 'assets/image.png',
    name: 'Event',
    baseCost: 600,
  ),
];
