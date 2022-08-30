import'package:flutter/material.dart';

import 'package:geocoding/geocoding.dart';

import 'package:geolocator/geolocator.dart';

import 'package:get/get.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:permission_handler/permission_handler.dart';



class GeolocatorController extends GetxController {

 Rx<TextEditingController> pickUpLocationController = TextEditingController().obs;
 Rx<Position> currentLocation = Position(

 longitude: 0.0,

latitude: 0.0,

 timestamp: DateTime.now(),

 accuracy: 0.0,

 altitude: 0.0,

 heading: 0.0,

 speed: 0.0,

 speedAccuracy: 0.0,

 ).obs;



 RxString getAddressName = ''.obs;



 Future<Position> getCurrentLocation() async {

 var status = await Permission.location.status;

 if (status.isGranted) {

 return await Geolocator.getCurrentPosition(

 desiredAccuracy: LocationAccuracy.high);

 } else {

 await Permission.location.request();

 return await Geolocator.getCurrentPosition(
   desiredAccuracy: LocationAccuracy.high);

 }
 }



 setCurrentLocation() async {

 currentLocation.value = await getCurrentLocation();

debugPrint('Current location : ${currentLocation.value}');

 await getPlaceMark();

 }



 setManualLocation(LatLng latlng) async {

 currentLocation.value = Position(

 longitude: latlng.longitude,

 latitude: latlng.latitude,
   timestamp: DateTime.now(),

 accuracy: 0.0,

 altitude: 0.0,

 heading: 0.0,

 speed: 0.0,

 speedAccuracy: 0.0,

 );
 await getPlaceMark();

}



 Future<void> getPlaceMark() async {

 List<Placemark> placemarks;

 try {

 placemarks = await placemarkFromCoordinates(

currentLocation.value.latitude, currentLocation.value.longitude);



 getAddressName.value =

 '${placemarks[0].name} , ${placemarks[0].country} , ${placemarks[0].locality} , ${placemarks[0].street}';

 debugPrint('your Locaaaaaation :: $getAddressName');
 pickUpLocationController.value.text=getAddressName.value;

 } catch (e) {

 placemarks = [

 Placemark(locality: 'لا يوجد عنوان'),

 ];
 }

 }

}