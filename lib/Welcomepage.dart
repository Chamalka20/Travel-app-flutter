// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';

class welcomePage extends StatefulWidget {
  const welcomePage({super.key});

  @override
  State<welcomePage> createState() => _welcomePageState();
}

class _welcomePageState extends State<welcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:SafeArea(
            child:Container(
            // ignore: prefer_const_constructors
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/images/app bac.jpg'),
                fit: BoxFit.cover,

              ),

            ),
            
            // ignore: prefer_const_constructors
            child:Center(
                // ignore: sort_child_properties_last
                child:Container(
                    margin: const EdgeInsets.only(top: 110.0),
                    child:Column(
                        // ignore: prefer_const_literals_to_create_immutables
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                           Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 100.0,bottom:0.0 ),
                                    child: Text("Welcome to",
                                      style: GoogleFonts.lato(
                                      // ignore: prefer_const_constructors
                                      textStyle: TextStyle(
                                      color: const Color.fromARGB(255, 255, 255, 255),
                                  
                                        ) 
                                  
                                      )
                                                              
                                    ),
                                  ),


                                ],

                           ),
                           Row(
                              children: [
                                 
                                  const SizedBox(height: 0),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 30.0,top:0.0),
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 99.0,top: 0.0),
                                        child: Text("Sri travel",
                                            style: GoogleFonts.pacifico(
                                            // ignore: prefer_const_constructors
                                            textStyle: TextStyle(
                                              color: const Color.fromARGB(255, 255, 255, 255),
                                              fontSize: 40,
                                              
                                            ),
                                          
                                      
                                          ),
                                        ),
                                      ),
                                  )


                              ],

                            
                           ), 
                          
                          Row(
                             children: [
                                 Container(
                                  
                                   margin: const EdgeInsets.only(left: 35.0),
                                    

                                    child: Container(
                                      // ignore: prefer_const_constructors
                                      width: 300,
                                      height: 400,
                                      margin: const EdgeInsets.only(left: 0.0),
                                      decoration: const BoxDecoration(
                                        
                                        image: DecorationImage(
                                          image: AssetImage('assets/images/Rectangle 1.png'),
                                          fit: BoxFit.cover
                                    
                                            ),
                                        
                                        ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                            // ignore: prefer_const_literals_to_create_immutables
                                            
                                            children: [
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  // ignore: prefer_const_literals_to_create_immutables
                                                  children: [
                                                      Container(
                                                        width: 250,
                                                        height: 40,
                                                        
                                                        child: const TextField(
                                                          decoration: InputDecoration(
                                                            focusedBorder: OutlineInputBorder(
                                                              
                                                            )
                                                          ),
                                                        ),
                                                      )

                                                  ],


                                                ),
                                      
                                            ],
                                      
                                      
                                        ),
                                      ), 

                                    ),
                                    
                                  
                                 ) 
                                
                                
                             ], 

                          ),
                          
                        ],

                                          
                

                ),
                


              )
                
                
            ),
          )
        ) 
    );
  }
}