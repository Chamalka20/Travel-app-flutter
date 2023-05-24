import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Google_signin.dart';
import 'Welcomepage.dart';

class home extends StatefulWidget {

   const home({super.key});

  @override
  State<home> createState() => _homeState();



}

class _homeState extends State<home> {

  late List<Map<String, dynamic>> hotelList = [];
  
  @override
  void initState() {
    super.initState();
    fetchHotels();
  }

  Future<void> fetchHotels() async {
  const apiKey = 'AIzaSyBEs5_48WfU27WnR6IagbX1W4QAnU7KTpo';
  const query = 'hotels in sri lanka';
  const apiUrl =
      'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&key=$apiKey';

  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    // Request successful
    final decodedData = json.decode(response.body);
    print("Request successful status:${response.statusCode}");
    final results = decodedData['results'] as List<dynamic>;
     print(decodedData);
      setState(() {
        hotelList = results.map((result) {

          final photos = result['photos'] as List<dynamic>;
          final firstPhotoReference = photos.isNotEmpty ? photos[0]['photo_reference'] : '';

          return {
            'name': result['name'],
            'rating': result['rating'],
            'photo_reference': firstPhotoReference,
           
          };
        }).toList();
        
      }); 
  } else {
    // Request failed
    print('Request failed with status: ${response.statusCode}.');
  }
}

String getPhotoUrl(String photoReference) {
    if (photoReference.isEmpty) {
      // Return a placeholder image URL if no photo reference is available
      return 'https://via.placeholder.com/150';
    }

    const apiKey = 'AIzaSyBEs5_48WfU27WnR6IagbX1W4QAnU7KTpo'; 
    final maxWidth = 400; 
    final apiUrl =
        'https://maps.googleapis.com/maps/api/place/photo?maxwidth=$maxWidth&photoreference=$photoReference&key=$apiKey';

    return apiUrl;
  }

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

          return confirmExit ;
        
      }, 
    
      child:Scaffold(
        body:SafeArea(
          child:Center(
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left:12.0,top:20.0),
                  child: Row(
                    
                    children: [
                      
                      Text("Hi Nimal",
                         style: GoogleFonts.cabin(
                                    // ignore: prefer_const_constructors
                                    textStyle: TextStyle(
                                    color: Color.fromARGB(255, 27, 27, 27),
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                            
                                    ) 
                                  )
                      
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left:115.0,top:7.0),
                        child: Icon(Icons.location_on,color: Color.fromARGB(255, 143, 142, 142),),
                      ),
                       Padding(
                         padding: const EdgeInsets.only(top:9.0),
                         child: Text("Sri lanka",
                           style: GoogleFonts.cabin(
                                      // ignore: prefer_const_constructors
                                      textStyle: TextStyle(
                                      color: Color.fromARGB(255, 143, 142, 142),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w300,
                              
                                      ) 
                                    )
                                             
                              ),
                       ),
                      
                    ],

                  ),

                ),

                 SizedBox(
                  height: 150,
                   child: Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal, 
                            itemCount: hotelList.length,
                            itemBuilder: (context, index) {
                              final hotel = hotelList[index];
                              final hotelName = hotel['name'];
                              final hotelRating = hotel['rating'];
                              final photoReference = hotel['photo_reference'];
                              final photoUrl = getPhotoUrl(photoReference);
                 
                 
                               return Card(
                                elevation: 0,
                                color:Color.fromARGB(255, 247, 245, 245),
                                child:Column(
                                  children: [
                                    Row(
                                      children: [
                                        Image.network(
                                          photoUrl,
                                          width: 200,
                                          height: 100,
                                          fit: BoxFit.fill,
                                        ),
                                   

                                      ],
                                    ),
                                    Row(
                                      children: [
                                         Text(hotelName),
                                         
                                      ],

                                    ),
                                    Row(
                                      children: [
                                        Text('Rating: $hotelRating'),
                                      ],
                                    )
                                  ],


                                )
                                  
                                  
                                //   child: Column(
                                //     crossAxisAlignment: CrossAxisAlignment.start,
                                //     children: [
                                //       if (photoUrl != null)
                                //         Image.network(
                                //           photoUrl,
                                //           width: 200,
                                //           height: 100,
                                //           fit: BoxFit.fill,
                                //         ),
                                //       Text(hotelName),
                                //       Text('Rating: $hotelRating'),
                                //     ],
                                //   ),
                 
                                  
                                // )
                               ); 
                            },
                          ),
                   
                         ),
                 ),

               Row(
                children: [

                  Text("gdfgdfghfg")
                  
                ],


               ), 

              ],
              
            ),

          ),
          
          ),
        )
      )
     ); 
  }
}