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
            child: SingleChildScrollView(
              
              child:Container(
                height: 700.0,  
              // ignore: prefer_const_constructors
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/app bac.jpg'),
                    fit:BoxFit.cover,
                    alignment: Alignment.center,

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
                                                        // ignore: prefer_const_literals_to_create_immutables
                                                        children: [
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 12.0,top: 12.0),
                                                              child: Container(
                                                                width: 250,
                                                                height: 40,
                                                                
                                                                child: const TextField(
                                                                  decoration: InputDecoration(
                                                                    filled: true,
                                                                    fillColor: Color.fromARGB(255, 255, 255, 255),
                                                                    border: OutlineInputBorder(
                                                                      borderSide: BorderSide.none,
                                                                    
                                                                    ),
                                                                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),


                                                        ],

                                                      ),
                                                      Row(
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.only(left: 12.0,top: 12.0),
                                                                child: SizedBox(
                                                                    width: 250,
                                                                    height: 40,
                                                                    child: TextButton(
                                                                      onPressed: () {
                                                                        // Do something when the button is pressed
                                                                      },
                                                                      style: ButtonStyle(
                                                                        backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 10, 124, 132)),
                                                                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                                      ),
                                                                      child: Text('Continue',
                                                                          style: GoogleFonts.roboto(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 15,

                                                                          ),
                                                                      
                                                                      ),
                                                                    ),
                                                                  ),
                                                              ),
                                                            ],
                                                      ),
                                                      Row(
                                                          children: [
                                                            Container(
                                                              margin: const EdgeInsets.only(left: 123.0,top: 15.0),
                                                              child: Text("Or",
                                                                style:GoogleFonts.roboto(
                                                                    textStyle: const TextStyle(
                                                                        color: Color.fromARGB(255, 255, 255, 255),
                                                                        fontSize: 17,
                                                                        fontWeight: FontWeight.bold,
                                                                        ),  
                                                                ),
                                                              
                                                              )
                                                              
                                                              
                                                              ),
                                                          ],


                                                      ),

                                                        Row(
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.only(left: 12.0,top: 12.0),
                                                                child: SizedBox(
                                                                    width: 250,
                                                                    height: 40,
                                                                    child: TextButton(
                                                                      onPressed: () {
                                                                        // Do something when the button is pressed
                                                                      },
                                                                      style: ButtonStyle(
                                                                        backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 231, 231, 231)),
                                                                        foregroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 0, 0, 0)),
                                                                      ),
                                                                      child:Padding(
                                                                        padding: const EdgeInsets.only(left: 17.0),
                                                                        child: Column(
                                                                          children: [
                                                                            Row(
                                                                              // ignore: prefer_const_literals_to_create_immutables
                                                                              children: [
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(right: 8.0),
                                                                                  child: Image.asset("assets/images/Facebook_Logo_(2019).png.webp",
                                                                                    width:24,
                                                                                    height: 24,
                                                                                  ),
                                                                                ),
                                                                                Text("Continue with Facebook",
                                                                                    style:GoogleFonts.roboto(
                                                                                    textStyle: const TextStyle(
                                                                                    color: Color.fromARGB(255, 0, 0, 0),
                                                                                    fontSize: 14,
                                                                                    fontWeight: FontWeight.bold,
                                                                                    ),  
                                                                                  ),
                                                                                
                                                                                ),
                                                                              ],
                                                                      
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ), 
                                                                      
                                                                    ),
                                                                  ),
                                                              ),
                                                            ],
                                                      ),
                                                      Row(
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.only(left: 12.0,top: 12.0),
                                                                child: SizedBox(
                                                                    width: 250,
                                                                    height: 40,
                                                                    child: TextButton(
                                                                      onPressed: () {
                                                                        // Do something when the button is pressed
                                                                      },
                                                                      style: ButtonStyle(
                                                                        backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 231, 231, 231)),
                                                                        foregroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 0, 0, 0)),
                                                                      ),
                                                                      child:Padding(
                                                                        padding: const EdgeInsets.only(left: 17.0),
                                                                        child: Column(
                                                                          children: [
                                                                            Row(
                                                                              // ignore: prefer_const_literals_to_create_immutables
                                                                              children: [
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(right: 8.0),
                                                                                  child: Image.asset("assets/images/google-logo-png-webinar-optimizing-for-success-google-business-webinar-13.png",
                                                                                    width:24,
                                                                                    height: 24,
                                                                                  ),
                                                                                ),
                                                                                Text("Continue with Google",
                                                                                    style:GoogleFonts.roboto(
                                                                                    textStyle: const TextStyle(
                                                                                    color: Color.fromARGB(255, 0, 0, 0),
                                                                                    fontSize: 14,
                                                                                    fontWeight: FontWeight.bold,
                                                                                    ),  
                                                                                  ),
                                                                                
                                                                                ),
                                                                              ],
                                                                      
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ), 
                                                                      
                                                                    ),
                                                                  ),
                                                              ),
                                                            ],
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left:12.0),
                                                        child: Row(
                                                            // ignore: prefer_const_literals_to_create_immutables
                                                            children: [
                                                              Text("Don't have an account?",
                                                                style: GoogleFonts.roboto(
                                                                    color: const Color.fromARGB(255, 255, 255, 255)
                                                                ),
                                                              ),
                                                              TextButton(
                                                                    onPressed: () {
                                                                      // Do something when the button is pressed
                                                                    },
                                                                    style: ButtonStyle(
                                                                      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                                                                    ),
                                                                    child:Text("Sign up",
                                                                        style: GoogleFonts.roboto(
                                                                          color: const Color.fromARGB(255, 27, 199, 211)
                                                                        ),
                                                                    ) ,
                                                                    
                                                                  ),
                                                              
                                                      
                                                            ],
                                                      
                                                      
                                                        ),
                                                      ),
                                                      Row(
                                                          children: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  // Do something when the button is pressed
                                                                },
                                                                style: ButtonStyle(
                                                                  
                                                                  padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                                                                ),
                                                                child:Text("Forgot your password?",
                                                                    style: GoogleFonts.roboto(
                                                                      color: const Color.fromARGB(255, 27, 199, 211),
                                                                      
                                                                    ),
                                                                ) ,
                                                                
                                                              ),


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
        ) 
    );
  }
}