import 'dart:convert';

import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  late final String placeName;
  late final  placeType;
  late final placeOpenTimes;
  late final double placeRating;
  late final bool isPlaceOpenNow;
  late final String PlaceAddress;
  late final isEstablishment ;
  late final String palceNumber;
  late  String aboutDetails ='';
  late final bool isDataLoading;



  
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

         if (results.containsKey('opening_hours') && results['opening_hours'] != null) {
            placeOpenTimes = results['opening_hours']['weekday_text'] ?? '';
          } else {
            placeOpenTimes = [];
          }

        //check place is establishment or not-------------------------
        late bool isEs;
        for(int i=0;i<placeType.length;i++){
          
          if(placeType[i]=='establishment'){

            isEs = true;
            break;

          }else{

            isEs = false;
          }

        }
        isEstablishment =isEs;
        
        print(isEstablishment);
        
         
          
          placeName = results['name']??"No name";
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

  

  Future <void> getAboutData ()async {
   
    const apiUrl = 'https://api.openai.com/v1/chat/completions';
    const apiKey = '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';

    String message = 'give details about ${placeName} and place address is ${PlaceAddress} in Srilanka';

    final requestBody = jsonEncode({
      'model': 'gpt-3.5-turbo',
      'messages': [
        {
          'role': 'system',
          'content': 'You are a helpful assistant.',
        },
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

      });

      print("succses");
      
      // setState(() {
      //   _response = generatedText;
      // });
    } else {
      // setState(() {
      //   _response = 'Error: ${response.statusCode}';
      // });
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
                      height:800,
                      color: Color.fromARGB(255, 255, 255, 255),
                      child: Stack(
                        children:[ Container(
                          width:360,
                          height: 250,
                          decoration: const BoxDecoration(
                          
                          image: DecorationImage(
                          image: AssetImage('assets/images/Boat-Windows-10-Wallpaper.jpg'),
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
                                  padding: const EdgeInsets.only(left:12.0,top:7),
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
                                  padding: const EdgeInsets.only(left:12.0,top:5),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 340,
                                        child: Text(aboutDetails,
                                          style: GoogleFonts.cabin(
                                                // ignore: prefer_const_constructors
                                                textStyle: TextStyle(
                                                color: Color.fromARGB(255, 83, 83, 83),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                                                              
                                                ) 
                                              )  
                                        
                                        )
                                        
                                        )
                                    ],
                                                                
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