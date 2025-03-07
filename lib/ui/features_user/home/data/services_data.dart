import 'package:biztidy_mobile_app/ui/features_user/home/home_model/services_model.dart';

enum CleaningCategory { all, commercial, residential, industrial, specialty }

List<ServiceModel> commercialServices = [
  ServiceModel(
    imageUrl: 'assets/office.png',
    name: 'Office',
    baseCost: 200,
  ),
  ServiceModel(
    imageUrl: 'assets/showroom.png',
    name: 'Showroom',
    baseCost: 250,
  ),
  ServiceModel(
    imageUrl: 'assets/salon.png',
    name: 'Salon',
    baseCost: 150,
  ),
];

List<ServiceModel> residentialServices = [
  ServiceModel(
    imageUrl: 'assets/apartment.png',
    name: 'Residential apartment',
    baseCost: 300,
  ),
  ServiceModel(
    imageUrl: 'assets/house.png',
    name: 'Residential house',
    baseCost: 350,
  ),
  ServiceModel(
    imageUrl: 'assets/move_in_out.png',
    name: 'Move in/out',
    baseCost: 400,
  ),
];

List<ServiceModel> industrialServices = [
  ServiceModel(
    imageUrl: 'assets/factory.png',
    name: 'Factory',
    baseCost: 450,
  ),
  ServiceModel(
    imageUrl: 'assets/workshop.png',
    name: 'Workshop',
    baseCost: 300,
  ),
  ServiceModel(
    imageUrl: 'assets/maintenance.png',
    name: 'Maintenance',
    baseCost: 200,
  ),
];

List<ServiceModel> specialtyServices = [
  // ServiceModel(
  //   imageUrl: 'assets/ac.png',
  //   name: 'AC',
  //   baseCost: 150,
  // ),
  ServiceModel(
    imageUrl: 'assets/post_construction.png',
    name: 'Post Construction',
    baseCost: 600,
  ),
  ServiceModel(
    imageUrl: 'assets/event.png',
    name: 'Event',
    baseCost: 600,
  ),
];

List<ServiceModel> popularServices = [
  ServiceModel(
    imageUrl: 'assets/apartment_home.png',
    name: 'Apartment',
    baseCost: 150,
  ),
  ServiceModel(
    imageUrl: 'assets/move_in_out_home.png',
    name: 'Move in/Move out',
    baseCost: 150,
  ),
  ServiceModel(
    imageUrl: 'assets/office_home.png',
    name: 'Office',
    baseCost: 150,
  ),
  ServiceModel(
    imageUrl: 'assets/factory.png',
    name: 'Factory',
    baseCost: 150,
  ),
  ServiceModel(
    imageUrl: 'assets/workshop.png',
    name: 'Workshop',
    baseCost: 150,
  ),
  ServiceModel(
    imageUrl: 'assets/event.png',
    name: 'Event',
    baseCost: 150,
  ),
];
