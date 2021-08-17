import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_google_places/flutter_google_places.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // location
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final la = TextEditingController();
  final lo = TextEditingController();
  var result=" ";

  var locationMessage = '';
  var latitude;
  var longitude;
  var _address;
  var _places;
  var cals=" ";
  String geofence='';
  // Future<Null> displayPrediction(Prediction p) async {
  //   if (p != null) {
  //     PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);

  //     var placeId = p.placeId;
  //      var lat = detail.result.geometry.location.lat;
  //      var long = detail.result.geometry.location.lng;

  //     var address  =detail.result.formattedAddress;

  //     print(lat);
  //     print(long);
  //     print(address);

  //     setState(() {
  //       _address.text = address;
  //     });
  //   }
  // }

  // function for getting the current location
  // but before that you need to add this permission!
  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }
  void results(){
    setState(() {
      result="LA=:${la.text} and Lo ${lo.text}";

    });
  }
  void cal(){
    var temp=calculateDistance(double.parse(la.text), double.parse(lo.text), latitude, longitude);
    temp=double.parse(temp.toStringAsFixed(2));

    cals="Distance is $temp km";
    if(temp>50){
      geofence="Outside the Radius";

    }
    else{
      geofence="Inside the Radius";
    }
  }
  void getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var lat = position.latitude;
    var long = position.longitude;

    // passing this to latitude and longitude strings
    latitude = lat;
    longitude = long;

    setState(() {
      locationMessage = "Latitude: ${lat} and Longitude: ${long}";
    });
  }


  // function for opening it in google maps

  void googleMap() async {
    String googleUrl =
        "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";

    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else
      throw ("Couldn't open google maps");
  }
  void initState(){
    Timer.periodic(new Duration(seconds: 3), (timer) {
      getCurrentLocation();
      cal();

    });

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User location application',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                new Image.asset('assets/Google map animation.gif'

                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Get User Location",
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Text(
                  locationMessage,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                // GestureDetector(
                //   onTap: (){
                //     getCurrentLocation();

                //   },
                //   // child: Container(
                //   //   width: 100,
                //   //   height: 30,
                //   //   decoration: BoxDecoration(
                //   //     color: Colors.blue[900],
                //   //     borderRadius: BorderRadius.circular(4)
                //   //   ),
                //   //   child: Center(child: Text("Get location",style: TextStyle(color:Colors.white),)),
                //   // ),
                // ),
                SizedBox(height: 30.0,),
                Text(
                  cals,
                  style: TextStyle(
                    color: Colors.black,
                  ),

                ),
                SizedBox(height: 5,),
                Text(geofence,style: TextStyle(color:Colors.green,fontWeight: FontWeight.bold),),


                SizedBox(height: 30.0,),
                // button for taking the location
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SizedBox(width: 10.0),
                    Expanded(
                      // optional flex property if flex is 1 because the default flex is 1

                      child: TextField(
                        decoration: InputDecoration(
                            labelText: 'longitude',
                            labelStyle: TextStyle(
                                color: Colors.grey[400]
                            )
                        ),
                        controller: lo,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Expanded(

                      // optional flex property if flex is 1 because the default flex is 1

                      child: TextField(

                        decoration: InputDecoration(
                            labelText: 'latitude',
                            labelStyle: TextStyle(
                                color: Colors.grey[400]
                            )
                        ),
                        controller: la,
                      ),
                    ),
                    SizedBox(width: 10.0),
                  ],
                ),
                SizedBox(height: 10,),
                FlatButton(
                  color: Colors.blueAccent,
                  onPressed: () {
                    googleMap();
                  },
                  child: Text("Open GoogleMap"),
                ),
                // GestureDetector(
                //   onTap: (){
                //     results();
                //   },
                //   child:Container(
                //     decoration: BoxDecoration(
                //     color: Colors.blue[900],
                //     borderRadius: BorderRadius.circular(5)

                //     ),
                //     width:100,
                //     height:30,
                //     child:Center(child: Text("calculate",style: TextStyle(color:Colors.white),))
                //   )
                // ),


                // TextFormField(
                //     decoration: new InputDecoration(
                //         border: InputBorder.none,
                //         contentPadding: EdgeInsets.only(left: 15),
                //         // hintText: String.enter_your_house_number_street_etc,
                //         hintStyle: TextStyle(
                //             fontSize: 14,
                //             color: Colors.grey,
                //             fontFamily: "Open Sans",
                //             fontWeight: FontWeight.normal
                //         )),
                //     maxLines: 1,
                //     controller: _address,
                //   onTap: ()async{
                //     // then get the Prediction selected
                //     Prediction p = await PlacesAutocomplete.show(
                //         context: context, apiKey: kGoogleApiKey,
                //     onError: onError);
                //     displayPrediction(p);
                //   },
                //   )
              ],
            ),
          ),
        ),
      ),
    );
  }
}