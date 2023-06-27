import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';

class tripDetailsPlan extends StatefulWidget {
  const tripDetailsPlan({super.key});

  @override
  State<tripDetailsPlan> createState() => _tripDetailsPlanState();
}

class _tripDetailsPlanState extends State<tripDetailsPlan> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(

       body:Container(
          child: Column(
            children: [
              Row(
                children: [
                  //top app bar-------------------------------------------
                  Container(
                    width: 360,
                    height: 150,
                    color: Color.fromARGB(99, 161, 41, 41),
                    child:Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top:22,left:10),
                          child: Row(
                            children: [
                               IconButton(
                                  icon: const Icon(Icons.arrow_back),
                                  color: Color.fromARGB(255, 43, 42, 42),
                                  iconSize: 34,
                                  onPressed: () {
                        
                                    Navigator.pop(context);
                        
                                    // Handle back button press
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left:47),
                                  child: Text("Trip Details Plan",
                                    style: GoogleFonts.cabin(
                                        // ignore: prefer_const_constructors
                                        textStyle: TextStyle(
                                        color: const Color.fromARGB(255, 27, 27, 27),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                                              
                                        ) 
                                      )
                                  ),
                                )
                            ],
                          ),
                        )
                      ],
                    )
                  )
                ],
              )
            ],
          ),
       ) 

    );
  }
}