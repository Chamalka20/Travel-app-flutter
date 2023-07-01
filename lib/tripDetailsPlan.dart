import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelapp/Home.dart';
import 'package:travelapp/search.dart';
import 'package:travelapp/fechApiData.dart';

import 'customPageRoutes.dart';

class tripDetailsPlan extends StatefulWidget {
  const tripDetailsPlan({super.key});

  @override
  State<tripDetailsPlan> createState() => _tripDetailsPlanState();
}

class _tripDetailsPlanState extends State<tripDetailsPlan> {

  
  List listTiles = [1, 2, 3, 4,5,6,'addDay'];
  var day = 1;
  var currentIndex = 0 ;
  var  tripPlaces;
  var addPlaces =[];
  late List<dynamic>  data ;

   @override
  void initState() {
    super.initState();

   listSelectedPlaces (); 
     
  }

  Future <void> listSelectedPlaces ()async{

    final prefs = await SharedPreferences.getInstance();
    final tripPlace = prefs.getString('TripPlaceIds');

    final decodeData = jsonDecode(tripPlace!);

    data = await fechApiData.getattractionDetails();


    addPlaces=data.map((element) { 

      if(decodeData[0]['places'].contains(element['placeId'])){

        return{
          "name":element['title'],
          "photo_reference":element['imageUrls'][0],

        };

      }

    }).where((element) => element != null).toList();  

    if(addPlaces!=null){
      tripPlaces=addPlaces;
    }
    
    print(addPlaces);

  }

  @override
  Widget build(BuildContext context) {
   return  WillPopScope(
     onWillPop: () async {
         bool confirmExit = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Alert'),
                    content: const Text('Do you want to save this?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          // User confirmed exit
                          
                        },
                        child: Text('Yes'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(customPageRoutes(
                    
                          child: home(isBackButtonClick:true))); 
                        },
                        child: Text('No'),
                      ),
                    ],
                  );
                },
              );
      return false;
      }, 
     child: Scaffold(
         appBar: AppBar( 
         leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
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
                            padding: const EdgeInsets.only(top:70,left:10,right: 10),
                            child: SizedBox(
                              height: 50,
                                child: Row(
                                  children: [
                                    Expanded(
                                    child: ListView.builder(
                                      cacheExtent: 9999,
                                      scrollDirection: Axis.horizontal, 
                                      itemCount: listTiles.length,
                                      itemBuilder: (context, index) {
                                        // final attraction = attractionList[index];
                                        // final placeId = attraction['id'];
                                        // final attractionName = attraction['name'];
                                        // final attractionImgUrl = attraction['photoRef'];
                                        // final attractionRating = attraction['rating'];
                                        // final address = attraction['address'];
                                        // final type = attraction['type'];
   
                                        if (index == listTiles.length - 1) {
                                          return GestureDetector(
                                            onTap: () {
                                              
                                            },
                                            child: Container(
                                                width: 40,
                                                height:40,
                                                color:Color.fromARGB(0, 230, 230, 230),
                                                child: Image.asset('assets/images/add-black.png')
                                                
                                                ),
                                          );
                                        }else{
   
                                          return InkWell(
                                            onTap: ()=>{
                                              setState(() {
   
                                                day =listTiles[index];
                                                currentIndex = index;
   
                                              }),
   
                                            },
                                            child: Card(
                                            elevation: 0,
                                            color:currentIndex==index?Color.fromARGB(255, 0, 0, 0):Color.fromARGB(255, 230, 230, 230),
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
                                                                  color: currentIndex==index?Color.fromARGB(255, 255, 255, 255):Color.fromARGB(255, 0, 0, 0),
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
   
                                        }
                                           
                                      },
                                    ),  
                            
                                    ),
                                    
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
   
         body:Center(
           child: Container(
   
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  tripPlaces!=null?
                    Row(
                      children: [],
                    )
                  :
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
                                  child: Text("Add places to your trip",
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
                          child: TextButton(
                            onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                  ), 
                                builder: (BuildContext context) { 
   
                                  return
                                    SizedBox(
                                    height:200,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            // get atrractions---------------------------------------------
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) =>  const search(isTextFieldClicked: true,searchType: 'attraction',isSelectPlaces: true,)));
                                                
                                              },
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: 70,
                                                        height:70,
                                                         decoration: BoxDecoration(
                                                          color: const Color.fromARGB(255, 240, 238, 238),
                                                          borderRadius: BorderRadius.circular(45)
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Image.asset("assets/images/flash.png",width:40,height:40),
                                                              ],
                                                            ),
                                                          ],
                                                        )
                                                        ),
                                                    ],
                                                  ),
                                                  Row(
                                                    
                                                    children: [
                                                      Text("Attracrions")
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            // get resturents----------------------------------------------------
                                            GestureDetector(
                                              onTap: () {
   
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) =>  const search(isTextFieldClicked: true,searchType: 'restaurant',isSelectPlaces: true,)));
                                                
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(right:33,left:33),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: 70,
                                                          height:70,
                                                           decoration: BoxDecoration(
                                                            color: const Color.fromARGB(255, 240, 238, 238),
                                                            borderRadius: BorderRadius.circular(45)
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  SizedBox(child: Image.asset("assets/images/hotel.png",width:40,height:40)),
                                                                ],
                                                              ),
                                                            ],
                                                          )
                                                          ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text("Resturants")
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            //get your like places----------------------------------------------------------
                                            GestureDetector(
                                              onTap: () {
                                                
                                              },
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: 70,
                                                        height:70,
                                                         decoration: BoxDecoration(
                                                          color: const Color.fromARGB(255, 240, 238, 238),
                                                          borderRadius: BorderRadius.circular(45)
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Image.asset("assets/images/heartBlack.png",width:40,height:40),
                                                              ],
                                                            ),
                                                          ],
                                                        )
                                                        ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text("Your Favorites")
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    
                                    );
   
                                  }, 
                                
                              
                              );
                              
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 0, 0, 0),
                              foregroundColor:Color.fromARGB(255, 255, 255, 255),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20), 
                                ),
                              
                            ),
                            child: Text('Add place',
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    
                            
                                ),
                            
                            ),
                          ),
                                           ),
                  
                      ],
                    ),
                  )  
                ],
              ),
           ),
         ) 
   
      ),
   );
  }
}