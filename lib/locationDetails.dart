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
  const locationDetails({super.key});

  @override
  State<locationDetails> createState() => _locationDetailsState();
}

class _locationDetailsState extends State<locationDetails> {

  @override
  void initState(){
     super.initState();
    //get data list from api-------------------------------
     getAboutData ();
  }

  Future <void> getAboutData ()async {
   
    const apiUrl = 'https://api.openai.com/v1/chat/completions';
    const apiKey = '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';

    String message = 'give details about galle';

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

      if (generatedText != null) {
        print("Success: $generatedText");
        // Update state or perform further actions with the generated text
      } else {
        print("Error: Text value is null");
      }


      // final jsonResponse = json.decode(response.body);
      // final generatedText = jsonResponse['text'] as String;

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
    return  WillPopScope(
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
        body:Center(
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
                            height: 200,
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
                                          child: Text("Hikkaduwa Fish Market",
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
                                  Padding(
                                    padding: const EdgeInsets.only(left:10,top:6),
                                    child: Row(
                                      children: [
                                         RatingBar.builder(
                                            itemSize: 15,
                                            
                                            initialRating: 3,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) {
                                              print(rating);
                                            },
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.only(left:7),
                                            child: Text("5.5",style: GoogleFonts.cabin(
                                                          // ignore: prefer_const_constructors
                                                          textStyle: TextStyle(
                                                          color: const Color.fromARGB(255, 27, 27, 27),
                                                          fontSize: 15,
                                                          //fontWeight: FontWeight.bold,
                                                  
                                                          ) 
                                                          )),
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
          
        )
      ),
    );
  }
}