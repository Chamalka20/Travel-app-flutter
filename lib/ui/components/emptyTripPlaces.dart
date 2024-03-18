import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

import 'modalBottomSheetButton.dart';

class emptyTripPlaces extends StatefulWidget {

  final currentIndex;
  final BuildContext parentContext;
  const emptyTripPlaces({required this.currentIndex,required this.parentContext});

  @override
  State<emptyTripPlaces> createState() => _emptyTripPlacesState(currentIndex,parentContext);
}

class _emptyTripPlacesState extends State<emptyTripPlaces> {

  final currentIndex;
  final BuildContext parentContext;

  _emptyTripPlacesState(this.currentIndex, this.parentContext);

  @override
  Widget build(parentContext) {
    return Center(
           child: Container(
   
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top:20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/travel.png",width:40,height: 40,),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:8),
                          child: Container(
                            height:100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 80),
                                  child: Text("Add places to your trip day",
                                    style: GoogleFonts.cabin(
                                        // ignore: prefer_const_constructors
                                        textStyle: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                                                      
                                        ) 
                                      )
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                         SizedBox(
                          width: 200,
                          height: 45,
                          child: modalBottomSheetButton(currentIndex: widget.currentIndex, parentContext: widget.parentContext,)
                        ),
                  
                      ],
                    ),
                  )  
                ],
              ),
           ),
         );
    
  }
}