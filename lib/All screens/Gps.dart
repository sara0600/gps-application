import 'dart:async';
import 'dart:collection';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart'as geo2;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart'as geo;
import 'package:get_rx/get_rx.dart';
import 'package:gps_app/All%20screens/SearchScreen.dart';
import 'package:gps_app/Assistants/assistantMethods.dart';
import 'package:gps_app/DataHandler/appData.dart';
import 'package:gps_app/DataHandler/position.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

//import 'package:google_maps_controller/google_maps_controller.dart';
//import 'package:get/get.dart';

class Gps extends StatefulWidget {
  static const String idScreen = 'gps';

  @override
  _GpsState createState() => _GpsState();
}

var myMarkers = HashSet<Marker>();
List<Polyline> myPolyline = [];
Completer<GoogleMapController> _controller = Completer();

class _GpsState extends State<Gps> {


  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polylineSet = {};
  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  GeolocatorController position = Get.put(GeolocatorController());

  getPosition() async {
    await position.setCurrentLocation();

    await position.getPlaceMark();
  }

  geo2.Position currentLocation =geo2.Position(
    longitude: 0.0,
    latitude: 0.0,
    timestamp: DateTime.now(),
    accuracy: 0.0,
    altitude: 0.0,
    heading: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0,
  );
  LocationData currentLoc;

  String getAddressName = '';
  LatLng p;
  double bottomPadding = 0;
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  geo2.Position currentPosition;
  var geoLocator =geo2.Geolocator();
  GoogleMapController newGoogleMapController;

  Future<geo2.Position> getCurrentLocation() async {
    Location location=Location();

    location.getLocation().then(
        (location){
          currentLoc=location;
        },
    );
    GoogleMapController googleMapController=await _controller.future;
    location.onLocationChanged.listen(
            (newLoc) {

              currentLoc=newLoc ;
              print(currentLocation);
              googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                  zoom:16,
                  target: LatLng(

                  newLoc.latitude,
                      newLoc.longitude,
                  )),
              ),
              );
               setState(() {

               });
    },);


    return await geo2.Geolocator.getCurrentPosition(
       desiredAccuracy:geo2.LocationAccuracy.high);
  }

  setCurrentLocation() async {
    currentLocation = await getCurrentLocation();
    print('Current location : ${currentLocation}');
    await getPlaceMark();
  }

  void locatePosition() async {
//to get the current location of the user
    geo2.Position position = await geo2.Geolocator.getCurrentPosition(
        desiredAccuracy:geo2.LocationAccuracy.high);
    currentPosition = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);
    p = latLatPosition;
    CameraPosition cameraPosition =
        new CameraPosition(target: latLatPosition, zoom: 14);
    final GoogleMapController newGoogleMapController = await _controller.future;
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    String address =
        await AssistantMethods.searchCoordinateAddress(position, context);
    print("this is your address ::" + address);
    await getPlaceMark();
  }

  setManualLocation(LatLng latlng) async {
    setState(() {
      currentLocation = geo2.Position(
        longitude: latlng.longitude,
        latitude: latlng.latitude,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
      );
    });

    await getPlaceMark();
  }

  Future<void> getPlaceMark() async {
    List<geo.Placemark> placemarks;
    try {
      placemarks = await geo.placemarkFromCoordinates(
          currentLocation.latitude, currentLocation.longitude);

      setState(() {
        getAddressName =
            '${placemarks[0].name} , ${placemarks[0].country} , ${placemarks[0].locality} , ${placemarks[0].street}';
        print('your Locaaaaaation :: $getAddressName');
      });
    } catch (e) {
      placemarks = [
        geo.Placemark(locality: 'لا يوجد عنوان'),
      ];
    }
  }

  @override
  void initState() {
// TODO: implement initState
    getPosition();
    setCurrentLocation();
    getCurrentLocation();
    super.initState();
    createPolyline();
    locatePosition();
  }

  createPolyline() {
    myPolyline.add(
      Polyline(
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
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getAddressName),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (mapController) {
              _controller.complete(mapController);
            },

            polylines: polylineSet,
            mapToolbarEnabled: true,

            //zoomGesturesEnabled: false,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            onTap: (latlng) {
              setManualLocation(latlng);
              setState(() {});
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(
                currentLocation.latitude,
                currentLocation.longitude,
              ),
              zoom: 4,
            ),
            // mapType: MapType.normal,
            markers:
              markersSet,


           // circles: circlesSet,
            /* {
   Marker(
    draggable: true,
    onDrag: (latlng) {
     setManualLocation(latlng);
     setState(() {});
    },
    onDragStart: (latlng) {
     setManualLocation(latlng);
     setState(() {});
    },
    onDragEnd: (latlng) {
     setManualLocation(latlng);
     setState(() {});
    },
    position: LatLng(
     currentLocation.latitude,
     currentLocation.longitude,
    ),
    markerId: MarkerId('1'),
    icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueOrange),
   ),
  },*/
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
                height: 245.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 16.0, //the width of the shadow
                        spreadRadius: 0.5, //how darker the color is
                        offset: Offset(0.7, 0.7),
                      )
                    ]),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: GestureDetector(
                        onTap: () async {
                          var res = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchScreen()));
                          //   Navigator.push<String>(context,MaterialPageRoute(builder: (context)=>SearchScreen())).then((value)async {print("before the button function");
                          if (res == "obtainDirection") {
                            print("this is the button function");
                            await getPlaceDirection();
                          }
                          // } );
                        },
                        child: Container(
                            height: 70,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12),

                              //borderRadius: BorderRadius.circular(10),

                              color: Colors.black12,
                            ),
                            child: Padding(
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
                                    "where to"
                                    //Provider.of<AppData>(context).pickUpLocation!=null
                                    //?Provider.of<AppData>(context).pickUpLocation.placeName:"add home"
                                    ,
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 15,
                                      fontFamily: "Brand.Bold",
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Future<void> getPlaceDirection() async {
    print("yo reached get place direction");

    var initialPos =currentLoc;
    // Provider.of<AppData>(context,listen:false).pickUpLocation;
    print("this is the initial pos  $initialPos");
    var finalPos = Provider.of<AppData>(context, listen: false).dropOffLocation;
    print(
        "this is the final pos  ${finalPos.latitude}   ${finalPos.longitude}");
    var pickUpLatlng = LatLng(initialPos.latitude, initialPos.longitude);
    var droppOffLatlng = LatLng(finalPos.latitude, finalPos.longitude);
    var details = await AssistantMethods.obtainPlaceDirectionDetails(
        pickUpLatlng, droppOffLatlng);
//  Navigator.pop(context);
    print("this is the encoded points ::");
    print(details.encodedPoints);
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolylinePointsResult =
        polylinePoints.decodePolyline(details.encodedPoints);
    pLineCoordinates.clear();
    if (decodedPolylinePointsResult.isNotEmpty) {
      decodedPolylinePointsResult.forEach((PointLatLng pointLatLng) {
        pLineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    polylineSet.clear();
    Polyline polyline = Polyline(
      color: Colors.blue,
      polylineId: PolylineId("polylineId"),
      jointType: JointType.round,
      points: pLineCoordinates,
      width: 5,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      geodesic: true,
    );
    print("this is the polyline set");

    if (mounted) {
      setState(() {
        polylineSet.add(polyline);
      });
    }
    print("this is the polyline set2");
    LatLngBounds latLngBounds;
    if (pickUpLatlng.latitude > droppOffLatlng.latitude &&
        pickUpLatlng.longitude > droppOffLatlng.longitude) {
      latLngBounds =
          LatLngBounds(southwest: droppOffLatlng, northeast: pickUpLatlng);
    } else if (pickUpLatlng.longitude > droppOffLatlng.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(pickUpLatlng.latitude, droppOffLatlng.longitude),
          northeast: LatLng(droppOffLatlng.latitude, pickUpLatlng.longitude));
    } else if (pickUpLatlng.latitude > droppOffLatlng.latitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(droppOffLatlng.latitude, pickUpLatlng.longitude),
          northeast: LatLng(pickUpLatlng.latitude, droppOffLatlng.longitude));
    } else {
      latLngBounds =
          LatLngBounds(southwest: pickUpLatlng, northeast: droppOffLatlng);
    }
    print(latLngBounds);
    print("this is the lat lng bounds");
    final GoogleMapController newGoogleMapController = await _controller.future;
    newGoogleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70.0));
    print("after google map");
    Marker  pickUpLocMarker =  Marker(
     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      infoWindow: InfoWindow(title: "", snippet: "my location"),
      position: pickUpLatlng,
      markerId: MarkerId("pickUpId"),
    );
    Marker dropOffLocMarker =  Marker(
    //  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow:
          InfoWindow(title: finalPos.placeName, snippet: "dropOff location"),
      position: droppOffLatlng,
      markerId: MarkerId("dropOffId"),
    );
   Marker currentLocation= Marker(
       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        markerId: const MarkerId("currentLocation"),
        position: LatLng(currentLoc.latitude,currentLoc.longitude)
    );

    if (mounted) {
      setState(() {
        markersSet.add(pickUpLocMarker);
        markersSet.add(dropOffLocMarker);
        markersSet.add(currentLocation);
        print("we are almost there");
      });
    }
    /*Circle pickUpLocCircle = Circle(
      fillColor: Colors.black12,
      center: pickUpLatlng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.black,
      circleId: CircleId("pickUpId"),
    );
    Circle droppOffLocCircle = Circle(
      fillColor: Colors.black12,
      center: droppOffLatlng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.black,
      circleId: CircleId("dropOffId"),
    );
    if (mounted) {
      setState(() {
        circlesSet.add(pickUpLocCircle);
        circlesSet.add(droppOffLocCircle);
      });
    }*/
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

 */ /*
GoogleMap(
padding: EdgeInsets.only(bottom: bottomPadding),
myLocationButtonEnabled: true,
initialCameraPosition:
CameraPosition(
target:
LatLng(30.008483009308286, 31.429623606269818),
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
),*/
