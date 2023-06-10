import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:travelapp/bottomNavigationBar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'Home.dart';
import 'customPageRoutes.dart';

class search extends StatefulWidget {
  const search({super.key,});

  @override
  State<search> createState() => _searchState();
}

class _searchState extends State<search> {

  bool  isTextFieldClicked= false;
  String keyboardInput='';
 
  
 Future<void> fetchSearchResults(String input) async {

    keyboardInput = input;
    const String apikey = 'AIzaSyBEs5_48WfU27WnR6IagbX1W4QAnU7KTpo';
    const String apiUrl = 'https://maps.googleapis.com/maps/api/place/textsearch/json';
    final String url = '$apiUrl?query=$keyboardInput&key=$apikey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
       print("Request successful status:${response.statusCode}"); 
      final data = jsonDecode(response.body);

      if (data['status'] == 'OK') {
       
        final results = data['results'] as List<dynamic>;

       
          late final searchResults = results.map((result) {
          
          return {
          'name': result['name'] ?? '',
          'city': result['formatted_address']
              
          };
        }).toList();

          print( searchResults);
      
      }else{
        print("no Data"); 

      }
    }else{

      print("Failed to retrieve dataset items status:${response.statusCode}");


    }
  }


  
  

  @override
  Widget build(BuildContext context) {
    return 
       SafeArea(
        child:Column(
          children: [
            Visibility(
              visible: !isTextFieldClicked,
              child: Padding(
                padding: const EdgeInsets.only(left:13.0,top:20.0,bottom:6.0),
                child: Row(
                  children: [
                    Text("Search",
                          style: GoogleFonts.nunito(
                                      // ignore: prefer_const_constructors
                                      textStyle: TextStyle(
                                      color: const Color.fromARGB(255, 27, 27, 27),
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                              
                                      ) 
                                    )
                        
                        ),
                    
                  ]  
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:9),
              child: Row(
            
                children: [
                   Visibility(
                    visible: isTextFieldClicked,
                     child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: const Color.fromARGB(255, 145, 144, 144),
                        iconSize: 26,
                        onPressed: () {
                   
                          setState(() {
                          isTextFieldClicked = false;
                          });       
                   
                          // Handle back button press
                        },
                     ),
                   ),
                   
                  
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        
                       
                        height: 37,
                        
                        child:  TextField(
                          
                          onTap: () {
                            setState(() {
                              isTextFieldClicked = true;
                            });
                          },
                          //get keyboard input value-------------
                          onChanged: (value) {

                           fetchSearchResults(value);

                          },
                          decoration: InputDecoration(
                          filled: true,
                          fillColor:  Color.fromARGB(255, 240, 238, 238),
                          hintText: 'Search',
                          prefixIcon: Icon(Icons.search),
                          hintStyle: GoogleFonts.cabin(
                                        // ignore: prefer_const_constructors
                                        textStyle: TextStyle(
                                        color: Color.fromARGB(255, 145, 144, 144),
                                        fontSize: 17,
                                        fontWeight:FontWeight.w400,
                                        
                                        ) 
                                      ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(19.0),
                            
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                          ),
                      
                      
                        ),
                      ),
                    ),
                  )

            
                ],
                   
                      
                  
              ),
            ),
            Visibility(
              visible: !isTextFieldClicked,
              child: Padding(
                 padding: const EdgeInsets.only(left:13,top:30),
                child: Row(
              
                  children: [
                    Text("Your recent searches",
                      style: GoogleFonts.cabin(
                            // ignore: prefer_const_constructors
                            textStyle: TextStyle(
                            color: const Color.fromARGB(255, 27, 27, 27),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                    
                            ) 
                          )
                            
                    
                    ),
              
                  ],
              
                ),
              ),
            ),
            //show search results-----------------------------------
            Expanded(
              child:
              
            ),
            //------------------------------------------------------
            Visibility(
              visible: !isTextFieldClicked,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                        
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
                                 
                                  
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                     
                                      FittedBox(
                                        fit: BoxFit.cover,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left:8,right:8,top:8,bottom:8),
                                          child: Text("Galle",
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
                        ),
                      ],
                    ),
                     Row(
                      children: [
                        SizedBox(
                        
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
                                  
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                     
                                      FittedBox(
                                        fit: BoxFit.cover,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left:8,right:8,top:8,bottom:8),
                                          child: Text("Kurunagala",
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
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          ],
        )
         
        );
        
    
  
  }
}