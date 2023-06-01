import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class home extends StatefulWidget {

   const home({super.key});

  @override
  State<home> createState() => _homeState();



}

class _homeState extends State<home> {

  late List<Map<String, dynamic>> hotelList = [];
  String nextPageToken ='';
  @override
  void initState() {
    super.initState();
    fetchHotels();
  }

  Future<void> fetchHotels() async {

  const apiKey = 'apify_api_Ji36tnDOBH9eVjhgk2inWHfV57BIKr328Ogj';
  var apiUrl = 'https://api.apify.com/v2/acts/maxcopell~free-tripadvisor/runs?token=$apiKey'; 
  late List<Map<String, dynamic>> hotelList;

 final payload = {
    "currency": "USD",
    "debugLog": false,
    "includeAttractions": true,
    "includeHotels": true,
    "includeRestaurants": true,
    "includeReviews": true,
    "includeTags": true,
    "language": "en",
    "locationFullName": "Colombo, Sri Lanka", // Replace with your desired location
    "maxItems": 39,
    "maxReviews": 20,
    "proxyConfiguration": {
      "useApifyProxy": true
    },
    "scrapeReviewerInfo": true
  };

   final response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode(payload),
  );




  if (response.statusCode == 201) {
    // Request successful
    print("Request successful status:${response.statusCode}");
    final decodedData = json.decode(response.body);
    final runId = decodedData["data"]["id"];
    print(runId);

    await waitForDataset (runId);



    // print(results);
    //  setState(() {
    //     hotelList = results.map((result) {
    //       return {
    //         'name': result['name'],
    //         'formatted_address': result['formatted_address'],
    //         'rating': result['rating'],
    //       };
    //     }).toList();
    //   });
   
    
  } else {
    // Request failed
    print('Request failed with status: ${response.statusCode}.');
  }

  
}

Future<void> waitForDataset(String runId) async {
  const delayDuration = Duration(seconds: 2); 
  bool datasetReady = false;
  const apiKey = 'apify_api_Ji36tnDOBH9eVjhgk2inWHfV57BIKr328Ogj';

  // ignore: unrelated_type_equality_checks
  while (datasetReady == false) {
    await Future.delayed(delayDuration);

    final datasetStatusResponse = await http.get(Uri.parse('https://api.apify.com/v2/actor-runs/$runId?token=$apiKey'));
    if (datasetStatusResponse.statusCode == 200) {
      final datasetStatusData = json.decode(datasetStatusResponse.body);
      final datasetStatus = datasetStatusData['data']['status'];
      
      print(datasetStatus);  
      if (datasetStatus == 'SUCCEEDED') {
        datasetReady = true;
        final keyValue = datasetStatusData['data']['defaultDatasetId'];
        print(keyValue);
        final datasetItems = await getDatasetItems(keyValue);
      }
    }
  }
}

Future<List<dynamic>> getDatasetItems(String keyValue) async {
  const apiKey = 'apify_api_Ji36tnDOBH9eVjhgk2inWHfV57BIKr328Ogj';
  final datasetItemsResponse = await http.get(Uri.parse('https://api.apify.com/v2/datasets/$keyValue/items?token=$apiKey'));
  if (datasetItemsResponse.statusCode == 200) {

    print("Request successful status:${datasetItemsResponse.statusCode}");
    final datasetItemsData = json.decode(datasetItemsResponse.body);
    final results = datasetItemsData as List<dynamic>;
    print(results.length);

     setState(() {
        hotelList = results.map((result) {
          return {
            'name': result['name'],
            'image': result['image'],
            'rating': result['rating'],
            'address':result['address'],
          };
        }).toList();
      });

    print(hotelList);
    return results;
  } else {
    throw Exception('Failed to retrieve dataset items status:${datasetItemsResponse.statusCode}');
  }
}


  @override
  Widget build(BuildContext context) {
     return WillPopScope(
      onWillPop: () async {
        bool confirmExit = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Confirm Exit'),
                content: const Text('Are you sure you want to exit the app?'),
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
                                    color: const Color.fromARGB(255, 27, 27, 27),
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
                                      color: const Color.fromARGB(255, 143, 142, 142),
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
                            cacheExtent: 9999,
                            scrollDirection: Axis.horizontal, 
                            itemCount: hotelList.length,
                            itemBuilder: (context, index) {
                              final hotel = hotelList[index];
                              final hotelName = hotel['name'];
                              final hotelRating = hotel['rating'];
                              final photoUrl = hotel['image'];
                 
                 
                               return Card(
                                elevation: 0,
                                color:const Color.fromARGB(255, 240, 238, 238),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
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
                                         Container(
                                          width: 200,
                                           child: Text(hotelName,
                                            overflow: TextOverflow.ellipsis,
                                           ),
                                         ),
                                         
                                      ],
                                    
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          
                                          child: Text('Rating: $hotelRating')
                                          ),
                                      ],
                                    )
                                  ],


                                )
                                  
                                  
                                
                               ); 
                            },
                          ),
                   
                         ),
                 ),

               Row(
                children: [

                  ElevatedButton(onPressed: () {
                                     
                                  
                                }, child: Text("get"))
                  
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