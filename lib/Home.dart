import 'dart:convert';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelapp/fechApiData.dart';
import "package:travelapp/fechLastViews.dart";

class home extends StatefulWidget {

  final bool isBackButtonClick;
  
  const home({required this.isBackButtonClick, Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState(isBackButtonClick);


}

class _homeState extends State<home> {

  late List<Map<String, dynamic>> hotelList = [];
  late List<Map<String, dynamic>> lastViewsList = [];
  late List<Map<String, dynamic>> myLocationList = [];
  bool isBackButtonClick;
  String nextPageToken ='';
  
  
  _homeState(this.isBackButtonClick);

  @override
  void initState(){
     super.initState();
    //get data list from api-------------------------------
     getData();
     setMainName();
  }

  Future <void> setMainName()async{

    
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

 void getData () async{
     
    
    var apiUrl1 = 'https://api.apify.com/v2/actor-tasks/detailed_camel~google-maps-scraper-task/runs?token=';
    var apiUrl2 ='https://api.apify.com/v2/acts/maxcopell~free-tripadvisor/runs?token=';
    final payload1 = {};
    final payload2 ={
    "currency": "USD",
    "debugLog": false,
    "includeAttractions": true,
    "includeHotels": false,
    "includeRestaurants": true,
    "includeReviews": false,
    "includeTags": true,
    "language": "en",
    "locationFullName": "Hambantota, Sri Lanka",
    "maxItems": 20,
    "maxReviews": 20,
    "proxyConfiguration": {
        "useApifyProxy": true
    },
    "scrapeReviewerInfo": false
};

final payload3 = {
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
    
    
    //myLocationList= await fechApiData.fetchSuggestions(apiUrl2,payload2);

    
    
    if(lastViewsList.isEmpty && isBackButtonClick == false){

   
    hotelList = await fechApiData.fetchSuggestions(apiUrl2,payload3);
    lastViewsList = await fechLastViews.fetchSuggestions(apiUrl1,payload1);
    
      if (lastViewsList.isNotEmpty ){
        final prefs = await SharedPreferences.getInstance();
        //store last views------------------
        final  lastViweListArray = jsonEncode( lastViewsList);
        prefs.setString('lastViweListArray', lastViweListArray);

        //store hotel list ------------------------
        final  hotelListArray = jsonEncode( hotelList);
        prefs.setString('hotelListListArray', hotelListArray);



        setState(() {
         buildBody();
        });

        

      }
    
      
     

    }else if(lastViewsList.isEmpty && isBackButtonClick == true){
      final prefs = await SharedPreferences.getInstance();

      final jsonStringlastViewsList = prefs.getString('lastViweListArray');
      final decodedArraylastViewsList = jsonDecode(jsonStringlastViewsList!) as List<dynamic>;
      lastViewsList = decodedArraylastViewsList.cast<Map<String, dynamic>>();

      final jsonStringhotelList = prefs.getString('hotelListListArray');
      final decodedArrayhotelList = jsonDecode(jsonStringhotelList!) as List<dynamic>;
      hotelList = decodedArrayhotelList.cast<Map<String, dynamic>>();

      
      setState(() {
         buildBody();
        });

    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
       appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark, 
          ),
        elevation: 0,
        backgroundColor: Colors.transparent,

      ),
      body: buildBody(),
    );
  }

  
 
  Widget buildBody() {
    if(lastViewsList.isNotEmpty){
      
      return 
        ColorfulSafeArea(
          
          overflowRules: OverflowRules.all(true),
          child:Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left:13.0,top:20.0,bottom:15.0),
                child: Row(
                  
                  children: [
                    
                    Text("Hi Nimal",
                      style: GoogleFonts.nunito(
                                  // ignore: prefer_const_constructors
                                  textStyle: TextStyle(
                                  color: const Color.fromARGB(255, 27, 27, 27),
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                          
                                  ) 
                                )
                    
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:105,top:3),
                      child: Container(child: Image.asset("assets/images/location.png",width:25,height:25)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:9.0),
                      child: Text("Sri lanka",
                        style: GoogleFonts.nunito(
                                    // ignore: prefer_const_constructors
                                    textStyle: TextStyle(
                                    color: const Color.fromARGB(255, 143, 142, 142),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                            
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
                  
                  
                                return GestureDetector(
                                  onTap:() =>{ print("hiii")},
                                  child: Card(
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
                                    
                                    
                                  
                                  ),
                                ); 
                            },
                          ),
                    
                      ),
                ),
              ),
             
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                  
                    
                    children: [
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
                              
                                return GestureDetector(
                                  onTap: ()=>{print("hello")},
                                  child: Card(
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
                                                      //place type tag-----------------------------------------------------
                                                      SizedBox(
                                                        height:25,
                                                        width:60,
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
                                                                          padding: const EdgeInsets.all(10.0),
                                                                          child: Text('$type',
                                                                            style: GoogleFonts.cabin(
                                                                              // ignore: prefer_const_constructors
                                                                              textStyle: TextStyle(
                                                                              color: Color.fromARGB(255, 95, 95, 95),
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.bold,
                                                                                                                                        
                                                                              ) 
                                                                            )
                                                                                                                                          
                                                                          ),
                                                                        ), 
                                                                  )
                                                            
                                                        ),
                                                      ),
                                                      //--------------------------------------------------------------------
                                                      Padding(
                                                        padding: const EdgeInsets.only(left:119,top:5),
                                                        child: SizedBox(
                                                            width:37,
                                                            height:37,
                                                            child: GestureDetector(
                                                              onTap: ()=>{print("hart")},
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
                                    
                                    
                                  
                                  ),
                                ); 
                            },
                          ),
                                
                          ),
                              ),
                            ),
                            
                        Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(13.0),
                                child: Card(
                        elevation: 0,
                        color:const Color.fromARGB(200, 240, 238, 238),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            
                        child:Container(
                          width:326,
                          height:230,
                            
                          decoration:  BoxDecoration(
                                                    
                            image: DecorationImage(
                              image: NetworkImage(lastViewsList[0]['image']),
                              fit: BoxFit.fill,
                              
                            ),
                            
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top:13,left:10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      height:30,
                                      width:70,
                                      child: Card(
                                          elevation: 0,
                                          color:const Color.fromARGB(200, 240, 238, 238),
                                          clipBehavior: Clip.antiAliasWithSaveLayer,
                                          shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(3.0),
                                                ),
                                            child: FittedBox(
                                                    fit: BoxFit.cover,
                                                    child:Padding(
                                                      padding: const EdgeInsets.all(5.0),
                                                      child: Text('LASTVIEWS',
                                                        style: GoogleFonts.cabin(
                                                          // ignore: prefer_const_constructors
                                                          textStyle: TextStyle(
                                                          color: Color.fromARGB(255, 95, 95, 95),
                                                          fontSize: 9,
                                                          fontWeight: FontWeight.bold,
                                                                                                                    
                                                          ) 
                                                        )
                                                                                                                      
                                                      ),
                                                    ), 
                                              )
                                        
                                      ),
                                    ),
                      
                                  ],
                      
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top:115),
                                  child: Row(
                                    children: [
                                      
                                      Text(lastViewsList[0]['city'],
                                            style: GoogleFonts.cabin(
                                          // ignore: prefer_const_constructors
                                          textStyle: TextStyle(
                                          color: Color.fromARGB(255, 255, 255, 255),
                                          fontSize: 27,
                                          fontWeight: FontWeight.bold,
                                                                          
                                          ) 
                                      
                                      ),
                                    ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width:300,
                                      child: Text(lastViewsList[0]['name'],
                                          overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.cabin(
                                          // ignore: prefer_const_constructors
                                          textStyle: TextStyle(
                                          color: Color.fromARGB(255, 207, 207, 207),
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                                                          
                                          ) 
                                      
                                      ),
                                      ),
                                    ),
                      
                      
                                  ],
                      
                                ),
                                ],
                                  ),
                              
                                  )
                                ),
                              ),
                              )
                            ]
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left:16.0,top:10),
                                child: Text("Nearby experience",
                                  style: GoogleFonts.cabin(
                                          // ignore: prefer_const_constructors
                                          textStyle: TextStyle(
                                          color: const Color.fromARGB(255, 27, 27, 27),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                  
                                          ) 
                                        )
                                
                                ),
                              )  
                            ],
                          ),
                         Padding(
                              padding: const EdgeInsets.only(left:13.0,top:10),
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
                              
                                return GestureDetector(
                                  onTap: ()=>{print("hello")},
                                  child: Card(
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
                                                      SizedBox(
                                                        height:25,
                                                        width:60,
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
                                                                          padding: const EdgeInsets.all(10.0),
                                                                          child: Text('$type',
                                                                            style: GoogleFonts.cabin(
                                                                              // ignore: prefer_const_constructors
                                                                              textStyle: TextStyle(
                                                                              color: Color.fromARGB(255, 95, 95, 95),
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.bold,
                                                                                                                                        
                                                                              ) 
                                                                            )
                                                                                                                                          
                                                                          ),
                                                                        ), 
                                                                  )
                                                            
                                                        ),
                                                      ),
                                
                                                      Padding(
                                                        padding: const EdgeInsets.only(left:119,top:5),
                                                        child: SizedBox(
                                                            width:37,
                                                            height:37,
                                                            child: GestureDetector(
                                                              onTap: ()=>{print("hart")},
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
                                    
                                    
                                  
                                  ),
                                ); 
                            },
                          ),
                                
                          ),
                              ),
                            ),
                                
                                
                    ],
                  ),
                ),
              ),
               //bottom navigaion bar-------------------------------------------------------
             
              //------------------------------------------------------------------------------- 
          
            ],
            
          ) 
          
          ),
        );
       
      
      
    }else{
       return const Center(
        child: CircularProgressIndicator(),
      );

    }
      
  }
}