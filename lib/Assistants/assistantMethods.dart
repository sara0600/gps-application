import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_app/Assistants/requestAssistant.dart';
import 'package:gps_app/DataHandler/appData.dart';
import 'package:gps_app/Models/address.dart';
import 'package:gps_app/Models/directionDetails.dart';
import 'package:gps_app/configMaps.dart';
import 'package:provider/provider.dart';
import 'package:gps_app/All%20screens/Gps.dart';
import 'package:http/http.dart'as http;

class AssistantMethods{
  static Future<String> searchCoordinateAddress(Position position,context) async{
    String st1,st2,st3,st4;
    String placeAddress="";
    String url="https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
       http.Response res= await RequestAssistant.getRequest(url);


       if(res.statusCode==200){
         var response=jsonDecode(res.body);
         print("iam hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
         //placeAddress=response["results"][0]["formatted_address"];
         st1=response["results"][0]["address_components"][0]["long_name"];
         st2=response["results"][0]["address_components"][1]["long_name"];
         st3=response["results"][0]["address_components"][0]["long_name"];
         st4=response["results"][0]["address_components"][0]["long_name"];
         placeAddress=st1+","+st2+","+st3+","+st4;
         print(placeAddress);
         Address userPickUpAddress =new Address(null,placeAddress,null,position.latitude,position.longitude);
         userPickUpAddress.longitude=position.longitude;
         userPickUpAddress.latitude=position.latitude;
         userPickUpAddress.placeName=placeAddress;
         Provider.of<AppData>(context,listen: false).updatePickUpLocationAddress(userPickUpAddress);


       }
       return placeAddress;
  }
  static Future<DirectionDetails> obtainPlaceDirectionDetails(LatLng initialPosition,LatLng finalPosition)async{

    String directionUrl="https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=AIzaSyC8Q3CmkYPWju5pL2PaOO-Ipa-1bhJfnuw";
    http.Response response=await RequestAssistant.getRequest(directionUrl);
    if(response.statusCode!=200){
      return null;
    }
    var res=jsonDecode(response.body);
    DirectionDetails directionDetails=DirectionDetails();
   directionDetails.encodedPoints= res["routes"][0]["overview_polyline"]["points"];
    directionDetails.distanceText= res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue= res["routes"][0]["legs"][0]["distance"]["value"];
    directionDetails.durationText= res["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue= res["routes"][0]["legs"][0]["duration"]["value"];
    return directionDetails;
  }


}