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
       appBar: AppBar( 
        toolbarHeight: 180,
        flexibleSpace: Container(
          color: Color.fromARGB(255, 250, 250, 250),
          child: Column(
            children: [
               Container(
                   
                    color: Color.fromARGB(98, 255, 255, 255),
                    child:Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top:22,left:10),
                          child: Row(
                            children: [
                               
                                Padding(
                                  padding: const EdgeInsets.only(left:100,top:35),
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
                                ),
                               
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:70,left:10),
                          child: SizedBox(
                            height: 50,
                              child: Row(
                                children: [
                                  Expanded(
                                  child: ListView.builder(
                                    cacheExtent: 9999,
                                    scrollDirection: Axis.horizontal, 
                                    itemCount: 6,
                                    itemBuilder: (context, index) {
                                      // final attraction = attractionList[index];
                                      // final placeId = attraction['id'];
                                      // final attractionName = attraction['name'];
                                      // final attractionImgUrl = attraction['photoRef'];
                                      // final attractionRating = attraction['rating'];
                                      // final address = attraction['address'];
                                      // final type = attraction['type'];
                                      
                                        return GestureDetector(
                                          onTap: ()=>{
                                            //dierect place details page again-------------------
                        
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(builder: (context) =>  locationDetails(placeId:placeId,searchType: 'attraction',)),
                                            // ),
                                          },
                                          child: Card(
                                          elevation: 0,
                                          color:Color.fromARGB(255, 230, 230, 230),
                                          clipBehavior: Clip.antiAliasWithSaveLayer,
                                          shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10.0),
                                                ),
                                          child:Container(
                                            width: 100,
                                            height:30,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Day ${index+1}',
                                                      style: GoogleFonts.cabin(
                                                                // ignore: prefer_const_constructors
                                                                textStyle: TextStyle(
                                                                color: const Color.fromARGB(255, 27, 27, 27),
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.bold,
                                                                                              
                                                                ) 
                                                               )
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            
                                          )
                                            
                                          
                                          ),
                                        ); 
                                    },
                                  ),  
                          
                                  ),
                                  Container(
                                    width: 40,
                                    height:40,
                                    color:Color.fromARGB(10, 230, 230, 230),
                                    child: Image.asset('assets/images/add-black.png')
                                    
                                    )
                                ],
                              ),
                          ),
                        ),
                      ],
                    )
                  )
              
            ],
          ),
        ),
      ),

       body:Container(
          child: Column(
            children: [
              Row(
                children: [
                  //top app bar-------------------------------------------
                 
                ],
              )
            ],
          ),
       ) 

    );
  }
}