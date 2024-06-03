import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../blocs/place/placeList_bloc.dart';
import '../blocs/place/place_event.dart';
import '../models/place.dart';
import 'placeDeatailsScreen/locationDetails.dart';

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
  var data;
  var inputData="";
  var capitalizedString="";
  String keyboardInput='';
  Timer? _timer;
  List selectedIds =[{
      'day':"" ,
      'places':[],
    }];
  bool isOnLongPress = false;
  late List<Place> RecentlySearchList;
  
  _searchState( this.isTextFieldClicked,this.searchType,this.isSelectPlaces);

 
   @override
  void initState() {
    super.initState();
    
    
    setState(() {

      isTextFieldClicked; 
     });
   
     
  }


  
String capitalize(String s) =>s.isNotEmpty? s[0].toUpperCase() + s.substring(1):'';
 

  @override
  Widget build(BuildContext context) {
    
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
                              //searchResults = [];
                              isOnLongPress = false;
                            });
                          },
                          //get keyboard input value-------------
                          onChanged: (value) {
                             //if text filed is empty do this------------------ 
                            if(value !=''){
                              if (_timer?.isActive ?? false) _timer!.cancel();
                              _timer = Timer(const Duration(milliseconds: 1000), () {

                                setState(() {
                                 inputData=value;
                                 print(inputData);
                                });

                              });
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
              FutureBuilder(
              future:placeBloc.searchPlaces(capitalize(inputData), searchType),
              builder: (BuildContext context, results) { 
                
                if(results.connectionState==ConnectionState.waiting){
                  return
                  LoadingAnimationWidget.discreteCircle(
                    color: const Color.fromARGB(255, 129, 129, 129), 
                    size: 12,
                  );
                }

                if(results.hasData){

                  return
                    Visibility(
                      visible: isTextFieldClicked,
                      child: Expanded(
                        child:Stack(
                          children:[ 
                            ScrollConfiguration(
                              behavior:const ScrollBehavior(),
                              child: GlowingOverscrollIndicator(
                                axisDirection: AxisDirection.down,
                                color:Color.fromARGB(255, 100, 100, 100),
                                child: ListView.builder(
                                  itemCount: results.data?.length,
                                  itemBuilder: (context, index) {
                                    final searchRe = results.data?[index];
                                    final name = searchRe?.name;
                                    final photoReference =searchRe?.photoRef;
                                    final  placeId = searchRe?.id;
                                    
                                                          
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
                                                          
                                              Navigator.push(
                                                            context,
                                                            MaterialPageRoute(builder: (context) =>  locationDetails(placeId:placeId,searchType:'city')));
                                
                                              if(RecentlySearchList.isNotEmpty){
                                                bool contains=false;
                                                for (var element in RecentlySearchList) { 
                                   
                                                  if(element.name.contains(results.data![index].name)){
                                
                                                   contains = true;
                                                    
                                                  }else{
                                                    
                                                    
                                                  }
                                                  
                                                }
                                                if(contains!=true){
                                                   BlocProvider.of<placeListBloc>(context).add(addUserRecentlySearch(id:results.data![index].id , name: results.data![index].name, address: results.data![index].address,
                                                  openingHours: results.data![index].openingHours, phone: results.data![index].phone, photoRef: results.data![index].photoRef,
                                                  type: results.data![index].type, latitude: results.data![index].latitude, longitude: results.data![index].longitude));
                                                }
                                                
                                                
                                              }else{
                                
                                                BlocProvider.of<placeListBloc>(context).add(addUserRecentlySearch(id:results.data![index].id , name: results.data![index].name, address: results.data![index].address,
                                                openingHours: results.data![index].openingHours, phone: results.data![index].phone, photoRef: results.data![index].photoRef,
                                                type: results.data![index].type, latitude: results.data![index].latitude, longitude: results.data![index].longitude));
                                                
                                              }
                                              
                                
                                             
                                                            
                                                          
                                            }else if(searchType == 'attraction'){
                                              Navigator.push(
                                                            context,
                                                            MaterialPageRoute(builder: (context) =>  locationDetails(placeId:placeId,searchType:'attraction')));
                                                          
                                                          
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
                                                              backgroundImage:NetworkImage(photoReference!),
                                                              
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
                                                                      child: Text(name!,
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
                              ),
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
                                                    
                                                    // if(isSelectPlaces == true){

                                                    //   BlocProvider.of<tripBloc>(context).add(addTripPalcesEvent(isEditTrip:true, placesIds: selectedIds, tripId: ''));

                                                    //   Navigator.push(
                                                    //     context,
                                                    //     MaterialPageRoute(builder: (context) =>  tripDetailsPlan(isSelectPlaces: true,isEditPlace: true, isAddPlace: false,)));
                                                    // }else{

                                                    //   BlocProvider.of<tripBloc>(context).add(addTripPalcesEvent(isEditTrip:false, placesIds: [], tripId: ''));
                  
                                                    //   Navigator.push(
                                                    //   context,
                                                    //   MaterialPageRoute(builder: (context) =>  tripDetailsPlan(isSelectPlaces: true,isEditPlace: false, isAddPlace: false,)));
                  
                                                    // }  
                                                    
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
                    );

                }else{

                  return
                    LoadingAnimationWidget.waveDots(
                      color: Color.fromARGB(255, 129, 129, 129), 
                      size: 35,
                    );

                }

               },
              
            ),
            //------------------------------------------------------
            Visibility(
              visible: !isTextFieldClicked,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder<List<Place>>(
                  future:placeBloc.getUserRecentlySearch(),
                  builder: (BuildContext context, AsyncSnapshot<List<Place>> recentlySearch) { 
                    
                    if(recentlySearch.hasData ){
                    
                      RecentlySearchList =recentlySearch.data!;  
                      return
                         Expanded(
                           child: ScrollConfiguration(
                             behavior:const ScrollBehavior(),
                             child: GlowingOverscrollIndicator(
                               axisDirection: AxisDirection.down,
                               color:const Color.fromARGB(255, 0, 0, 0),
                               child: ListView.builder(
                                 shrinkWrap: true,
                                 physics: const ScrollPhysics(),
                                 scrollDirection: Axis.vertical,
                                 itemCount: recentlySearch.data!.length,
                                 itemBuilder: (context, index) {
                                   
                                   return
                                     Row(
                                       children: [
                                         GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) =>  locationDetails(placeId:recentlySearch.data![index].id,searchType:'city')));
                                          },
                                           child: SizedBox(
                                             child: Card(
                                               elevation: 0,
                                               color:const Color.fromARGB(255, 240, 238, 238),
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
                                                             child: Text(recentlySearch.data![index].name,
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
                                         ),
                                       ],
                                     );
                                                          
                                  },
                                 
                               ),
                             ),
                           ),
                         );

                    }else{

                      return Container();
                    }

                     

                   },
                  
                ),
              ),
            ),

          ],
        )
         
        );
        
  
  }
}