import 'dart:convert';

import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:travelapp/createNewTrip.dart';
import 'package:travelapp/search.dart';

import 'customPageRoutes.dart';
import 'navigationPage.dart';

class locationDetails extends StatefulWidget {
  
  final placeId;
  final searchTypeCity;
  
  
 const locationDetails({required this.placeId,required this.searchTypeCity, Key? key}) : super(key: key);


  @override
  State<locationDetails> createState() => _locationDetailsState(placeId,searchTypeCity);
}

class _locationDetailsState extends State<locationDetails> {

  final placeId;
  final searchTypeCity;

  late final double placelat;
  late final double placelng;
  late final String placePhoto;
  late final String placeName;
  late final String placeType;

  var searchResults =[];
  
  late final placeOpenTimes =[];
  List<dynamic> reviews = [];
  late bool isNotEmptyReviews =false;
  late final double placeRating =0.0;
  late final bool isPlaceOpenNow;
  late final String PlaceAddress;
  late final String PlacePhotoReference;
  late final isEstablishment ;
  late final String palceNumber;
  late  String aboutDetails ='';
  late final bool isDataLoading;
  late final setgetPhrase;
  late final double temperature;
  late final String weatherIcon;

  bool showFullText = false;

  late final currentCity;
  late String distance = 'ndefined';
  late String duration='Undefined';
  
  _locationDetailsState(this.placeId,this.searchTypeCity);

  
  @override
  void initState(){
     super.initState();
    //get data list from api-------------------------------

    if(searchTypeCity ==true){

      getCityDetails ();

    }else{
      getPlaceDetails ();
    }
  
   

    
  }

  Future <void> getCityDetails ()async {

  

      final databaseReference = FirebaseDatabase.instance.ref('city-List');
      final dataSnapshot = await databaseReference.once();

      final data = dataSnapshot.snapshot.value as List<dynamic>;

      searchResults=data.map((element) { 

              final Id = element['placeId'];

              if (Id != null && Id==placeId) {
                if (element['imageUrls'] != null && element['imageUrls'].isNotEmpty) {
                  return {
                    'name': element['title'],
                    'photo_reference': element['imageUrls'][0],
                    'type':element['searchString'],
                    'location':element['location'],
                    

                  };
                } else {
                  return {
                    'name': 'city',
                    'photo_reference': 'https://via.placeholder.com/150',
                  };
                }
              }

              return null;
            }).where((element) => element != null).toList();

          
    
     //check place is establishment or not-------------------------
    late bool isEs;
    if(searchResults[0]['type']=='locality'){

      isEs = false;

      findWeather ();

    }else{
      isEs = true;

    }

     isEstablishment =isEs;
     getAttractionPlaces();
     getAboutData ();
     calculateDistance ();
    
            

   }

    Future <void> getPlaceDetails ()async {

  

      final databaseReference = FirebaseDatabase.instance.ref('places');
      final dataSnapshot = await databaseReference.once();

      final data = dataSnapshot.snapshot.value as List<dynamic>;

      searchResults=data.map((element) { 

              final Id = element['placeId'];

              if (Id != null && Id==placeId) {
                if (element['imageUrls'] != null && element['imageUrls'].isNotEmpty) {
                  return {
                    'name': element['title'],
                    'photo_reference': element['imageUrls'][0],
                    'type':element['searchString'],
                    'location':element['location'],
                    

                  };
                } else {
                  return {
                    'name': 'city',
                    'photo_reference': 'https://via.placeholder.com/150',
                  };
                }
              }

              return null;
            }).where((element) => element != null).toList();

          
    
     //check place is establishment or not-------------------------
    late bool isEs;
    if(searchResults[0]['type']=='locality'){

      isEs = false;

      findWeather ();

    }else{
      isEs = true;

    }

     isEstablishment =isEs;
     getAboutData ();
     calculateDistance ();
    
            

   }

    Future<void> findWeather ()async {
        const String apikey = '44uxmYtWX39vfBU6EgSPDrJI8TSJi4tViH6a2uojU9U';
        const apiUrl = 'https://atlas.microsoft.com/weather/currentConditions/json';
        final url ='$apiUrl?api-version=1.1&query=${searchResults[0]['location']['lat']},${searchResults[0]['location']['lng']}&unit=metric&subscription-key=$apikey';

        final response = await http.get(Uri.parse(url));
        
        if (response.statusCode == 200) {
          print("Weather calculate sucsuss:${response.statusCode}");

          final responseData = jsonDecode(response.body);
          List<dynamic> results = responseData['results'];

  
          if(results !=null &&  results.isNotEmpty){
            String getPhrase = results[0]['phrase']??'';
            setgetPhrase = getPhrase;
            bool isDayTime = results[0]['isDayTime']??false;
            temperature = results[0]['temperature']['value']??0.0;
            print( "getPhrase:$getPhrase");
            print( "daytime:$isDayTime");
            print( "temperature:$temperature");

            //change icon when weather changers---------------------------------
            if(isDayTime==false && getPhrase=="Cloudy"){
              weatherIcon = 'assets/images/cloudy.png';

            }else if(isDayTime==false && getPhrase=="Some clouds"){
              weatherIcon = 'assets/images/PartlyCloudyNightV2.png';

            }else if(isDayTime==false && getPhrase=="Mostly clear"){  
              weatherIcon = 'assets/images/MostlyClearNight.png';

            }else if(isDayTime==false && getPhrase=="Mostly cloudy"){
              weatherIcon = 'assets/images/MostlyCloudyNightV2.png';  

            }else if(isDayTime==false && getPhrase=="Partly cloudy"){
              weatherIcon = 'assets/images/PartlyCloudyNightV2.png';

            }else if(isDayTime==false && getPhrase=="Light rain"){
              weatherIcon = 'assets/images/N210LightRainShowersV2.png'; 

            }else if(isDayTime==false && getPhrase=="Light rain shower"){  
              weatherIcon = 'assets/images/N210LightRainShowersV2.png';

            }else if(isDayTime==false && getPhrase=="Rain"){
              weatherIcon = '';
            }else if(isDayTime==true && getPhrase=="A shower"){
              weatherIcon = 'assets/images/Light-rain.png';

              
            }else if(isDayTime==true && getPhrase=="Light rain"){
              weatherIcon = 'assets/images/Light-rain.png';

            }else if(isDayTime==true && getPhrase=="Cloudy"){
              weatherIcon = 'assets/images/cloudy.png';

            }else if(isDayTime==true && getPhrase=="Mostly cloudy"){
              weatherIcon = 'assets/images/mostly-cloudy.png';

            }else if(isDayTime==true && getPhrase=="Clouds and sun"){

              weatherIcon = 'assets/images/cloudsAndSun.png';
            }else if(isDayTime==true && getPhrase=="Partly sunny"){

              weatherIcon = 'assets/images/Partly-sunny.png';
              
            }else if(isDayTime==true && getPhrase=="Mostly sunny"){ 
              weatherIcon = 'assets/images/Mostly-Sunny-Day.png';

            }else if(isDayTime==true && getPhrase=="Sunny"){ 
               weatherIcon = 'assets/images/sunny.png';

            }

          }else{
            print( "no weather data");
          }
          
        }else{

          print("Weather calculate not sucsuss:${response.statusCode}");

        }
      }  
  


  Future <void> getAboutData ()async {
   
    const apiUrl = 'https://api.openai.com/v1/chat/completions';
    const apiKey = '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';

    String message = 'give details about ${searchResults[0]['name']} and place address is ${searchResults[0]['name']} in Srilanka';

    final requestBody = jsonEncode({
      'model': 'gpt-3.5-turbo',
      'messages': [
         {
          'role': 'user',
          'content': '$message',
        },
        
      ],
    });

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body:requestBody,
    );
    

     if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
      final generatedText = jsonResponse['choices'][0]['message']['content'] as String?;
      
      aboutDetails = generatedText ?? "";

      setState(() {
        
        aboutDetails;
        isPlaceOpenNow= false;
        palceNumber ="no numbers found";
        PlaceAddress ="no Address found";

      });

      
      print("succses");
     
    } else {
     
      print(" not succses ${response.statusCode}");
      
    }

  }

  //----------------------------------------------------------------
  //calculate distance between two points---------------------------
  Future<void> calculateDistance ()async{

    final prefs = await SharedPreferences.getInstance();
    final getSheardData = prefs.getString('currentLocation');
    final currentLocation = jsonDecode(getSheardData!) ;

    currentCity = prefs.getString('currentCity');

    const String apikey = '44uxmYtWX39vfBU6EgSPDrJI8TSJi4tViH6a2uojU9U';
    const String apiUrl = 'https://atlas.microsoft.com/route/directions/json';
    final url ='$apiUrl?api-version=1.0&query=${currentLocation['lat']},${currentLocation['lng']}:${searchResults[0]['location']['lat']},${searchResults[0]['location']['lng']}&report=effectiveSettings&subscription-key=$apikey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print("compute route sucssus");

      final data = jsonDecode(response.body);
      final routes = data['routes'];

      if (routes != null && routes.isNotEmpty) {
        final firstRoute = routes[0];
        final summary = firstRoute['summary'];

        if (summary != null && summary.isNotEmpty) {

          final meters = summary['lengthInMeters'] ?? 0;
          final kilometers = meters / 1000;
          final convkilometers =kilometers.toStringAsFixed(0);

          distance = convkilometers.toString();
          
          duration = summary['travelTimeInSeconds'].toString();

         
        }
      }
    } else {
      print('Failed to compute route');
    }

  }
  
  late List attractionList= [];

  Future <void> getAttractionPlaces()async{

    final databaseReference = FirebaseDatabase.instance.ref('places');
    final dataSnapshot = await databaseReference.once();

    final data = dataSnapshot.snapshot.value as List<dynamic>;

    attractionList=data.map((element) { 

              final attractionCity = element['city'];

              if (attractionCity == searchResults[0]['name'] ) {
                if (element['imageUrls'] != null && element['imageUrls'].isNotEmpty) {
                  return {
                    'name':element['title'],
                    'id': element['placeId'],
                    'photoRef': element['imageUrls'][0],
                    'rating': 3.6, //!= null ? result['rating'].toDouble() : 0.0,
                    'address':element['address'],
                    'type':element['categoryName'],
                  };
                } else {
                  return {
                    'name': '',
                    'photo_reference': 'https://via.placeholder.com/150',
                  };
                }
              }

              return null;
            }).where((element) => element != null).toList();

      setState(() {
        attractionList;

      });

    print("attractions:${attractionList.length}");


   

  }
  late List<Map<String, dynamic>>  restaurantsList= [];
  Future <void> getRestaurants()async{

   final databaseReference = FirebaseDatabase.instance.ref('places');
  final dataSnapshot = await databaseReference.once();

      final data = dataSnapshot.snapshot.value as List<dynamic>;

    // if (response.statusCode == 200) {
    // final result = json.decode(response.body);
    // final data = result['results'] as List<dynamic>;

    //   if (data != null && data.isNotEmpty) {
    //     print(' Restaurants found');

    //     restaurantsList = data.map((result) {
    //       final photoRef = result['photos'] != null ? result['photos'][0]['photo_reference'] : '';
        
    //       return {
    //         'name': result['name'],
    //         'id': result['place_id'],
    //         'photoRef': photoRef,
    //         'rating': result['rating'] != null ? result['rating'].toDouble() : 0.0,
    //         'address': result['formatted_address'],
    //         'type':"Restaurants",
    //       };
    //     }).toList();

       
    //   } else {
    //     print('No Restaurants found');
    //   }
    // } else {
    //   print('Failed to get Restaurants');
    // }



  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
         Navigator.of(context).pushReplacement(customPageRoutes(
                
        child:const Scaffold(body: search())));
      return false;
      }, 
      child: Scaffold(
       extendBodyBehindAppBar: true,
       appBar: AppBar(
        toolbarHeight: 2,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Color.fromARGB(0, 255, 255, 255),
          statusBarIconBrightness: Brightness.light, 
          ),
        elevation: 0,
        backgroundColor: Color.fromARGB(0, 20, 12, 12),

        
      ),
        body:buildBody(),
      )
    );

  }

  
   Widget buildBody() {
    if(aboutDetails.isNotEmpty){
       
      return
      SingleChildScrollView(
        child: Container(
          width:360,
          
          color: Color.fromARGB(255, 255, 255, 255),
          child: Stack(
            children:[ Column(
              children: [
                Row(
                  children: [
                    Container(
                      width:360,
                      height: 250,
                      decoration: BoxDecoration(
                      
                      image: DecorationImage(
                      image: NetworkImage(searchResults[0]['photo_reference']),
                      fit: BoxFit.cover
                                  
                        ),
                      
                      ),
                     
                    ),
                  ],
                ),
              ],
            ),
            //data container---------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.only(top:195),
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width:360,
                          child: Container(
                           
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(27)
                            ),
                            child: Column(
                              //mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top:16, left:6),
                                        child: SizedBox(
                                          width:240,
                                          child: Text(searchResults[0]['name'],
                                              style: GoogleFonts.cabin(
                                                        // ignore: prefer_const_constructors
                                                        textStyle: TextStyle(
                                                        color: const Color.fromARGB(255, 27, 27, 27),
                                                        fontSize: 24,
                                                        fontWeight: FontWeight.bold,
                                                
                                                        ) 
                                                        )
                                          ),
                                        ),
                                      ),
                                     
                                     //weather condion---------------------------------------------
                                     //weather icon------------------------------------
                                      Visibility(
                                        visible: !isEstablishment,
                                        child: Container(
                                          margin: const EdgeInsets.only(top:10,left:4 ),
                                          child: Row(
                                            children: [
                                              Image.asset(weatherIcon,width:35,height:35)
                                            ],
                                          ),
                                        ),
                                      ),
                                      //weather temperature ---------------------------------------
                                      Visibility(
                                        visible: !isEstablishment,
                                        child: Padding(
                                          padding: const EdgeInsets.only(top:10, left:7),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text('${temperature} °',
                                                     style: GoogleFonts.cabin(
                                                              // ignore: prefer_const_constructors
                                                              textStyle: TextStyle(
                                                              color: const Color.fromARGB(255, 27, 27, 27),
                                                              fontSize: 20,
                                                              fontWeight: FontWeight.w400,
                                                                                            
                                                              ) 
                                                            )
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width:35,
                                                    child: SizedBox(
                                                      child: Text("${setgetPhrase}",
                                                        style: GoogleFonts.cabin(
                                                                  // ignore: prefer_const_constructors
                                                                  textStyle: TextStyle(
                                                                  color: const Color.fromARGB(255, 27, 27, 27),
                                                                  fontSize: 10,
                                                                  fontWeight: FontWeight.w400,
                                                                                                
                                                                  ) 
                                                                )
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                    
                                  ),
                                  
                                ),
                                
                                // ratings------------------------------------------------
                                Visibility(
                                  visible: isEstablishment,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left:12,top:6),
                                    child: Row(
                                      children: [
                                         RatingBar.builder(
                                            itemSize: 15,
                                            
                                            initialRating: placeRating,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                                            itemBuilder: (context, _) => const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) {
                                              print(rating);
                                            },
                                          ),
                                
                                          Padding(
                                            padding: const EdgeInsets.only(left:7),
                                            child: Text('${placeRating}',style: GoogleFonts.cabin(
                                                          // ignore: prefer_const_constructors
                                                          textStyle: TextStyle(
                                                          color: const Color.fromARGB(255, 27, 27, 27),
                                                          fontSize: 15,
                                                          //fontWeight: FontWeight.bold,
                                                  
                                                          ) 
                                                          )),
                                          ),
                                          //----------------------------------------------------------
                                         
                                      ],
                                    ),
                                  ),
                                ),
                                //place types------------------------------------------------------------
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left:10,top:4),
                                          child: SizedBox(
                                            width:70,
                                            height:25,
                                                         
                                                          child: Card(
                                                            elevation: 0,
                                                            color:const Color.fromARGB(255, 240, 238, 238),
                                                            //clipBehavior: Clip.antiAliasWithSaveLayer,
                                                            shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(17.0),
                                                                  ),
                                                        
                                                            child:Container(
                                                             
                                                              
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                
                                                                  FittedBox(
                                                                    fit: BoxFit.cover,
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(left:4,right:4),
                                                                      child: Text('${searchResults[0]['type']}',
                                                                            style: GoogleFonts.cabin(
                                                                        // ignore: prefer_const_constructors
                                                                        textStyle: TextStyle(
                                                                        color: const Color.fromARGB(255, 27, 27, 27),
                                                                        fontSize: 8,
                                                                        fontWeight: FontWeight.bold,
                                                                                                      
                                                                        ) 
                                                                        )
                                                                      ),
                                                                    ),
                                                                  ),          
                                                                ],
                                                              ),
                                                            )
                                                          ),
                                                        )
                                                      
                                                 
                                        ), 
                                            
                                      ],
                                            
                                    ),
                                  ],
                                ),
                                //open now--------------------------------------------------------
                                Visibility(
                                  visible: isEstablishment,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left:12,top:7),
                                    child: Row(
                                      children: [
                                        Text(isPlaceOpenNow?'Open now':' Closed now',
                                          style: GoogleFonts.cabin(
                                              // ignore: prefer_const_constructors
                                              textStyle: TextStyle(
                                              color: const Color.fromARGB(255, 27, 27, 27),
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                                                            
                                              ) 
                                            )
                                        )
                                      ],
                                  
                                    ),
                                  ),
                                ),
                                //open times---------------------------------------------------------------------------------
                               Visibility(
                                visible: placeOpenTimes.isNotEmpty?true:false,
                                 child: Padding(
                                    padding: const EdgeInsets.only(left:13,top:5),
                                   child: Row(
                                     children: [
                                       Container(
                                          width:115,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: placeOpenTimes.map<Widget>((time) => Padding(
                                              padding: const EdgeInsets.only(bottom: 4.0),
                                              child: Text(
                                                time,
                                                style: GoogleFonts.cabin(
                                                  textStyle:const TextStyle(
                                                    color: const Color.fromARGB(255, 27, 27, 27),
                                                    fontSize: 8,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            )).toList(),
                                          ),
                                        ),
                                     ],
                                   ),
                                 ),
                               ),
                              //phone number--------------------------------------------------------------
                              Visibility(
                                visible: isEstablishment,
                                child: Padding(
                                  padding: const EdgeInsets.only(left:13,top:7),
                                  child: Row(
                                    children: [
                                      Text(palceNumber,
                                        style: GoogleFonts.cabin(
                                                    textStyle:const TextStyle(
                                                      color: Color.fromARGB(255, 19, 148, 223),
                                                      fontSize: 11,
                                                      fontWeight:FontWeight.w400
                                                      
                                                    ),
                                                  ),
                                      )
                                    ],
                                
                                  ),
                                ),
                              ),
                              // about details on the place----------------------------------------------------
                              Padding(
                                padding: const EdgeInsets.only(left: 13,top:7),
                                child: Row(
                                  children: [
                                    Text("About",
                                      style: GoogleFonts.cabin(
                                                    textStyle:const TextStyle(
                                                      color: Color.fromARGB(255, 0, 0, 0),
                                                      fontSize: 16,
                                                      fontWeight:FontWeight.bold
                                                      
                                                    ),
                                                  ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 13,top:4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LayoutBuilder(
                                      builder: (context, constraints) {
                                        final textSpan = TextSpan(
                                          text: aboutDetails,
                                          style: GoogleFonts.cabin(
                                                  textStyle:const TextStyle(
                                                    color: Color.fromARGB(255, 112, 112, 112),
                                                    fontSize: 11,
                                                    fontWeight:FontWeight.w400
                                                    
                                                  ),
                                                ),
                                        );
                                        final textPainter = TextPainter(
                                          text: textSpan,
                                          textDirection: TextDirection.ltr,
                                          maxLines: 4, 
                                        );
                                        textPainter.layout(maxWidth: constraints.maxWidth);
                                        final isTextOverflowed = textPainter.didExceedMaxLines;
                        
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              text: textSpan,
                                              maxLines: showFullText ? null : 4, 
                                              overflow: TextOverflow.clip,
                                            ),
                                            if (isTextOverflowed)
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    showFullText = !showFullText;
                                                  });
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.only(left:140),
                                                  child: Text(
                                                    showFullText ? 'See Less' : 'See More',
                                                    style: GoogleFonts.cabin(
                                                      textStyle:const TextStyle(
                                                       color: Color.fromARGB(255, 19, 148, 223),
                                                        fontSize: 12,
                                                        fontWeight:FontWeight.bold
                                                        
                                                      ),
                                                ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              //place address ----------------------------------------------------------
                              Visibility(
                                visible: isEstablishment,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 13,top:7),
                                  child: Row(
                                    children: [
                                      Text("Address",
                                        style: GoogleFonts.cabin(
                                                        textStyle:const TextStyle(
                                                          color: Color.fromARGB(255, 0, 0, 0),
                                                          fontSize: 16,
                                                          fontWeight:FontWeight.bold
                                                          
                                                        ),
                                                      ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: isEstablishment,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 13,top:5),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width:250,
                                        child: Text(PlaceAddress,
                                          style: GoogleFonts.cabin(
                                                            textStyle:const TextStyle(
                                                               color: Color.fromARGB(255, 19, 148, 223),
                                                              fontSize: 11,
                                                              fontWeight:FontWeight.bold
                                                              
                                                            ),
                                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              //google map------------------------------------------------------------
                              Padding(
                                padding: const EdgeInsets.only(left: 13,top:8),
                                child: Row(
                                  children: [
                                    Text("How to get there",
                                      style: GoogleFonts.cabin(
                                                        textStyle:const TextStyle(
                                                          color: Color.fromARGB(255, 0, 0, 0),
                                                          fontSize: 16,
                                                          fontWeight:FontWeight.bold
                                                          
                                                        ),
                                                      ),
                                    )
                                  ],
                                ),
                              ),
                              //---Route----------------------------------------------
                              Padding(
                                padding: const EdgeInsets.only(left: 13,top:3),
                                child: Row(
                                  children: [
                                    Text("From ${currentCity}  ▪ ${distance} km   ▪ ${duration}",
                                      style: GoogleFonts.cabin(
                                                    textStyle:const TextStyle(
                                                      color: Color.fromARGB(255, 112, 112, 112),
                                                      fontSize: 11,
                                                      fontWeight:FontWeight.w400
                                                      
                                                    ),
                                                  ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top:9),
                                child: SizedBox(
                                  width:355,
                                  height:185,
                                  child: SfMaps(
                                    layers: [
                                      MapTileLayer(
                                        initialFocalLatLng: MapLatLng(
                                            searchResults[0]['location']['lat'],searchResults[0]['location']['lng']),
                                        initialZoomLevel: 12,
                                        initialMarkersCount: 1,
                                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                        markerBuilder: (BuildContext context, int index) {
                                          return MapMarker(
                                            latitude: searchResults[0]['location']['lat'],
                                            longitude: searchResults[0]['location']['lng'],
                                            size: const Size(50, 50),
                                            child: const Icon(
                                              Icons.location_on,
                                              color: Color.fromARGB(255, 0, 0, 0),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  )
                                ),
                              ),
                              //Attractions in this place-------------------------------------------------------
                             
                              Visibility(
                                visible: !isEstablishment,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 13,top:14),
                                  child: Row(
                                    children: [
                                      Text("Attractions in ${searchResults[0]['name']}",
                                        style: GoogleFonts.cabin(
                                                      textStyle:const TextStyle(
                                                        color: Color.fromARGB(255, 0, 0, 0),
                                                        fontSize: 16,
                                                        fontWeight:FontWeight.bold
                                                        
                                                      ),
                                                    ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              //list------------------------------------------------------
                              attractionList.isNotEmpty?
                              Visibility(
                                visible: !isEstablishment,
                                child: Padding(
                                  padding: const EdgeInsets.only(left:10.0,top:10),
                                  child: SizedBox(
                                  height: 190,
                                    child: Expanded(
                                    child: ListView.builder(
                                      cacheExtent: 9999,
                                      scrollDirection: Axis.horizontal, 
                                      itemCount: attractionList.length,
                                      itemBuilder: (context, index) {
                                        final attraction = attractionList[index];
                                        final attractionName = attraction['name'];
                                        final attractionImgUrl = attraction['photoRef'];
                                        final attractionRating = attraction['rating'];
                                        final address = attraction['address'];
                                        final type = attraction['type'];
                                        
                                          return GestureDetector(
                                            onTap: ()=>{
                                              //dierect place details page again---------------------
                                              // Navigator.of(context).pushReplacement(customPageRoutes(
                
                                              // child: locationDetails(placeId:'')))
                                            },
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
                                                                image: NetworkImage(attractionImgUrl),
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
                                                                                    child: Text('${type}',
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
                                                            child: Text(attractionName,
                                                            
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
                                                        child: Text("$attractionRating",
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
                              ):
                              Container(
                                width:360,
                                height:130,
                                child: const Center(child: CircularProgressIndicator())
                                
                                ),
                              // //show resturents----------------------------------------------
                              // Visibility(
                              //   visible: !isEstablishment,
                              //   child: Padding(
                              //     padding: const EdgeInsets.only(left: 13,top:14),
                              //     child: Row(
                              //       children: [
                              //         Text("Where to stay and eat ",
                              //           style: GoogleFonts.cabin(
                              //                         textStyle:const TextStyle(
                              //                           color: Color.fromARGB(255, 0, 0, 0),
                              //                           fontSize: 16,
                              //                           fontWeight:FontWeight.bold
                                                        
                              //                         ),
                              //                       ),
                              //         )
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              //resturents list-------------------------------------------------------------
                              //  Visibility(
                              //   visible: !isEstablishment,
                              //   child: Padding(
                              //     padding: const EdgeInsets.only(left:10.0,top:10),
                              //     child: SizedBox(
                              //     height: 190,
                              //       child: Expanded(
                              //       child: ListView.builder(
                              //         cacheExtent: 9999,
                              //         scrollDirection: Axis.horizontal, 
                              //         itemCount: 23,
                              //         itemBuilder: (context, index) {
                              //           final restaurants = restaurantsList[index];
                              //           final restaurantnName = restaurants['name'];
                              //           final restaurantRating = restaurants['rating'];
                              //           final address = restaurants['address'];
                              //           final type = restaurants['type'];
                                        
                              //             return GestureDetector(
                              //               onTap: ()=>{
                              //                 //dierect place details page again---------------------
                              //                 Navigator.of(context).pushReplacement(customPageRoutes(
                
                              //                 child: locationDetails(placeId:'')))
                              //               },
                              //               child: Card(
                              //               elevation: 0,
                              //               color:const Color.fromARGB(255, 240, 238, 238),
                              //               clipBehavior: Clip.antiAliasWithSaveLayer,
                              //               shape: RoundedRectangleBorder(
                              //                       borderRadius: BorderRadius.circular(10.0),
                              //                     ),
                              //               child:Container(
                              //                 width: 230,
                              //                 child: Column(
                              //                   children: [
                              //                     Row(
                              //                       children: [
                              //                         Container(
                              //                           width: 230,
                              //                           height: 120,
                                                        
                              //                               decoration:  BoxDecoration(
                                                              
                              //                                 image: DecorationImage(
                              //                                   image: NetworkImage(''),
                              //                                   fit: BoxFit.fill,
                                                                
                                                          
                              //                                     ),
                                                              
                              //                                 ),
                              //                           child: Column(
                              //                             children: [
                              //                               Row(
                              //                                 children: [
                              //                                   SizedBox(
                              //                                     height:25,
                              //                                     width:60,
                              //                                     child: Card(
                              //                                         elevation: 0,
                              //                                           color:const Color.fromARGB(200, 240, 238, 238),
                              //                                           clipBehavior: Clip.antiAliasWithSaveLayer,
                              //                                           shape: RoundedRectangleBorder(
                              //                                                   borderRadius: BorderRadius.circular(5.0),
                              //                                                 ),
                              //                                             child: FittedBox(
                              //                                                     fit: BoxFit.cover,
                              //                                                     child:Padding(
                              //                                                       padding: const EdgeInsets.all(10.0),
                              //                                                       child: Text('${type}',
                              //                                                         style: GoogleFonts.cabin(
                              //                                                           // ignore: prefer_const_constructors
                              //                                                           textStyle: TextStyle(
                              //                                                           color: Color.fromARGB(255, 95, 95, 95),
                              //                                                           fontSize: 12,
                              //                                                           fontWeight: FontWeight.bold,
                                                                                                                                                  
                              //                                                           ) 
                              //                                                         )
                                                                                                                                                    
                              //                                                       ),
                              //                                                     ), 
                              //                                               )
                                                                      
                              //                                     ),
                              //                                   ),
                                          
                              //                                   Padding(
                              //                                     padding: const EdgeInsets.only(left:119,top:5),
                              //                                     child: SizedBox(
                              //                                         width:37,
                              //                                         height:37,
                              //                                         child: GestureDetector(
                              //                                           onTap: ()=>{print("hart")},
                              //                                           child: Card(
                              //                                             elevation: 0,
                              //                                                 color:const Color.fromARGB(200, 240, 238, 238),
                              //                                                 clipBehavior: Clip.antiAliasWithSaveLayer,
                              //                                                 shape: RoundedRectangleBorder(
                              //                                                         borderRadius: BorderRadius.circular(50.0),
                              //                                                       ),
                              //                                                 child:Column(
                              //                                                   mainAxisAlignment: MainAxisAlignment.center,
                              //                                                   crossAxisAlignment: CrossAxisAlignment.center,
                              //                                                   children: [
                              //                                                     Row(
                              //                                                       mainAxisAlignment: MainAxisAlignment.center,
                              //                                                       crossAxisAlignment: CrossAxisAlignment.center,
                              //                                                       children: [
                              //                                                         Image.asset("assets/images/heart.png",width:18,height:18),
                              //                                                       ],
                              //                                                     ),
                              //                                                   ],
                              //                                                 ),  
                                                                                                                            
                              //                                           ),
                              //                                         ),
                                                                
                              //                                     ),
                              //                                   ),
                                          
                              //                                 ],
                              //                               ),
                              //                             ],
                              //                           ), 
                                                          
                                                        
                              //                         ),
                                                  
                                                            
                              //                       ],
                              //                     ),
                              //                     Row(
                                                    
                              //                       children: [
                              //                           SizedBox(
                              //                           width: 190,
                              //                           height:30,
                              //                             child: Padding(
                              //                               padding: const EdgeInsets.only(left:6,top:5),
                              //                               child: Text(restaurantnName,
                                                            
                              //                               overflow: TextOverflow.ellipsis,
                              //                               style: GoogleFonts.cabin(
                              //                                   // ignore: prefer_const_constructors
                              //                                   textStyle: TextStyle(
                              //                                   color: const Color.fromARGB(255, 27, 27, 27),
                              //                                   fontSize: 14,
                              //                                   fontWeight: FontWeight.bold,
                                                                                                
                              //                                   ) 
                              //                                 )
                                                                                                    
                              //                               ),
                              //                             ),
                              //                           ),
                                          
                              //                         Image.asset("assets/images/star.png",width:14,height:14),
                              //                         Padding(
                              //                           padding: const EdgeInsets.only(left:4),
                              //                           child: Text("$restaurantRating",
                              //                               style: GoogleFonts.cabin(
                              //                             // ignore: prefer_const_constructors
                              //                             textStyle: TextStyle(
                              //                             color: const Color.fromARGB(255, 27, 27, 27),
                              //                             fontSize: 12,
                              //                             fontWeight: FontWeight.bold,
                                                                                          
                              //                             ) 
                              //                           )
                                                        
                              //                           ),
                              //                         ),  
                              //                       ],
                                                  
                              //                     ),
                              //                     Row(
                                                  
                              //                       children: [
                              //                         Padding(
                              //                           padding: const EdgeInsets.only(left:4),
                              //                           child: Image.asset('assets/images/location.png',width:15,height:15),
                              //                         ),
                              //                         SizedBox(
                              //                           width:200,
                              //                           height:7,
                              //                           child: Text(address,
                              //                               overflow: TextOverflow.ellipsis,
                              //                               style: GoogleFonts.cabin(
                              //                               // ignore: prefer_const_constructors
                              //                               textStyle: TextStyle(
                              //                               color: Color.fromARGB(255, 94, 94, 94),
                              //                               fontSize: 7,
                              //                               fontWeight: FontWeight.bold,
                                                                                            
                              //                               ) 
                              //                             )
                                                        
                                                        
                              //                           ),
                              //                         )
                              //                       ],
                              //                     )
                              //                   ],
                                                            
                                                            
                              //                 ),
                              //               )
                                              
                                              
                                            
                              //               ),
                              //             ); 
                              //         },
                              //       ),  
                                
                              //     ),
                              //       ),
                              //     ),
                              // ),
                              //reviews-----------------------------------------------------------------
                              //------------------------------------------------------------------------
                               Visibility(
                                visible: isNotEmptyReviews,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 13,top:14,bottom:9),
                                  child: Row(
                                    children: [
                                      Text("Reviews",
                                        style: GoogleFonts.cabin(
                                                      textStyle:const TextStyle(
                                                        color: Color.fromARGB(255, 0, 0, 0),
                                                        fontSize: 16,
                                                        fontWeight:FontWeight.bold
                                                        
                                                      ),
                                                    ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              //reviewslist------------------------------------------------------
                              
                              Visibility(
                                visible: reviews.isNotEmpty?true:false,
                                child: Row(
                                  children: [
                                    
                                    Expanded(
                                      child: Column(
                                      
                                        children: reviews.map<Widget>((review) => Padding(
                                          padding: const EdgeInsets.only(bottom: 10.0),
                                          child: Container(
                                            width: 330,
                                      
                                            decoration: BoxDecoration(
                                              color:const Color.fromARGB(255, 240, 238, 238),
                                              borderRadius: BorderRadius.circular(13)
                                            ),
                                                      
                                            child:Padding(
                                              padding: const EdgeInsets.only(left:10,bottom:10),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      //profile photo-----------------------------------
                                                       Padding(
                                                         padding: const EdgeInsets.only(top:13),
                                                         child: Container(
                                                          width:35,
                                                          height:35,
                                                           child: CircleAvatar(
                                                            radius: 40,
                                                            backgroundImage:NetworkImage(review['profile_photo_url']),
                                                            
                                                          ),
                                                         ),
                                                       ),
                                                       Padding(
                                                         padding: const EdgeInsets.only(left:7,top:10),
                                                         child: Column(
                                                           children: [
                                                             Row(
                                                               children: [
                                                                //author name--------------------------------------
                                                                 SizedBox(
                                                                  width:200,
                                                                   child: Text(review['author_name'],
                                                                     style: GoogleFonts.cabin(
                                                                      textStyle:const TextStyle(
                                                                        color: Color.fromARGB(255, 0, 0, 0),
                                                                        fontSize: 14,
                                                                        fontWeight:FontWeight.bold
                                                                        
                                                                      ),
                                                                    ),
                                                                   ),
                                                                 ),
                              
                                                                 //review date-------------------------------------------------
                                                                 Text(review['relative_time_description'],
                                                                    style: GoogleFonts.cabin(
                                                                      textStyle:const TextStyle(
                                                                        color: Color.fromARGB(255, 112, 112, 112),
                                                                        fontSize: 9,
                                                                        fontWeight:FontWeight.bold
                                                                        
                                                                      ),
                                                                    ),
                                                                 )
                                                                
                                                               ],
                                                             ),
                                                             
                                                           ],
                                                         ),
                                                       )
                                                       
                                                    ],
                                                  ),
                                                  //Review description-------------------------------------
                                                   Padding(
                                                     padding: const EdgeInsets.only(left:13),
                                                     child: SizedBox(
                                                      width: 250,
                                                      
                                                      
                                                      child: Text(review['text'],
                                                          style: GoogleFonts.cabin(
                                                            textStyle:const TextStyle(
                                                              color: Color.fromARGB(255, 112, 112, 112),
                                                              fontSize: 10,
                                                              fontWeight:FontWeight.w400
                                                              
                                                            ),
                                                          ),
                                                          ),
                                                        ),
                                                   )
                                                ],
                                              ),
                                            )
                                           
                                          ),
                                        )).toList(),
                                      ),
                                    ),
                                  ],
                                 ),
                              ),
                               Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: TextButton(
                                  onPressed: () {
                                    isEstablishment?
                                    showModalBottomSheet(
                                      context: context,
                                      shape: const RoundedRectangleBorder(
                                         borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20),
                                            ),
                                        ), 
                                      builder: (BuildContext context) { 

                                        return
                                         SizedBox(
                                          height:200,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left:12,top:12),
                                                child: Row(
                                                  children: [
                                                    Text("Select trip and day",
                                                      style: GoogleFonts.cabin(
                                                            textStyle:const TextStyle(
                                                              color: Color.fromARGB(255, 0, 0, 0),
                                                              fontSize: 16,
                                                              fontWeight:FontWeight.bold
                                                              
                                                            ),
                                                          ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left:12,top:6),
                                                child: Row(
                                                  children: [
                                                    Text("Choose your best option to go to this place",
                                                      style: GoogleFonts.cabin(
                                                            textStyle:const TextStyle(
                                                              color: Color.fromARGB(255, 112, 112, 112),
                                                              fontSize: 10,
                                                              fontWeight:FontWeight.w400
                                                              
                                                            ),
                                                          ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              //trip list------------------------------------------------
                                              Padding(
                                                padding: const EdgeInsets.only(left:10,top:7),
                                                child: Row(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Card(
                                                              elevation: 0,
                                                              color:Color.fromARGB(255, 124, 124, 124),
                                                              clipBehavior: Clip.antiAliasWithSaveLayer,
                                                              shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(10.0),
                                                                    ),
                                                                child: GestureDetector(
                                                                    onTap: ()=>{
                                                                      //dierect place details page again---------------------
                                                                       Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(builder: (context) => const createNewTrip(placeName:'',placePhotoUrl:'')),
                                                                      ),
                                                                    },
                                                                    child: Container(
                                                                      width:145,
                                                                      height:110,
                                                                      child:Column(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                            children: [
                                                                              Image.asset('assets/images/add.png',width:30,height:30)
                                                                            ],
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(top:6),
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                Text("Creat new trip",
                                                                                  style: GoogleFonts.cabin(
                                                                                    textStyle:const TextStyle(
                                                                                      color: Color.fromARGB(255, 255, 255, 255),
                                                                                      fontSize: 12,
                                                                                      fontWeight:FontWeight.w500
                                                                                      
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      )
                                                                      
                                                                    ),
                                                              ),      
                                                            ),
                                                            //created trip list------------------------------------------------------

                                                          ],
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          
                                         );

                                       }, 
                                      
                                    
                                    ):
                                    //derect trip plan page---------------------------------
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>  createNewTrip(placeName:placeName,placePhotoUrl:placePhoto)),
                                    );
                                    
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromARGB(255, 0, 0, 0),
                                    foregroundColor:Color.fromRGBO(255, 255, 255, 1),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20), // Set the radius here
                                      ),
                                    
                                  ),
                                  child: Text(isEstablishment?'Add to trip':'Plan new trip',
                                      style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          
                                  
                                      ),
                                  
                                  ),
                                ),
                               ),
                        
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
            ]
          ),
        ),
      );
    
    }else{

      return const Center(
        child: CircularProgressIndicator(),
      );


    }
    
  }
}