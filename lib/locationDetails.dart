import 'dart:convert';

import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import 'customPageRoutes.dart';
import 'navigationPage.dart';

class locationDetails extends StatefulWidget {
  final String placeId;
  

 const locationDetails({required this.placeId, Key? key}) : super(key: key);


  @override
  State<locationDetails> createState() => _locationDetailsState(placeId);
}

class _locationDetailsState extends State<locationDetails> {
  final String placeId;
  late final String placePhoto;
  late final String placeName;

  late final  placeType;
  late  final placeLogLat;
  late final LatLng placeLocation;
  late final placeOpenTimes;
  late final double placeRating;
  late final bool isPlaceOpenNow;
  late final String PlaceAddress;
  late final String PlacePhotoReference;
  late final isEstablishment ;
  late final String palceNumber;
  late  String aboutDetails ='';
  late final bool isDataLoading;

  late final double temperature;
  late final String weatherIcon;

  bool showFullText = false;
  
  _locationDetailsState(this.placeId);
  @override
  void initState(){
     super.initState();
    //get data list from api-------------------------------
  
   getPlaceDetails ();
    
  }

   Future <void> getPlaceDetails ()async {
    const String apikey = 'AIzaSyBEs5_48WfU27WnR6IagbX1W4QAnU7KTpo';
    const String apiUrl = 'https://maps.googleapis.com/maps/api/place/details/json';
    final String url = '$apiUrl?place_id=$placeId&key=$apikey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print("succses ${response.statusCode}");

      final data = jsonDecode(response.body);
      final results = data['result']??'';

       if (results != null) {
        placeType = results['types']??'';
        palceNumber=results['formatted_phone_number']??'No phone number found';

        //set place location-----------------------
        placeLogLat =results['geometry']['location']!;
        print(placeLogLat);
        placeLocation = LatLng(placeLogLat!['lat'], placeLogLat!['lng']);
        //---------------------------------------------------------------------------

         if (results.containsKey('opening_hours') && results['opening_hours'] != null) {
            placeOpenTimes = results['opening_hours']['weekday_text'] ?? '';
          } else {
            placeOpenTimes = [];
          }

        placeName = results['name']??"No name";

        //check place is establishment or not-------------------------
        late bool isEs;
        for(int i=0;i<placeType.length;i++){
          
          if(placeType[i]=='establishment'){

            isEs = true;
            
            break;



          }else{
            findWeather ();
            isEs = false;
          }

        }
        isEstablishment =isEs;
        //--------------------------------------------------------------------
      
          
         

          PlacePhotoReference=results['photos'][0]['photo_reference'];
          placePhoto=getPhotoUrl(PlacePhotoReference);
          
          placeRating = results['rating'] ?? 0.0;
          PlaceAddress = results['formatted_address'];

          if (results.containsKey('opening_hours') && results['open_now'] != null) {
           isPlaceOpenNow =  results['opening_hours']['open_now'] ??false ;
          } else {
            isPlaceOpenNow = false;
          }

          
          
         
        
        getAboutData ();
        print( placeName);
        print( placeOpenTimes);
        

       }else{

         print("Error: place data  value is null");
       }

      
       

    }else{
      print(" not succses ${response.statusCode}");

    }


   }

    Future<void> findWeather ()async {
        const String apikey = '44uxmYtWX39vfBU6EgSPDrJI8TSJi4tViH6a2uojU9U';
        const apiUrl = 'https://atlas.microsoft.com/weather/currentConditions/json';
        final url ='$apiUrl?api-version=1.1&query=${placeLogLat!['lat']},${placeLogLat!['lng']}&unit=metric&subscription-key=$apikey';

        final response = await http.get(Uri.parse(url));
        
        if (response.statusCode == 200) {
          print("Weather calculate sucsuss:${response.statusCode}");

          final responseData = jsonDecode(response.body);
          List<dynamic> results = responseData['results'];

  
          if(results !=null &&  results.isNotEmpty){
            String getPhrase = results[0]['phrase']??'';
            bool isDayTime = results[0]['isDayTime']??false;
            temperature = results[0]['temperature']['value']??0.0;
            print( "getPhrase:$getPhrase");
            print( "daytime:$isDayTime");
            print( "temperature:$temperature");

            //change icon when weather changers---------------------------------
            if(isDayTime==false && getPhrase=="Cloudy"){
              weatherIcon = '';

            }else if(isDayTime==false && getPhrase=="Some clouds"){
              weatherIcon = '';

            }else if(isDayTime==false && getPhrase=="Mostly cloudy"){
              weatherIcon = 'assets/images/MostlyCloudyNightV2.png';  

            }else if(isDayTime==false && getPhrase=="Partly cloudy"){
              weatherIcon = 'assets/images/PartlyCloudyNightV2.png';

            }else if(isDayTime==false && getPhrase=="Rain"){
              weatherIcon = '';

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
  //get place photo ---------------------------------------------------------------
   String getPhotoUrl(String photoReference) {
    if (photoReference =='') {
      // Return a placeholder image URL if no photo reference is available
      return 'https://via.placeholder.com/150';
    }

    const apiKey = 'AIzaSyBEs5_48WfU27WnR6IagbX1W4QAnU7KTpo';
    final maxWidth = 1000;
    final maxHeight = 1250;
    final apiUrl =
        'https://maps.googleapis.com/maps/api/place/photo?maxwidth=$maxWidth&maxheight=$maxHeight&photoreference=$photoReference&key=$apiKey';

    return apiUrl;
  }

  

  Future <void> getAboutData ()async {
   
    const apiUrl = 'https://api.openai.com/v1/chat/completions';
    const apiKey = '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';

    String message = 'give details about ${placeName} and place address is ${PlaceAddress} in Srilanka';

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
        placeName;
        placeRating;
        isPlaceOpenNow;
        aboutDetails;
        weatherIcon;

      });

      print("succses");
     
    } else {
     
      print(" not succses ${response.statusCode}");
      
    }

  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
         Navigator.of(context).pushReplacement(customPageRoutes(
                    
        child:const navigationPage(isBackButtonClick:true)));  
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
        backgroundColor: Color.fromARGB(0, 255, 255, 255),

      ),
        body:buildBody(),
      )
    );

  }

  
   Widget buildBody() {
    if(aboutDetails.isNotEmpty){
       
      return
      Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height:1200,
                      color: Color.fromARGB(255, 255, 255, 255),
                      child: Stack(
                        children:[ Container(
                          width:360,
                          height: 250,
                          decoration: BoxDecoration(
                          
                          image: DecorationImage(
                          image: NetworkImage(placePhoto),
                          fit: BoxFit.cover
                                      
                            ),
                          
                          ),
                         
                        ),
                        Positioned(
                          
                          top:190,
                          
                          child: SizedBox(
                            width:360,
                            height: 800,
                            child: Container(
                              
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 255, 255, 255),
                                borderRadius: BorderRadius.circular(27)
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top:16, left:6),
                                          child: SizedBox(
                                            width:240,
                                            child: Text(placeName,
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
                                        Container(
                                          margin: const EdgeInsets.only(top:6, ),
                                          child: Row(
                                            children: [
                                              Image.asset(weatherIcon,width:35,height:35)
                                            ],
                                          ),
                                        ),
                                        //weather temperature ---------------------------------------
                                        Padding(
                                          padding: const EdgeInsets.only(top:7, left:5),
                                          child: Row(
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
                                              width:300,
                                              height:25,
                                              child: ListView.builder(
                                                scrollDirection: Axis.horizontal, 
                                                itemCount: placeType.length,
                                                itemBuilder: (context, index) {
                                                  return  SizedBox(
                                                           
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
                                                                        child: Text(placeType[index],
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
                                                          );
                                                        }
                                                    ),
                                            ),
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
                                Visibility(
                                  visible: isEstablishment,
                                  child: Padding(
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
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top:9),
                                  child: SizedBox(
                                    width:355,
                                    height:185,
                                    child: GoogleMap(
                                      initialCameraPosition: CameraPosition(
                                        target: placeLocation,
                                        zoom: 15,
                                      ),
                                      markers:{
                                        Marker(
                                          markerId: MarkerId('kjhuuu'),
                                          position: placeLocation,
                                          infoWindow: InfoWindow(
                                            title: placeName,
                                            snippet: PlaceAddress,
                                          ),
                                          
                                          )
                                  
                                      },
                                      
                                    ),
                                  ),
                                )
                                ],
                              ),
                            ),
                          
                          ),
                          )
                        ]
                      ),
                    )
                  ],
                )
              ],
            
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