import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'Welcomepage.dart';
import 'customPageRoutes.dart';

class letsStart extends StatefulWidget {
  const letsStart({super.key});

  @override
  State<letsStart> createState()  => _MyWidgetState();
}

class _MyWidgetState extends State<letsStart> {
  @override
  Widget build(BuildContext context) {
     return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).push(customPageRoutes(
            
        child:const welcomePage()));

        return false;
      },
    child: Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
               padding: const EdgeInsets.only(top:80),
              child: SizedBox(
                height: 250,
                width:300,
                child: Lottie.asset("assets/images/143784-checklist.json",
                  repeat: false,
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left:15),
                  child: Text("Let's get started",
                    style: GoogleFonts.lato(
                        // ignore: prefer_const_constructors
                        textStyle: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
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
                Padding(
                  padding: const EdgeInsets.only(left:15),
                  child: Text("your journey",
                    style: GoogleFonts.lato(
                        // ignore: prefer_const_constructors
                        textStyle: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
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
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0,top: 20.0),
                      child: SizedBox(
                          width: 320,
                          height: 45,
                          child: TextButton(
                            onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const letsStart()),
                                    );
                              
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 0, 0, 0),
                              foregroundColor:Color.fromARGB(255, 245, 245, 245),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20), // Set the radius here
                                ),
                              
                            ),
                            child: Text('Track location automatically',
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
                      padding: const EdgeInsets.only(left: 16.0,top: 20.0),
                      child: SizedBox(
                          width: 320,
                          height: 45,
                          child: TextButton(
                            onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const letsStart()),
                                    );
                              
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 255, 255, 255),
                              foregroundColor:Color.fromARGB(255, 0, 0, 0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20), // Set the radius here
                                ),
                              
                            ),
                            child: Text('Choose location',
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    
                            
                                ),
                            
                            ),
                          ),
                        ),
                    ),

                ],


              )


          ],
        ),
        
      ),
      )
    );
  }
}