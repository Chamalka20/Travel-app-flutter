import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelapp/createNewTrip.dart';
import 'package:travelapp/fechApiData.dart';

class mytrips extends StatefulWidget {
  const mytrips({super.key});

  @override
  State<mytrips> createState() => _mytripsState();
}

class _mytripsState extends State<mytrips> {

  var trips ;
  var onGoingTrips=[];
  var isDataReady = false;

   @override
  void initState() {
    super.initState();

    getTripList ();
  }

  Future <void> getTripList ()async{

    trips=await fechApiData.getTrips();
    //get currentDate----------------
    DateTime currentDate = DateTime.parse( DateFormat("yyyy-MM-dd").format(DateTime.now()));
    print(currentDate);

    setState(() {
      trips;
    });

  

    if(trips == null){

        setState(() {
          isDataReady= false;
          
        });
        
    }else{
         setState(() {
          isDataReady= true;
          
        });

      //filter ongoing trips--------------------------------
      var endDate;
      trips.forEach((data) => {
      
        endDate = data['endDate'],

        if(DateTime.parse(endDate).isAfter(currentDate)){
          
          onGoingTrips.add(data),
        
        }
        

      });

      print(onGoingTrips.length);

    }



    
  }


  @override
  Widget build(BuildContext context) {
    if(isDataReady == true){

      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 2,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Color.fromARGB(0, 255, 255, 255),
            statusBarIconBrightness: Brightness.dark, 
            ),
          elevation: 0,
          backgroundColor: Color.fromARGB(0, 20, 12, 12),

          
        ),
        body: Container(
          width: 360,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left:13,bottom: 10,top:12),
                child: Row(
                  children: [
                    Text("Plan",
                      style: GoogleFonts.nunito(
                          // ignore: prefer_const_constructors
                          textStyle: TextStyle(
                          color: const Color.fromARGB(255, 27, 27, 27),
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                  
                          ) 
                        )
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:13,bottom: 17,top:12),
                child: Row(
                  children: [
                    Text("Ongoing Trips",
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
              Container(
                height: 200,
                child: Expanded(
                  child:
                    Stack(
                      children: [
                        onGoingTrips.isNotEmpty?
                        ListView.builder(
                          cacheExtent: 9999, 
                          itemCount: onGoingTrips.length,
                          scrollDirection: Axis.horizontal, 
                          itemBuilder: (context, index) {
                            return
                              Padding(
                                padding: const EdgeInsets.only(bottom: 14,left:8),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
              
                                        final prefs = await SharedPreferences.getInstance();
                                        final encodata = json.encode(trips[index]);
                                        prefs.setString('tripdays',encodata );
              
                                        final tripId = trips[index]['tripId'];
                                        //find database user selectdoc id -----------------------------------------
                                        final tripDocId=await fechApiData.getTripDocId(tripId);
                                        await prefs.setString('triDocId',tripDocId );
              
                                        print("tripid: ${tripId}");
              
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const createNewTrip(placeName:'',placePhotoUrl: '',isEditTrip: true,)));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(right:11,),
                                        child: Container(
                                          width: 230,
                                          height: 160,
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(255, 216, 99, 99),
                                            borderRadius: BorderRadius.circular(17),
                                            image: DecorationImage(
                                            image: NetworkImage(trips[index]['tripCoverPhoto']),
                                            fit: BoxFit.cover
                                                        
                                              ),
                                          
                                          ),
                                          child:Padding(
                                            padding: const EdgeInsets.only(left:13,top:11),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      height:25,
                                                      width:60,
                                                      child: Card(
                                                          elevation: 0,
                                                            color:const Color.fromARGB(200, 240, 238, 238),
                                                            clipBehavior: Clip.antiAliasWithSaveLayer,
                                                            shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(5.0),
                                                                  ),
                                                              child: FittedBox(
                                                                      fit: BoxFit.cover,
                                                                      child:Padding(
                                                                        padding: const EdgeInsets.all(10.0),
                                                                        child: Text('${trips[index]["places"].length} days',
                                                                          style: GoogleFonts.cabin(
                                                                            // ignore: prefer_const_constructors
                                                                            textStyle: TextStyle(
                                                                            color: Color.fromARGB(255, 95, 95, 95),
                                                                            fontSize: 12,
                                                                            fontWeight: FontWeight.bold,
                                                                                                                                      
                                                                            ) 
                                                                          )
                                                                                                                                        
                                                                        ),
                                                                      ), 
                                                                )
                                                          
                                                      ),
                                                ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top:70),
                                                  child: Row(
                                                    children: [
                                                      
                                                      Text('${trips[index]['tripName']}',
                                                            style: GoogleFonts.cabin(
                                                          // ignore: prefer_const_constructors
                                                          textStyle: TextStyle(
                                                          color: Color.fromARGB(255, 255, 255, 255),
                                                          fontSize: 23,
                                                          fontWeight: FontWeight.bold,
                                                                                          
                                                          ) 
                                                      
                                                      ),
                                                    ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top:4),
                                                  child: Row(
                                                    children: [
                                                      
                                                      Text('${trips[index]['tripDuration']}',
                                                            style: GoogleFonts.cabin(
                                                          // ignore: prefer_const_constructors
                                                          textStyle: TextStyle(
                                                          color: Color.fromARGB(255, 255, 255, 255),
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.bold,
                                                                                          
                                                          ) 
                                                      
                                                      ),
                                                    ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                          
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                          
                          }
                        
                        ):
                        Padding(
                          padding: const EdgeInsets.only(top:47),
                          child: Container(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center, 
                                  children: [
                                    Image.asset('assets/images/destination.png',width:45,height:45)
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center, 
                                  children: [
                                    Text("You have no ongoing trips",
                                       style: GoogleFonts.cabin(
                                              // ignore: prefer_const_constructors
                                              textStyle: TextStyle(
                                              color: const Color.fromARGB(255, 27, 27, 27),
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
                        ),
              
                        // Positioned(
                        //   top:450,
                        //   left:95,
                        //   child: Column(
                        //     children: [
                        //       Row(
                        //         children: [
                        //           SizedBox(
                        //             width: 155,
                        //             height: 45,
                        //             child: TextButton(
                        //               onPressed:() async{
                                      
              
                        //                   Navigator.push(
                        //                   context,
                        //                   MaterialPageRoute(builder: (context) => const createNewTrip(placeName:'',placePhotoUrl: '',isEditTrip: false,)));
                                        
                        //               },
                        //               style: ElevatedButton.styleFrom(
                        //                 backgroundColor: Color.fromARGB(255, 0, 0, 0),
                        //                 foregroundColor:Color.fromARGB(255, 255, 255, 255),
                        //                 shape: RoundedRectangleBorder(
                        //                     borderRadius: BorderRadius.circular(20), 
                        //                   ),
                                        
                        //               ),
                        //               child: Text('Create a new trip',
                        //                   style: GoogleFonts.roboto(
                        //                       fontWeight: FontWeight.bold,
                        //                       fontSize: 15,
                                              
                                      
                        //                   ),
                                      
                        //               ),
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                          
                        // )
                      ]
                    )
                  
                  ),
              ),
                Padding(
                padding: const EdgeInsets.only(left:13,bottom: 17),
                child: Row(
                  children: [
                    Text("Past Trips",
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
              //past trip list -------------------------------------------
              Expanded(
                  child:
                    Stack(
                      children: [
                        onGoingTrips.isNotEmpty?
                        ListView.builder(
                          cacheExtent: 9999, 
                          itemCount: onGoingTrips.length,
                          itemBuilder: (context, index) {
                            return
                              GridView.count(
                                shrinkWrap: true,
                                crossAxisCount: 2,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
              
                                      final prefs = await SharedPreferences.getInstance();
                                      final encodata = json.encode(trips[index]);
                                      prefs.setString('tripdays',encodata );
              
                                      final tripId = trips[index]['tripId'];
                                      //find database user selectdoc id -----------------------------------------
                                      final tripDocId=await fechApiData.getTripDocId(tripId);
                                      await prefs.setString('triDocId',tripDocId );
              
                                      print("tripid: ${tripId}");
              
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const createNewTrip(placeName:'',placePhotoUrl: '',isEditTrip: true,)));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right:11,),
                                      child: Container(
                                        width: 180,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(255, 216, 99, 99),
                                          borderRadius: BorderRadius.circular(17),
                                          image: DecorationImage(
                                          image: NetworkImage(trips[index]['tripCoverPhoto']),
                                          fit: BoxFit.cover
                                                      
                                            ),
                                        
                                        ),
                                        child:Padding(
                                          padding: const EdgeInsets.only(left:13,top:11),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    height:25,
                                                    width:60,
                                                    child: Card(
                                                        elevation: 0,
                                                          color:const Color.fromARGB(200, 240, 238, 238),
                                                          clipBehavior: Clip.antiAliasWithSaveLayer,
                                                          shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(5.0),
                                                                ),
                                                            child: FittedBox(
                                                                    fit: BoxFit.cover,
                                                                    child:Padding(
                                                                      padding: const EdgeInsets.all(10.0),
                                                                      child: Text('${trips[index]["places"].length} days',
                                                                        style: GoogleFonts.cabin(
                                                                          // ignore: prefer_const_constructors
                                                                          textStyle: TextStyle(
                                                                          color: Color.fromARGB(255, 95, 95, 95),
                                                                          fontSize: 12,
                                                                          fontWeight: FontWeight.bold,
                                                                                                                                    
                                                                          ) 
                                                                        )
                                                                                                                                      
                                                                      ),
                                                                    ), 
                                                              )
                                                        
                                                    ),
                                              ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top:70),
                                                child: Row(
                                                  children: [
                                                    
                                                    Text('${trips[index]['tripName']}',
                                                          style: GoogleFonts.cabin(
                                                        // ignore: prefer_const_constructors
                                                        textStyle: TextStyle(
                                                        color: Color.fromARGB(255, 255, 255, 255),
                                                        fontSize: 23,
                                                        fontWeight: FontWeight.bold,
                                                                                        
                                                        ) 
                                                    
                                                    ),
                                                  ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top:4),
                                                child: Row(
                                                  children: [
                                                    
                                                    Text('${trips[index]['tripDuration']}',
                                                          style: GoogleFonts.cabin(
                                                        // ignore: prefer_const_constructors
                                                        textStyle: TextStyle(
                                                        color: Color.fromARGB(255, 255, 255, 255),
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.bold,
                                                                                        
                                                        ) 
                                                    
                                                    ),
                                                  ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                        
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                          
                          }
                        
                        ):
                        Padding(
                          padding: const EdgeInsets.only(top:47),
                          child: Container(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center, 
                                  children: [
                                    Image.asset('assets/images/destination.png',width:45,height:45)
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center, 
                                  children: [
                                    Text("You have no ongoing trips",
                                       style: GoogleFonts.cabin(
                                              // ignore: prefer_const_constructors
                                              textStyle: TextStyle(
                                              color: const Color.fromARGB(255, 27, 27, 27),
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
                        ),
              
                        // Positioned(
                        //   top:450,
                        //   left:95,
                        //   child: Column(
                        //     children: [
                        //       Row(
                        //         children: [
                        //           SizedBox(
                        //             width: 155,
                        //             height: 45,
                        //             child: TextButton(
                        //               onPressed:() async{
                                      
              
                        //                   Navigator.push(
                        //                   context,
                        //                   MaterialPageRoute(builder: (context) => const createNewTrip(placeName:'',placePhotoUrl: '',isEditTrip: false,)));
                                        
                        //               },
                        //               style: ElevatedButton.styleFrom(
                        //                 backgroundColor: Color.fromARGB(255, 0, 0, 0),
                        //                 foregroundColor:Color.fromARGB(255, 255, 255, 255),
                        //                 shape: RoundedRectangleBorder(
                        //                     borderRadius: BorderRadius.circular(20), 
                        //                   ),
                                        
                        //               ),
                        //               child: Text('Create a new trip',
                        //                   style: GoogleFonts.roboto(
                        //                       fontWeight: FontWeight.bold,
                        //                       fontSize: 15,
                                              
                                      
                        //                   ),
                                      
                        //               ),
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                          
                        // )
                      ]
                    )
                  
                  ),

            ],
          ),
        ),

      );

    }else{

      return const Center(
        child: CircularProgressIndicator(),
      );


    } 
  }
}