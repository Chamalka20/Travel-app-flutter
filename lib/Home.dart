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
            'type':result['type'],
          };
        }).toList();
      });

    print(hotelList);
    return results;
  } else {
    throw Exception('Failed to retrieve dataset items status:${datasetItemsResponse.statusCode}');
  }
}

//set categorie list-----------------------------
 late List<Map<String, dynamic>> categorieList = [
    {
      "photo":"assets/images/hotel.png","name":"Hotel"
    },
    {
      "photo":"assets/images/burger.png","name":"Cafes"
    },
    {
      "photo":"assets/images/forest.png","name":"Parks"
    },
    {
      "photo":"assets/images/flash.png","name":"Attractions"
    },
    {
      "photo":"assets/images/gas-pump.png","name":"Gas station"
    },


 ];
 


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
                  padding: const EdgeInsets.only(left:12.0,top:20.0,bottom:15.0),
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
                      Padding(
                        padding: const EdgeInsets.only(left:117,top:3),
                        child: Container(child: Image.asset("assets/images/location.png",width:25,height:25)),
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
                Padding(
                  padding: const EdgeInsets.only(left:13.0,right:6),
                  child: SizedBox(
                    height:45,
                    child: Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal, 
                              itemCount: categorieList.length,
                              itemBuilder: (context, index) {
                                final categorie = categorieList[index];
                                final catName = categorie['name'];
                                final catPhoto = categorie['photo'];
                    
                    
                                  return Card(
                                  elevation: 0,
                                  color:const Color.fromARGB(255, 240, 238, 238),
                                  //clipBehavior: Clip.antiAliasWithSaveLayer,
                                  shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(17.0),
                                        ),
                                  child:Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center, 
                                    children: [
                                      SizedBox(
                                        width: 101,
                                        
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              catPhoto,
                                              width: 23,
                                              height:23,
                                              
                                              
                                            ),
                                            
                                            Padding(
                                              padding: const EdgeInsets.only(left:5.0),
                                              child: FittedBox(
                                                 fit: BoxFit.cover,
                                                child: Text(catName,
                                                      style: GoogleFonts.cabin(
                                                  // ignore: prefer_const_constructors
                                                  textStyle: TextStyle(
                                                  color: const Color.fromARGB(255, 27, 27, 27),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                          
                                                  ) 
                                  )
                                                ),
                                              ),
                                            ),          
                                          ],
                                        ),
                                      ),
                                      
                                    ],
                  
                  
                                  )
                                    
                                    
                                  
                                  ); 
                              },
                            ),
                       
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:14.0,top:16),
                  child: Row(
                    children: [
                      Text("You might like these",
                        style: GoogleFonts.cabin(
                                    // ignore: prefer_const_constructors
                                    textStyle: TextStyle(
                                    color: const Color.fromARGB(255, 27, 27, 27),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                            
                                    ) 
                                  )
                      
                      ),
                
                    ],
                
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:15.0,top:0,bottom: 4),
                  child: Row(
                    children: [
                      Text("Discover more in Sri lanka",
                        style: GoogleFonts.cabin(
                                    // ignore: prefer_const_constructors
                                    textStyle: TextStyle(
                                    color: const Color.fromARGB(255, 143, 142, 142),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                            
                                    ) 
                                  )
                      
                      ),
                
                    ],
                
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:13.0),
                  child: SizedBox(
                  height: 190,
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
                              final address = hotel['address'];
                              final type = hotel['type'];
                  
                                return Card(
                                elevation: 0,
                                color:const Color.fromARGB(255, 240, 238, 238),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                child:Container(
                                  width: 230,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 230,
                                            height: 120,
                                            
                                                decoration:  BoxDecoration(
                                                  
                                                  image: DecorationImage(
                                                    image: NetworkImage(photoUrl,),
                                                    fit: BoxFit.fill,
                                                    
                                              
                                                      ),
                                                  
                                                  ),
                                             child: Column(
                                               children: [
                                                 Row(
                                                   children: [
                                                     Padding(
                                                       padding: const EdgeInsets.all(6.0),
                                                       child: SizedBox(
                                                         
                                                         height:25,
                                                          
                                                         child: Card(
                                                             elevation: 0,
                                                              color:const Color.fromARGB(200, 240, 238, 238),
                                                              clipBehavior: Clip.antiAliasWithSaveLayer,
                                                              shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(5.0),
                                                                    ),
                                                            child: FittedBox(
                                                                    fit: BoxFit.cover,
                                                                    child:Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: Text('$type',
                                                                        style: GoogleFonts.cabin(
                                                                          // ignore: prefer_const_constructors
                                                                          textStyle: TextStyle(
                                                                          color: Color.fromARGB(255, 95, 95, 95),
                                                                          fontSize: 24,
                                                                          fontWeight: FontWeight.bold,
                                                                                                                                    
                                                                          ) 
                                                                        )
                                                                                                                                      
                                                                                                                                      ),
                                                                    ), 
                                                              )
                                                            
                                                         ),
                                                       ),
                                                     ),

                                                     Padding(
                                                       padding: const EdgeInsets.only(left:108,top:5),
                                                       child: SizedBox(
                                                          width:37,
                                                          height:37,
                                                          child: Card(
                                                             elevation: 0,
                                                                color:const Color.fromARGB(200, 240, 238, 238),
                                                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                                                shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(50.0),
                                                                      ),
                                                                child:Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        Image.asset("assets/images/heart.png",width:18,height:18),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),  
                                                     
                                                          ),
                                                     
                                                       ),
                                                     ),

                                                   ],
                                                 ),
                                               ],
                                             ), 
                                              
                                            
                                          ),
                                      
                                                
                                        ],
                                      ),
                                      Row(
                                        
                                        children: [
                                            SizedBox(
                                            width: 190,
                                            height:30,
                                              child: Padding(
                                                padding: const EdgeInsets.only(left:6,top:5),
                                                child: Text(hotelName,
                                                
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.cabin(
                                                    // ignore: prefer_const_constructors
                                                    textStyle: TextStyle(
                                                    color: const Color.fromARGB(255, 27, 27, 27),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                                                    
                                                    ) 
                                                  )
                                                                                        
                                                ),
                                              ),
                                            ),

                                          Image.asset("assets/images/star.png",width:14,height:14),
                                          Padding(
                                            padding: const EdgeInsets.only(left:4),
                                            child: Text("$hotelRating",
                                                 style: GoogleFonts.cabin(
                                              // ignore: prefer_const_constructors
                                              textStyle: TextStyle(
                                              color: const Color.fromARGB(255, 27, 27, 27),
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                                                              
                                              ) 
                                            )
                                            
                                            ),
                                          ),  
                                        ],
                                      
                                      ),
                                      Row(
                                       
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left:4),
                                            child: Image.asset('assets/images/location.png',width:15,height:15),
                                          ),
                                          SizedBox(
                                            width:200,
                                            height:7,
                                            child: Text(address,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.cabin(
                                                // ignore: prefer_const_constructors
                                                textStyle: TextStyle(
                                                color: Color.fromARGB(255, 94, 94, 94),
                                                fontSize: 7,
                                                fontWeight: FontWeight.bold,
                                                                                
                                                ) 
                                              )
                                            
                                            
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                                
                                                
                                  ),
                                )
                                  
                                  
                                
                                ); 
                            },
                          ),
                    
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