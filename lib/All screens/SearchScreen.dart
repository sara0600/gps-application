import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gps_app/Assistants/assistantMethods.dart';
import 'package:gps_app/Assistants/requestAssistant.dart';
import 'package:gps_app/DataHandler/appData.dart';
import 'package:gps_app/DataHandler/position.dart';
import 'package:gps_app/Models/address.dart';
import 'package:gps_app/Models/placePredictions.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart'as http;

import 'package:gps_app/All%20screens/Gps.dart';

import '../configMaps.dart';
class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController dropOffTextEditingController = TextEditingController();
  List<PlacePredictions>placePredictionList=[];
  initState(){
    super.initState();
    getPosition();

  }
  GeolocatorController position=Get.put(GeolocatorController());
  getPosition() async{

    await position.setCurrentLocation();

    await position.getPlaceMark();
  }
  @override
  Widget build(BuildContext context) {
   //String placeAddress = Provider.of<AppData>(context).pickUpLocation.placeName ?? "";
    //pickUpTextEditingController.text = placeAddress;


    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 215.0,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 6.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  left: 25.0, top: 25.0, right: 25.0, bottom: 20.0),
              child: Column(
                children: [
                  SizedBox(height: 5.0),
                  Stack(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back)),
                      Center(
                        child: Text('set drop off', style: TextStyle(
                            fontSize: 18.0
                        ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'assets/pickIcon.jpg', height: 20.0, width: 20.0,),
                      SizedBox(width: 18.0,),
                      Expanded(
                        child:
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(5.0),

                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: Obx(
                                    () {
                                return TextField(
                                  controller: position.pickUpLocationController.value,
                                  decoration: InputDecoration(
                                    hintText: "Pickup location",
                                    fillColor: Colors.grey[400],
                                    filled: true,
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.only(
                                        left: 11.0, top: 8.0, bottom: 8.0),

                                  ),
                                );
                              }
                            ),
                          ),
                        ),
                      ),
                    ],

                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Image.asset('assets/destinationIcon.png', height: 16.0,
                        width: 16.0,),
                      SizedBox(width: 18.0,),
                      Expanded(
                        child:
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(5.0),

                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TextField(
                              onChanged: (val) {
                                findPlace(val);
                              },
                              controller: dropOffTextEditingController,
                              decoration: InputDecoration(
                                hintText: "where to",
                                fillColor: Colors.grey[400],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(
                                    left: 11.0, top: 8.0, bottom: 8.0),

                              ),
                            ),
                          ),
                        ),
                      ),
                    ],

                  ),
                ],
              ),
            ),
          ),
          (placePredictionList.length>0)
              ?Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 16.0),
            child: ListView.separated(
              padding: EdgeInsets.all(0.0),
              itemBuilder: (context,index){
                return PredictionTile(placePredictions: placePredictionList[index],);
              },
              separatorBuilder: (BuildContext context,int index)=> Divider(),
              itemCount: placePredictionList.length,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
            ),
          )
              :Container(),
          ],//tile for displaying predictions        ],
      ),
    );
  }

   findPlace(String placeName) async
  {
    print("ima hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
    if (placeName.length > 1) {
      String autoCompleteUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName=&radius=5000&key=AIzaSyC8Q3CmkYPWju5pL2PaOO-Ipa-1bhJfnuw";
      print("ima hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee2");
      http.Response res = await RequestAssistant.getRequest(autoCompleteUrl);
     // print("this is the result "+res);
      //print("after the resullltttttttttttttttttttttttt");

      if(res.statusCode==200){
        var decodeData=  jsonDecode(res.body);
        if(decodeData["status"]=="OK")
          {
            setState(() {
              placePredictionList = (decodeData["predictions"] as List).map((e) =>
                  PlacePredictions.fromJson(e)).toList();
            });
          }
      }

     else {
      print ("errorrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
      }

      }
    }}
class PredictionTile extends StatelessWidget {
  final PlacePredictions placePredictions;
  PredictionTile({Key key,this.placePredictions}):super(key: key);
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0.0),
      //height: MediaQuery.of(context).size.height,
      onPressed: () { 
        getPlaceAddressDetails(placePredictions.place_id, context);
      },
      child: Container(
        child: Column(
          children: [
            SizedBox(width: 10.0,),
             Row(
              children: [
                Icon(Icons.add_location),
                SizedBox(width: 14.0,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(placePredictions.main_text ?? 'n/a', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16.0),),
                      SizedBox(height: 3.0,),
                      Text(placePredictions.secondary_text ?? 'n/a', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.0, color: Colors.grey),),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(width: 10.0,)
          ],
        ),
      ),
    );
  }

  void getPlaceAddressDetails(String placeId,context) async
  {
  /* showDialog(
      context: context,
        builder:(BuildContext context) => Pro(message:"setting droppoff,please wait",)
    );*/
    String placeDetailsUrl="https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=AIzaSyC8Q3CmkYPWju5pL2PaOO-Ipa-1bhJfnuw";
    http.Response res= await RequestAssistant.getRequest(placeDetailsUrl);
    // Navigator.pop(context);

    if(res.statusCode==200){

      var decodeData=  jsonDecode(res.body);
      if(decodeData["status"]=="OK"){
        print("you entered get place address details  in the status");

         Address address=Address(null,decodeData["result"]["name"],placeId,decodeData["result"]["geometry"]["location"]["lat"],decodeData["result"]["geometry"]["location"]["lng"]);

      print("this this the address"+address.placeName);
          Provider.of<AppData>(context,listen: false).updateDropOffLocationAddress(address);
       print("this is drop off location ::");
       print(address.placeName);

          Navigator.pop(context,"obtainDirection");






      }
    }
    else {
      print ("errooooooooooooooooooooooooooooooooooooooooooooor") ;
    }

  }
}


//}