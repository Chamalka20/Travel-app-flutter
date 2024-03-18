// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
 
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:google_fonts/google_fonts.dart' ;
import 'package:location/location.dart' ;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'customPageRoutes.dart';
import 'navigationPage.dart';

Future<String?> getLocation() async {
  Location location = Location();
 

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData? _locationData;

  // Check if location services are enabled
  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return null;
    }
  }

  // Check if location permission is granted
  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }

  // Get the current location
  _locationData = await location.getLocation();
  // ignore: unnecessary_null_comparison
  if (_locationData == null) {
    return null;
  }
  //store current lat.lon --------------------------------------------------
  final prefs = await SharedPreferences.getInstance();
  final currentLocation = jsonEncode({"lat":'${_locationData.latitude}',"lng":'${_locationData.longitude}'});
  prefs.setString('currentLocation', currentLocation );

  print(_locationData.latitude,);
  print(_locationData.longitude,);
  // Fetch the country based on the latitude and longitude
  List<Placemark> placemarks = await placemarkFromCoordinates(
    _locationData.latitude!,
    _locationData.longitude!,
  );

  if (placemarks.isEmpty) {
    return null;
  }

  String cityName = placemarks.first.locality ?? '';
  prefs.setString('currentCity', cityName );
  
  return cityName;
}



class letsStart extends StatefulWidget {
  const letsStart({super.key});

  @override
  State<letsStart> createState()  => _MyWidgetState();
}

class _MyWidgetState extends State<letsStart> {
  @override
  Widget build(BuildContext context) {
     return WillPopScope(
      onWillPop: () async {
        bool confirmExit = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Confirm Exit'),
                content: Text('Are you sure you want to exit the app?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      // User confirmed exit
                       SystemNavigator.pop();
                    },
                    child: Text('Yes'),
                  ),
                  TextButton(
                    onPressed: () {
                      // User canceled exit
                      Navigator.of(context).pop(false);
                    },
                    child: Text('No'),
                  ),
                ],
              );
            },
          );

          return confirmExit;
        
      },
        child:GestureDetector(
        onTap: () {
          // Dismiss the keyboard when the user taps outside of the text fields 
          FocusScope.of(context).unfocus();
          
        },
        child:Scaffold(
          body: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top:80),
                  child: SizedBox(
                    height: 250,
                    width:300,
                    child: Lottie.asset("assets/images/143784-checklist.json",
                      repeat: false,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:15),
                      child: Text("Let's get started",
                        style: GoogleFonts.lato(
                            // ignore: prefer_const_constructors
                            textStyle: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                                  
                            ) 
                          )
                      
                      ),
                    )
                  ],


                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:15),
                      child: Text("your journey",
                        style: GoogleFonts.lato(
                            // ignore: prefer_const_constructors
                            textStyle: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                                  
                            ) 
                          )
                      
                      ),
                    )
                  ],


                ),
                Row(
                    children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0,top: 20.0),
                          child: SizedBox(
                              width: 320,
                              height: 45,
                              child: TextButton(
                                onPressed: () async {
                                  String? cityName = await getLocation();

                                  if(cityName != null){

                                  print('Current city: $cityName');

                                  Navigator.of(context).pushReplacement(customPageRoutes(
                
                                    child: navigationPage(isBackButtonClick:false,autoSelectedIndex: 0,)));

                                  }else{
                                    print('Unable to fetch the current country');
                                  }

                                  
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromARGB(255, 0, 0, 0),
                                  foregroundColor:Color.fromARGB(255, 177, 152, 152),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20), // Set the radius here
                                    ),
                                  
                                ),
                                child: Text('Track location automatically',
                                    style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        
                                
                                    ),
                                
                                ),
                              ),
                            ),
                        ),

                    ],


                  ),
                  Row(
                    children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0,top: 20.0),
                          child: SizedBox(
                              width: 320,
                              height: 45,
                              child: TextButton(
                                onPressed: () {
                                      print("jhiuhiuujj");
                                  
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                                  foregroundColor:Color.fromARGB(255, 0, 0, 0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20), 
                                    ),
                                  
                                ),
                                child: Text('Choose location',
                                    style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        
                                
                                    ),
                                
                                ),
                              ),
                            ),
                        ),

                    ],


                  )


              ],
            ),
            
          ),
          )
        )
    );
  }
}