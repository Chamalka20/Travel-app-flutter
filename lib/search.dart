import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:travelapp/bottomNavigationBar.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Home.dart';
import 'customPageRoutes.dart';

class search extends StatefulWidget {
  const search({super.key,});

  @override
  State<search> createState() => _searchState();
}

class _searchState extends State<search> {

  bool  isTextFieldClicked= false;
  
  

  @override
  Widget build(BuildContext context) {
    return 
       SafeArea(
        child:Column(
          children: [
            Visibility(
              visible: !isTextFieldClicked,
              child: Padding(
                padding: const EdgeInsets.only(left:13.0,top:20.0,bottom:10.0),
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
              padding: const EdgeInsets.only(left:4,top:9),
              child: Row(
            
                children: [
                   Visibility(
                    visible: isTextFieldClicked,
                     child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: const Color.fromARGB(255, 145, 144, 144),
                        iconSize: 26,
                        onPressed: () {
                   
                          Navigator.of(context).pushReplacement(customPageRoutes(
                          child:const search()));
                   
                          // Handle back button press
                        },
                     ),
                   ),
                  isTextFieldClicked?
                  Container(
                    
                    width: 290,
                    height: 35,
                    
                    child:  TextField(
                      
                       onTap: () {
                        setState(() {
                          isTextFieldClicked = true;
                        });
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
                  ):
                  Container(
                    
                    width: 330,
                    height: 35,
                    
                    child:  TextField(
                      
                       onTap: () {
                        setState(() {
                          isTextFieldClicked = true;
                        });
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
            )
          ],
        )
         
        );
        
    
  
  }
}