import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelapp/fechApiData.dart';
import 'package:travelapp/tripDetailsPlan.dart';

import 'customPageRoutes.dart';
import 'locationDetails.dart';

class search extends StatefulWidget {

  final isTextFieldClicked;
  final searchType;
  final isSelectPlaces;

  const search({required this.isTextFieldClicked,required this.searchType,required this.isSelectPlaces, Key? key}) : super(key: key);

  @override
  State<search> createState() => _searchState(isTextFieldClicked,searchType,isSelectPlaces);
}

 class _searchState extends State<search> {

  var isTextFieldClicked;
  var searchType;
  var isSelectPlaces;
  var isDataReady;
  String keyboardInput='';
  var searchResults=[];
  Timer? _debounce;
  List selectedIds =[{
      'day':"" ,
      'places':[],
    }];
  bool isOnLongPress = false;
  late List<dynamic>  data ;
  
  
  _searchState( this.isTextFieldClicked,this.searchType,this.isSelectPlaces);


   @override
  void initState() {
    super.initState();
    
    
    setState(() {

      isTextFieldClicked;
     });
    _asyncMethod();
     
  }

 _asyncMethod() async {

    //get data list from database-------------------------------

    if(searchType =='city'){
  
       data = await fechApiData.getCityDetails();
      
      if(data == null){

        setState(() {
          isDataReady= false;
        });
        
      }else{
         setState(() {
          isDataReady= true;
        });
      }
      

    }else if(searchType =='attraction'){
      data = await fechApiData.getattractionDetails();

      if(data == null){

        setState(() {
          isDataReady= false;
        });
        
      }else{
         setState(() {
          isDataReady= true;
        });
      }
      

    }else if(searchType =='restaurant'){
      data = await fechApiData.getResturantDetails();

      if(data == null){

        setState(() {
          isDataReady= false;
        });
        
      }else{
         setState(() {
          isDataReady= true;
        });
      }

    }
  


  } 
  
  
 Future<void> fetchSearchResults(String input) async {

    keyboardInput = input;

    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {

      try{
        
        setState(() {
            searchResults=data.map((element) { 

              final city =searchType=='city'? element['city']:element['title'];

              if (city != null && city.toLowerCase().contains(keyboardInput.toLowerCase())) {
                if (element['imageUrls'] != null && element['imageUrls'].isNotEmpty) {
                  return {
                    'name': city,
                    'photo_reference': element['imageUrls'][0],
                    'placeId': element['placeId'],
                    

                  };
                } else {
                  return {
                    'name': city,
                    'photo_reference': 'https://via.placeholder.com/150',
                  };
                }
              }

              return null;
            }).where((element) => element != null).toList();

          });
     
      
    }catch (e) {

    print('Error: $e');

    }
        
    });
    
    

  }

 
  

  @override
  Widget build(BuildContext context) {
    if(isDataReady == true){
    return 
       Scaffold(
        body:Column(
          children: [
            Visibility(
              visible: !isTextFieldClicked,
              child: Padding(
                padding: const EdgeInsets.only(left:13.0,top:40.0,bottom:6.0),
                child: Row(
                  children: [
                    Text("Search",
                          style: GoogleFonts.nunito(
                                      // ignore: prefer_const_constructors
                                      textStyle: TextStyle(
                                      color: const Color.fromARGB(255, 27, 27, 27),
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                              
                                      ) 
                                    )
                        
                        ),
                    
                  ]  
                ),
              ),
            ),
            Padding(
              padding:isTextFieldClicked? const EdgeInsets.only(top:40):const EdgeInsets.only(top:25),
              child: Row(
            
                children: [
                   Visibility(
                    visible: isTextFieldClicked,
                     child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: const Color.fromARGB(255, 145, 144, 144),
                        iconSize: 26,
                        onPressed: () {
                   
                          setState(() {
                          isTextFieldClicked = false;
                          });       
                   
                          // Handle back button press
                        },
                     ),
                   ),
                   
                  
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        
                       
                        height: 37,
                        
                        child:  TextField(
                          
                          onTap: () {
                            setState(() {
                              isTextFieldClicked = true;
                              searchResults = [];
                              isOnLongPress = false;
                            });
                          },
                          //get keyboard input value-------------
                          onChanged: (value) {
                             //if text filed is empty do this------------------ 
                            if(value ==''){
                              setState(() {
                                searchResults = [];
                              });
                            }else{
                              fetchSearchResults(value);
                              isTextFieldClicked = true;

                            }

                          },
                          decoration: InputDecoration(
                          filled: true,
                          fillColor:  Color.fromARGB(255, 240, 238, 238),
                          hintText: 'Search',
                          prefixIcon: Icon(Icons.search),
                          hintStyle: GoogleFonts.cabin(
                                        // ignore: prefer_const_constructors
                                        textStyle: TextStyle(
                                        color: Color.fromARGB(255, 145, 144, 144),
                                        fontSize: 17,
                                        fontWeight:FontWeight.w400,
                                        
                                        ) 
                                      ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(19.0),
                            
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                          ),
                      
                      
                        ),
                      ),
                    ),
                  )

            
                ],
                   
                      
                  
              ),
            ),
            Visibility(
              visible: !isTextFieldClicked,
              child: Padding(
                 padding: const EdgeInsets.only(left:13,top:30),
                child: Row(
              
                  children: [
                    Text("Your recent searches",
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
            ),
            //show search results-----------------------------------
            Visibility(
              visible: isTextFieldClicked,
              child: Expanded(
                child:Stack(
                  children:[ 
                    ListView.builder(
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final searchRe = searchResults[index];
                        final name = searchRe['name'];
                        final photoReference = searchRe['photo_reference'];
                        final  placeId = searchRe['placeId'];
                        
                        
                              
                        return Column(
                          children: [
                            //set bottom border-----------------------------
                            GestureDetector(
                              onLongPress: () {
                  
                                // visible only places select------------------- 
                                if(isSelectPlaces ==true){
                  
                                  setState(() {
                                  isOnLongPress = true;
                                });
                  
                                }
                                
                                
                              },
                              onTap: () {
                  
                                if(isOnLongPress!= true){
                  
                                  if(searchType == 'city'){
                  
                                  Navigator.of(context).pushReplacement(customPageRoutes(
                    
                                  child: locationDetails(placeId:placeId,searchType:'city')));
                  
                                }else if(searchType == 'attraction'){
                                  Navigator.of(context).pushReplacement(customPageRoutes(
                    
                                  child: locationDetails(placeId:placeId,searchType:'attraction')));
                  
                  
                                }
                  
                                }
                  
                                
                              
                                
                              
                              },
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left:6),
                                    child: Container(
                                      width: 340,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Color.fromARGB(255, 226, 226, 226).withOpacity(0.5), 
                                            width: 1, 
                                          ),
                                        ),
                                      ),//------------------------
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 9),
                                              child: Container(
                                                width:37,
                                                height:37,
                                                child: CircleAvatar(
                                                  radius: 40,
                                                  backgroundImage:NetworkImage(photoReference),
                                                  
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left:6),
                                              child: Column(
                                                
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(bottom:4),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width:245,
                                                          child: Text(name,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: GoogleFonts.cabin(
                                                              // ignore: prefer_const_constructors
                                                              textStyle: TextStyle(
                                                              color: const Color.fromARGB(255, 27, 27, 27),
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w700,
                                                                                                      
                                                              ) 
                                                            )
                                                          ),
                                                        ),
                                                        
                                                      ],
                                                    ),
                                                  ),
                                                  
                                                ],
                                              ),
                                            ),
                                            Visibility(
                                              visible: isOnLongPress,
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                            
                                                    if(selectedIds[0]['places'].contains(placeId)){
                                                    selectedIds[0]['places'].remove(placeId);
                                            
                                                    }else{
                                                      selectedIds[0]['places'].add(placeId);
                                            
                                                    }
                                                    
                                                  });
                                            
                                                      print(selectedIds);
                                                },
                                                child: SizedBox(
                                                  height: 25,
                                                  width: 25,
                                                  child:selectedIds[0]['places'].contains(placeId)?Image.asset("assets/images/correct.png") :Image.asset("assets/images/dry-clean.png")
                                                  
                                                  ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ), 
                                    ),
                                  ),
                                ],
                              ),
                            )
                            
                                  
                          ],
                                  
                        );
                              
                      }
                    ),
                    Visibility(
                      visible: isOnLongPress,
                      child: Positioned(
                        top:565,
                        left:95,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                        width: 155,
                                        height: 45,
                                        child: TextButton(
                                          onPressed:() async{
                                            //temporally store trip places---------------------------
                                            final prefs = await SharedPreferences.getInstance();
                                            final data = json.encode(selectedIds);
                                            prefs.setString('TripPlaceIds',data );
                                            final isEditPlace =prefs.getBool('isEditTrip');
    
                                            if(isEditPlace == true){
                                             Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) =>  tripDetailsPlan(isSelectPlaces: true,isEditPlace: true,)));
                                            }else{

                                              Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) =>  tripDetailsPlan(isSelectPlaces: true,isEditPlace: false,)));

                                            }  
                                            
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color.fromARGB(255, 0, 0, 0),
                                            foregroundColor:Color.fromARGB(255, 255, 255, 255),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20), 
                                              ),
                                            
                                          ),
                                          child: Text('Add to trip',
                                              style: GoogleFonts.roboto(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  
                                          
                                              ),
                                          
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        ),
                        
                      ),
                    )
                  ]
                )
                
                
              ),
            ),
            //------------------------------------------------------
            Visibility(
              visible: !isTextFieldClicked,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                        
                          child: Card(
                            elevation: 0,
                            color:const Color.fromARGB(255, 240, 238, 238),
                            //clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(17.0),
                                  ),
                        
                            child:Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center, 
                              children: [
                                SizedBox(
                                 
                                  
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                     
                                      FittedBox(
                                        fit: BoxFit.cover,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left:8,right:8,top:8,bottom:8),
                                          child: Text("Galle",
                                                style: GoogleFonts.cabin(
                                            // ignore: prefer_const_constructors
                                            textStyle: TextStyle(
                                            color: const Color.fromARGB(255, 27, 27, 27),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                                                          
                                            ) 
                                            )
                                          ),
                                        ),
                                      ),          
                                    ],
                                  ),
                                ),
                                
                              ],
                                            
                                            
                            )
                          ),
                        ),
                      ],
                    ),
                     Row(
                      children: [
                        SizedBox(
                        
                          child: Card(
                            elevation: 0,
                            color:const Color.fromARGB(255, 240, 238, 238),
                            //clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(17.0),
                                  ),
                        
                            child:Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center, 
                              children: [
                                SizedBox(
                                  
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                     
                                      FittedBox(
                                        fit: BoxFit.cover,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left:8,right:8,top:8,bottom:8),
                                          child: Text("Kurunagala",
                                                style: GoogleFonts.cabin(
                                            // ignore: prefer_const_constructors
                                            textStyle: TextStyle(
                                            color: const Color.fromARGB(255, 27, 27, 27),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                                                          
                                            ) 
                                            )
                                          ),
                                        ),
                                      ),          
                                    ],
                                  ),
                                ),
                                
                              ],
                                            
                                            
                            )
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          ],
        )
         
        );
        
    
  
    }else{

      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}