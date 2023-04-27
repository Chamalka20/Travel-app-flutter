import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'Welcomepage.dart';
import 'customPageRoutes.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(customPageRoutes(
            
        child:const welcomePage()));

        return false;
      },
     child:Scaffold(
        body: SafeArea(
          child:SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Container(
              height: 700.0, 
              decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/app bac.jpg'),
                    fit:BoxFit.cover,
                    alignment: Alignment.center,

                  ),

                ),
                child: Center(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 50.0,top:180.0, ),
                              child: Text("Log in",
                                style: GoogleFonts.lato(
                                  // ignore: prefer_const_constructors
                                  textStyle: TextStyle(
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,

                                 ) 
                                )
                              ),
                            )
                          ],

                        ),
                        
                        Row(
                          children: [
                            Container(
                               margin: const EdgeInsets.only(left: 35.0,),
                                height: 300,
                                width: 300,
                              child: Container(
                                  // ignore: prefer_const_constructors
                                  
                                  margin: const EdgeInsets.only(left: 0.0),
                                  decoration: const BoxDecoration(
                                    
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/Rectangle 1 loging.png'),
                                     
                                
                                        ),
                                    
                                    ), 

                                child: Column(
                                    children: [
                                        Row(
                                          children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 20.0),
                                            child: Padding(
                                              padding: const EdgeInsets.only(left:25,top:10),
                                              child: Container(
                                                width: 45,
                                                height: 45,
                                                child: const CircleAvatar(
                                                  radius: 40,
                                                  backgroundImage:AssetImage("assets/images/youtube logo.png"),
                                                  
                                                ),
                                              ),
                                            ),
                                          ),

                                           Column(
                                             children: [

                                               Row(
                                                 children: [
                                                   Padding(
                                                     padding: const EdgeInsets.only(left:10,top:25),
                                                     child: Text("Nimal Jayakodi",
                                                        style: GoogleFonts.poppins(
                                                            textStyle: const TextStyle(
                                                              color: Color.fromARGB(255, 255, 255, 255),
                                                              fontSize: 18,
                                                                                 
                                                              ), 
                                                   
                                                   
                                                        ),
                                                                                             
                                                      ),
                                                   ),
                                                 ],
                                               ),
                                               Row(
                                                  children: [
                                                       Padding(
                                                         padding: const EdgeInsets.only(left:10),
                                                         child: Text("nimal1234@gmail.com",
                                                          style: GoogleFonts.poppins(
                                                              textStyle: const TextStyle(
                                                                color: Color.fromARGB(255, 255, 255, 255),
                                                                fontSize: 12,
                                                                                   
                                                                ), 
                                                                                                          
                                                                                                          
                                                          ),
                                                                                               
                                                                                                             ),
                                                       ),


                                                  ],



                                               )
                                             ],
                                           ),  
                                          ],

                                        ),
                                        Row(
                                          children: [
                                             Padding(
                                               padding: const EdgeInsets.only(left:25,top:24),
                                               child: Container(
                                                width: 250,
                                                height: 40,
                                                 child: const TextField(
                                                    obscureText: true,
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: Color.fromARGB(255, 255, 255, 255),
                                                      hintText: 'Password',
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
                                               padding: const EdgeInsets.only(left:25,top:24),
                                               child: Container(
                                                  width: 250,
                                                  height: 40, 
                                                 child: TextButton(
                                                    onPressed: () {
                                                       
                                                      
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
                                              Padding(
                                                padding: const EdgeInsets.only(top:35.0,left: 25),
                                                child: Container(
                                                  child: Text("Forgot your password?",
                                                      style: GoogleFonts.roboto(
                                                        color: const Color.fromARGB(255, 27, 199, 211),
                                                        
                                                      ),
                                                  ),
                                                ),
                                              ) ,
                                          ],

                                        )
                                    ], 


                                ),  

                              ),

                            )
                              
                          ],

                        )
                      ],
                    ),
                  ),

                ),
            ),

          )
        ),



      )
    );
  }
}