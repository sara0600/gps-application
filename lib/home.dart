import 'dart:async';
import 'dart:collection';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get_rx/get_rx.dart';

class Home extends StatefulWidget {
  // static const String idScreen='gps';
  @override
  _HomeState createState() => _HomeState();
}
var myMarkers=HashSet<Marker>();
List<Polyline>myPolyline=[];



class _HomeState extends State<Home> {
  RxString getAddressName=''.obs;
  LatLng p;
  double bottomPadding =0;
  Completer<GoogleMapController>_controllerGoogleMap= Completer();
  Position currentPosition;
  var geoLocator=Geolocator();
  GoogleMapController newGoogleMapController;



  void locatePosition() async{
    //to get the current location of the user
    Position position= await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition=position;

    LatLng latLatPosition=LatLng(position.latitude, position.longitude);
    p=latLatPosition;
    CameraPosition cameraPosition=new CameraPosition(target: latLatPosition,zoom: 14);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    await getPlaceMark();
  }
  Future<void> getPlaceMark()async{

    List<Placemark> placemarks;
    try{
      placemarks=await placemarkFromCoordinates(p.latitude, p.longitude);
      getAddressName.value=placemarks[0].name+placemarks[0].country;
      print('ur location is$getAddressName');

    }
    catch(e){
      placemarks=[
        Placemark(locality:'no address found')
      ];
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createPolyline();
    locatePosition();
  }
  createPolyline(){
    myPolyline.add(Polyline(
        polylineId: PolylineId('1'),
        color: Colors.black,
        width: 7,
        points: [
          LatLng(29.850587146852398, 31.342468592214612),
          LatLng(29.851024499780586, 31.33495840746004)
        ],
        patterns: [
          PatternItem.dash(20),
          PatternItem.gap(10),
        ]

    ),);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('google maps'),),
      body:Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPadding),
            myLocationButtonEnabled: true,
            initialCameraPosition:
            CameraPosition(
              target:LatLng(30.008483009308286, 31.429623606269818),
              zoom: 15,
            ),
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            onMapCreated:(GoogleMapController controller){
              setState(() {
                bottomPadding=  300.0;
              });
              _controllerGoogleMap.complete(controller);
              newGoogleMapController=controller;
              print('before function');
              locatePosition();
              print('after function');
            },
            // markers: myMarkers,
            // polylines: myPolyline.toSet(),
          ),
          Positioned(
            left:0.0,
            right:0.0,
            bottom:0.0,
            child: Container(
                height:245.0,
                decoration:BoxDecoration(
                    color:Colors.white,
                    borderRadius:BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 16.0,//the width of the shadow
                        spreadRadius: 0.5,//how darker the color is
                        offset: Offset(0.7,0.7),
                      )
                    ]
                ),
                child:Column(
                  children: [
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                          height: 70,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            //borderRadius: BorderRadius.circular(10),
                            color: Colors.black12,


                          ),
                          child:Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "where to?",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize:25,
                                    fontFamily:"Brand.Bold",
                                  ),
                                ),

                              ],
                            ),
                          )

                      ),
                    )
                  ],
                )
            ),
          ),

        ],


      ),
    );


  }
}
/*

//inside the onMapCreated function
setState(() {
myMarkers.add(Marker(
markerId:MarkerId('1'),
position:LatLng(29.850587146852398, 31.342468592214612),
infoWindow: InfoWindow(
title: "faculty of engineering helwan university",
)
),
);
myMarkers.add(Marker(
markerId:MarkerId('2') ,
position: LatLng(29.851024499780586, 31.33495840746004),
infoWindow: InfoWindow(
title: "alkhubz alzahaby",
),
onTap: (){
setState(() {
print('10 minutes to reach');
});
}
));
myMarkers.add(Marker(
markerId: MarkerId('3'),
position: LatLng(30.0444, 31.2357),

));
});

 */