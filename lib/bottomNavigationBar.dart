
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: camel_case_types
class navigaionBar extends StatelessWidget {

   
  
 @override
  Widget build(BuildContext context) {
    
    return  Container(
                 height:50,
                 width:800, 
                 color: Color.fromARGB(255, 255, 255, 255),
                 child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right:37),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Image.asset("assets/images/homeClick.png",width:20,height:20)
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Home", style: GoogleFonts.cabin(
                                                  // ignore: prefer_const_constructors
                                                  textStyle: TextStyle(
                                                  color: Color.fromARGB(255, 0, 0, 0),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                                                  
                                                  ) 
                                                ))
                                ],
                          
                              )
                            ],
                          
                          ),
                        ),
                         Container(
                           margin: const EdgeInsets.only(right:37),
                           child: Column(
                            children: [
                              Row(
                                children: [
                                  Image.asset("assets/images/search.png",width:20,height:20)
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Search",
                                     style: GoogleFonts.cabin(
                                                  // ignore: prefer_const_constructors
                                                  textStyle: TextStyle(
                                                  color: Color.fromARGB(255, 189, 188, 188),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                                                  
                                                  ) 
                                                )
                                  )
                                ],
                         
                              )
                            ],
                         
                                                 ),
                         ),
                         Container(
                           margin: const EdgeInsets.only(right:37),
                           child: Column(
                            children: [
                              Row(
                                children: [
                                  Image.asset("assets/images/map.png",width:20,height:20)
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Plan",
                                     style: GoogleFonts.cabin(
                                                  // ignore: prefer_const_constructors
                                                  textStyle: TextStyle(
                                                  color: Color.fromARGB(255, 189, 188, 188),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                                                  
                                                  ) 
                                                )
                                  )
                                ],
                         
                              )
                            ],
                         
                                                 ),
                         ),
                         Container(
                           margin: const EdgeInsets.only(right:37),
                           child: Column(
                            children: [
                              Row(
                                children: [
                                  Image.asset("assets/images/like.png",width:20,height:20)
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Favorite",
                                     style: GoogleFonts.cabin(
                                                  // ignore: prefer_const_constructors
                                                  textStyle: TextStyle(
                                                  color: Color.fromARGB(255, 189, 188, 188),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                                                  
                                                  ) 
                                                )
                                  )
                                ],
                         
                              )
                            ],
                         
                                                 ),
                         ),
                         Column(
                          children: [
                            Row(
                              children: [
                                Image.asset("assets/images/user.png",width:20,height:20)
                              ],
                            ),
                            Row(
                              children: [
                                Text("Account",
                                   style: GoogleFonts.cabin(
                                                // ignore: prefer_const_constructors
                                                textStyle: TextStyle(
                                                color: Color.fromARGB(255, 189, 188, 188),
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                                                
                                                ) 
                                              )
                                )
                              ],
                         
                            )
                          ],
                         
                          ),
                    
                      ],
                    )
                  ],

                 ) 


               ); 
  }
  
  
 
}
 
 



