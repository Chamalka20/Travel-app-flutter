import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:travelapp/ui/createNewTrip.dart';
import '../blocs/place/placeList_bloc.dart';
import '../blocs/place/place_event.dart';
import '../blocs/place/place_state.dart';
import '../blocs/trip/trip_bloc.dart';
import '../models/place.dart';
import '../models/trip.dart';
import 'components/placesList.dart';



class locationDetails extends StatefulWidget {
  
  final placeId;
  final searchType;
  
  
 const locationDetails({required this.placeId,required this.searchType, Key? key}) : super(key: key);


  @override
  State<locationDetails> createState() => _locationDetailsState(placeId,searchType);
}

class _locationDetailsState extends State<locationDetails> {

  final placeId;
  final searchType;

  

  late List isAddFavorite;
  var favorites=[];
  List<bool> isaddAttractionToFavorite=[];

 
  late final String placeType;
  late  String aboutDetails ='';
 
  bool showFullText = false;

  

  _locationDetailsState(this.placeId,this.searchType);

  
  @override
  void initState () {
        
  super.initState();

    
    
  }

  @override
  void dispose() {
      
    super.dispose();
  }





  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners:[
        BlocListener<placeListBloc, place_state>(
        listener: (context, state) {

          if(state is placeAddToFavoriteState){

            if(state.isAdd == true){
              ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content:Text("Place is add to the favorites")));
            }

          }else if(state is placeRemoveFromFavoriteState){

            if(state.isRemove == true){
              ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content:Text("Removed place from the favorites")));
            }

          }

          },
      ),
    

      ]
      , child:WillPopScope(
    onWillPop: () async {
      
      Navigator.pop(context);
      return true;
    }, 
    child: Scaffold(
     extendBodyBehindAppBar: true,
     appBar: AppBar(
      toolbarHeight: 2,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(0, 255, 255, 255),
        statusBarIconBrightness: Brightness.light, 
        ),
      elevation: 0,
      backgroundColor: Color.fromARGB(0, 20, 12, 12),

      
    ),
      body:buildBody(),
    )
    )
    );
    
    
    
    
    
  }

  
   Widget buildBody() {

      return
      FutureBuilder<Place>(
        future:placeBloc.getPlaceDetailes(placeId, searchType),
        builder: (BuildContext context, AsyncSnapshot<Place> placeDetails) { 
          
          if(placeDetails.hasData){
            
            return
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  width:360,
                  
                  color: Color.fromARGB(255, 255, 255, 255),
                  child: Stack(
                    children:[ Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width:360,
                              height: 250,
                              decoration: BoxDecoration(
                              
                              image: DecorationImage(
                              image: NetworkImage(placeDetails.data!.photoRef),
                              fit: BoxFit.cover
                                          
                                ),
                              
                              ),
            
                              child:Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top:30,right:14),
                                        child: SizedBox(
                                            width:55,
                                            height:55,
                                            child: FutureBuilder(
                                              future:placeBloc.checkFavorites([placeDetails.data]),
                                              builder: (BuildContext context, AsyncSnapshot<dynamic> favSnapshot) { 
                                                
                                                if(favSnapshot.hasData){

                                                  return
                                                     InkWell(
                                                      onTap: () async =>{
                                                              
                                                      if (favSnapshot.data[0] == false) {
                                                              
                                                                                  
                                                        BlocProvider.of<placeListBloc>(context).add(placeAddToFavorites(atPlaceId: placeDetails.data!.id,
                                                          placeName: placeDetails.data!.name, placeImgUrl: placeDetails.data!.photoRef, type: placeDetails.data!.type)),
                                                          
                                                              
                                                          setState(() {
                                                                favSnapshot.data[0] = true;
                                                          }),
                                                                                    
                                                        } else {
                                                          
                                                          //remove favorite form the database-----------------
                                                              
                                                            BlocProvider.of<placeListBloc>(context).add(placeRemoveFromFavorites(atPlaceId:placeDetails.data!.id)),
                                                              
                                                          
                                                          setState(() {
                                                                favSnapshot.data[0] = false;
                                                          }),
                                                            
                                                          
                                                      }
                                                              
                                                      },
                                                      child: Card(
                                                        elevation: 0,
                                                            color:const Color.fromARGB(200, 240, 238, 238),
                                                            clipBehavior: Clip.antiAliasWithSaveLayer,
                                                            shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(50.0),
                                                                  ),
                                                            child:Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Image.asset(favSnapshot.data[0]?"assets/images/heartBlack.png":"assets/images/heart.png",width:25,height:25),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),  
                                                                                                          
                                                      ),
                                                    );      

                                                }else{

                                                  return
                                                    LoadingAnimationWidget.beat(
                                                      color: Color.fromARGB(255, 129, 129, 129), 
                                                      size: 25,
                                                    );


                                                }


                                               },
                                             
                                            ),
                                                                  
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            
                            ),
                          ],
                        ),
                      ],
                    ),
                    //data container---------------------------------------------------------------
                    Padding(
                      padding: const EdgeInsets.only(top:195),
                      child: Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width:360,
                                  child: Container(
                                  
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      borderRadius: BorderRadius.circular(27)
                                    ),
                                    child: Column(
                                      //mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top:16, left:6),
                                                child: SizedBox(
                                                  width:240,
                                                  child: Text(placeDetails.data!.name,
                                                      style: GoogleFonts.cabin(
                                                                // ignore: prefer_const_constructors
                                                                textStyle: TextStyle(
                                                                color: const Color.fromARGB(255, 27, 27, 27),
                                                                fontSize: 24,
                                                                fontWeight: FontWeight.bold,
                                                        
                                                                ) 
                                                                ),
                                                  ),
                                                ),
                                              ),
                                            
                                            //weather condion---------------------------------------------
                                            //weather icon------------------------------------
                                            FutureBuilder<List>(
                                              future:searchType=='city'? placeBloc.getWeather(placeDetails.data!.latitude, placeDetails.data!.longitude):null,
                                              builder: (BuildContext context, AsyncSnapshot<List> snapshot) { 
            
                                                  if(snapshot.hasData){
            
                                                    return
                                                      Container(
                                                        child:Row(
                                                          children:[
                                                        Visibility(
                                                          visible: searchType == 'city',
                                                          child: Container(
                                                            margin: snapshot.data?[0]["weatherIcon"]!=""?const EdgeInsets.only(top:10,left:4 ):const EdgeInsets.only(left:50,top:6 ),
                                                            child: Row(
                                                              children: [
                                                                Image.asset(snapshot.data?[0]["weatherIcon"],width:35,height:35)
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        //weather temperature ---------------------------------------
                                                        Visibility(
                                                          visible: searchType =='city' && snapshot.data?[0]["temperature"]!=0,
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(top:10, left:7),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Text('${snapshot.data?[0]["temperature"]} °',
                                                                      style: GoogleFonts.cabin(
                                                                                // ignore: prefer_const_constructors
                                                                                textStyle: TextStyle(
                                                                                color: const Color.fromARGB(255, 27, 27, 27),
                                                                                fontSize: 20,
                                                                                fontWeight: FontWeight.w400,
                                                                                                              
                                                                                ) 
                                                                              )
                                                                    )
                                                                  ],
                                                                ),
                                                                Visibility(
                                                                  visible: snapshot.data?[0]["phrase"]!="",
                                                                  child: Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        width:35,
                                                                        child: SizedBox(
                                                                          child: Text("${snapshot.data?[0]["phrase"]}",
                                                                            style: GoogleFonts.cabin(
                                                                                      // ignore: prefer_const_constructors
                                                                                      textStyle: TextStyle(
                                                                                      color: const Color.fromARGB(255, 27, 27, 27),
                                                                                      fontSize: 10,
                                                                                      fontWeight: FontWeight.w400,
                                                                                                                    
                                                                                      ) 
                                                                                    )
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                        ]
                                                        )
                                                      );
                                                  }else{
            
                                                    return
                                                    Visibility(
                                                      visible: searchType =='city',
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 50),
                                                        child: LoadingAnimationWidget.beat(
                                                            color: Color.fromARGB(255, 129, 129, 129), 
                                                            size: 35,
                                                          ),
                                                      ),
                                                    );
            
                                                  }
            
                                                },
                                              
                                            )
                                            ],
                                            
                                          ),
                                          
                                        ),
                                        
                                        // ratings------------------------------------------------
                                        Visibility(
                                          visible: searchType !='city',
                                          child: Padding(
                                            padding: const EdgeInsets.only(left:12,top:6),
                                            child: Row(
                                              children: [
                                                RatingBar.builder(
                                                    itemSize: 15,
                                                    
                                                    initialRating: placeDetails.data!.rating,
                                                    minRating: 1,
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: true,
                                                    itemCount: 5,
                                                    itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                                                    itemBuilder: (context, _) => const Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    ),
                                                    onRatingUpdate: (rating) {
                                                      print(rating);
                                                    },
                                                  ),
                                        
                                                  Padding(
                                                    padding: const EdgeInsets.only(left:7),
                                                    child: Text('${placeDetails.data!.rating}',style: GoogleFonts.cabin(
                                                                  // ignore: prefer_const_constructors
                                                                  textStyle: TextStyle(
                                                                  color: const Color.fromARGB(255, 27, 27, 27),
                                                                  fontSize: 15,
                                                                  //fontWeight: FontWeight.bold,
                                                          
                                                                  ) 
                                                                  )),
                                                  ),
                                                  //----------------------------------------------------------
                                                
                                              ],
                                            ),
                                          ),
                                        ),
                                        //place types------------------------------------------------------------
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left:10,top:4),
                                                  child: SizedBox(
                                                    width:70,
                                                    height:25,
                                                                
                                                        child: Card(
                                                          elevation: 0,
                                                          color:const Color.fromARGB(255, 240, 238, 238),
                                                          //clipBehavior: Clip.antiAliasWithSaveLayer,
                                                          shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(17.0),
                                                                ),
                                                      
                                                          child:Container(
                                                          
                                                            
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                              
                                                                FittedBox(
                                                                  fit: BoxFit.cover,
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(left:4,right:4),
                                                                    child: Text('${placeDetails.data!.type}',
                                                                          style: GoogleFonts.cabin(
                                                                      // ignore: prefer_const_constructors
                                                                      textStyle: TextStyle(
                                                                      color: const Color.fromARGB(255, 27, 27, 27),
                                                                      fontSize: 8,
                                                                      fontWeight: FontWeight.bold,
                                                                                                    
                                                                      ) 
                                                                      )
                                                                    ),
                                                                  ),
                                                                ),          
                                                              ],
                                                            ),
                                                          )
                                                        ),
                                                      )
                                                              
                                                        
                                                ), 
                                                    
                                              ],
                                                    
                                            ),
                                          ],
                                        ),
                                      
                                        //open times---------------------------------------------------------------------------------
                                      Visibility(
                                        visible: searchType !='city',
                                        child: Padding(
                                            padding: const EdgeInsets.only(left:13,top:5),
                                          child: Row(
                                            children: [
                                              Container(
                                                  width:115,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: placeDetails.data!.openingHours.map<Widget>((time) => Padding(
                                                      padding: const EdgeInsets.only(bottom: 4.0),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            time['day'],
                                                            style: GoogleFonts.cabin(
                                                              textStyle:const TextStyle(
                                                                color: const Color.fromARGB(255, 27, 27, 27),
                                                                fontSize: 8,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(left:12),
                                                            child: Text(
                                                              time['hours'],
                                                              style: GoogleFonts.cabin(
                                                                textStyle:const TextStyle(
                                                                  color: const Color.fromARGB(255, 27, 27, 27),
                                                                  fontSize: 8,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )).toList(),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      //phone number--------------------------------------------------------------
                                      Visibility(
                                        visible: searchType !='city',
                                        child: Padding(
                                          padding: const EdgeInsets.only(left:13,top:7),
                                          child: Row(
                                            children: [
                                              Text(placeDetails.data!.phone,
                                                style: GoogleFonts.cabin(
                                                            textStyle:const TextStyle(
                                                              color: Color.fromARGB(255, 19, 148, 223),
                                                              fontSize: 11,
                                                              fontWeight:FontWeight.w400
                                                              
                                                            ),
                                                          ),
                                              )
                                            ],
                                        
                                          ),
                                        ),
                                      ),
                                      // about details on the place----------------------------------------------------
                                      Padding(
                                        padding: const EdgeInsets.only(left: 13,top:7),
                                        child: Row(
                                          children: [
                                            Text("About",
                                              style: GoogleFonts.cabin(
                                                            textStyle:const TextStyle(
                                                              color: Color.fromARGB(255, 0, 0, 0),
                                                              fontSize: 16,
                                                              fontWeight:FontWeight.bold
                                                              
                                                            ),
                                                          ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 13,top:4),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            LayoutBuilder(
                                              builder: (context, constraints) {
                                                final textSpan = TextSpan(
                                                  text: aboutDetails,
                                                  style: GoogleFonts.cabin(
                                                          textStyle:const TextStyle(
                                                            color: Color.fromARGB(255, 112, 112, 112),
                                                            fontSize: 11,
                                                            fontWeight:FontWeight.w400
                                                            
                                                          ),
                                                        ),
                                                );
                                                final textPainter = TextPainter(
                                                  text: textSpan,
                                                  textDirection: TextDirection.ltr,
                                                  maxLines: 4, 
                                                );
                                                textPainter.layout(maxWidth: constraints.maxWidth);
                                                final isTextOverflowed = textPainter.didExceedMaxLines;
                                
                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    RichText(
                                                      text: textSpan,
                                                      maxLines: showFullText ? null : 4, 
                                                      overflow: TextOverflow.clip,
                                                    ),
                                                    if (isTextOverflowed)
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            showFullText = !showFullText;
                                                          });
                                                        },
                                                        child: Padding(
                                                          padding: EdgeInsets.only(left:140),
                                                          child: Text(
                                                            showFullText ? 'See Less' : 'See More',
                                                            style: GoogleFonts.cabin(
                                                              textStyle:const TextStyle(
                                                              color: Color.fromARGB(255, 19, 148, 223),
                                                                fontSize: 12,
                                                                fontWeight:FontWeight.bold
                                                                
                                                              ),
                                                        ),
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      //place address ----------------------------------------------------------
                                      Visibility(
                                        visible: searchType !='city',
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 13,top:7),
                                          child: Row(
                                            children: [
                                              Text("Address",
                                                style: GoogleFonts.cabin(
                                                                textStyle:const TextStyle(
                                                                  color: Color.fromARGB(255, 0, 0, 0),
                                                                  fontSize: 16,
                                                                  fontWeight:FontWeight.bold
                                                                  
                                                                ),
                                                              ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: searchType != 'city',
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 13,top:5),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width:250,
                                                child: Text(placeDetails.data!.address,
                                                  style: GoogleFonts.cabin(
                                                                    textStyle:const TextStyle(
                                                                      color: Color.fromARGB(255, 19, 148, 223),
                                                                      fontSize: 11,
                                                                      fontWeight:FontWeight.bold
                                                                      
                                                                    ),
                                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      //google map------------------------------------------------------------
                                      Padding(
                                        padding: const EdgeInsets.only(left: 13,top:8),
                                        child: Row(
                                          children: [
                                            Text("How to get there",
                                              style: GoogleFonts.cabin(
                                                                textStyle:const TextStyle(
                                                                  color: Color.fromARGB(255, 0, 0, 0),
                                                                  fontSize: 16,
                                                                  fontWeight:FontWeight.bold
                                                                  
                                                                ),
                                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      //---Route----------------------------------------------
                                      FutureBuilder<List>(
                                        future:placeBloc.getRoute(placeDetails.data!.latitude, placeDetails.data!.longitude),
                                        builder: (BuildContext context, AsyncSnapshot<List> snapshot) { 
            
                                          if(snapshot.hasData){
            
                                            return
                                              Padding(
                                                padding: const EdgeInsets.only(left: 13,top:3),
                                                child: Row(
                                                  children: [
                                                    Text("From ${snapshot.data?[0]["currentCity"]}  ▪ ${snapshot.data?[0]["distance"]} km   ▪ ${snapshot.data?[0]["duration"]}",
                                                      style: GoogleFonts.cabin(
                                                                    textStyle:const TextStyle(
                                                                      color: Color.fromARGB(255, 112, 112, 112),
                                                                      fontSize: 11,
                                                                      fontWeight:FontWeight.w400
                                                                      
                                                                    ),
                                                                  ),
                                                    )
                                                  ],
                                                ),
                                              );
            
            
                                          }else{
            
                                              return
                                                Padding(
                                                padding: const EdgeInsets.only(left: 13,top:3),
                                                child: Row(
                                                  children: [
                                                    LoadingAnimationWidget.waveDots(
                                                      color: Color.fromARGB(255, 129, 129, 129), 
                                                      size: 11,
                                                    ),
                                                    
                                                  ],
                                                ),
                                              );
                                            
                                          }
            
            
                                        },
                                        
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top:9),
                                        child: SizedBox(
                                          width:355,
                                          height:185,
                                          child: SfMaps(
                                            layers: [
                                              MapTileLayer(
                                                initialFocalLatLng: MapLatLng(
                                                    placeDetails.data!.latitude,placeDetails.data!.longitude),
                                                initialZoomLevel: 12,
                                                initialMarkersCount: 1,
                                                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                                markerBuilder: (BuildContext context, int index) {
                                                  return MapMarker(
                                                    latitude: placeDetails.data!.latitude,
                                                    longitude: placeDetails.data!.longitude,
                                                    size: const Size(50, 50),
                                                    child: const Icon(
                                                      Icons.location_on,
                                                      color: Color.fromARGB(255, 0, 0, 0),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          )
                                        ),
                                      ),
                                      //Attractions in this place-------------------------------------------------------
                                    
                                      Visibility(
                                        visible: searchType=='city',
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 13,top:14),
                                          child: Row(
                                            children: [
                                              Text("Attractions in ${placeDetails.data!.name}",
                                                style: GoogleFonts.cabin(
                                                              textStyle:const TextStyle(
                                                                color: Color.fromARGB(255, 0, 0, 0),
                                                                fontSize: 16,
                                                                fontWeight:FontWeight.bold
                                                                
                                                              ),
                                                            ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      //list------------------------------------------------------
                                      
                                      Visibility(
                                        visible: searchType =="city",
                                          child: placesList(placeName: placeDetails.data!.name, placeType: 'attraction',)
                                        
                
                                      ),
                                      
                                      
                                      //show resturents----------------------------------------------
                                      Visibility(
                                        visible: searchType =='city',
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 13,top:14),
                                          child: Row(
                                            children: [
                                              Text("Where to stay and eat ",
                                                style: GoogleFonts.cabin(
                                                              textStyle:const TextStyle(
                                                                color: Color.fromARGB(255, 0, 0, 0),
                                                                fontSize: 16,
                                                                fontWeight:FontWeight.bold
                                                                
                                                              ),
                                                            ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      //resturents list-------------------------------------------------------------
                                      
                                      Visibility(
                                        visible: searchType =='city',
                                          child:placesList(placeName: placeDetails.data!.name, placeType: 'restaurant',)    
                                      ),  
                                                      
                                                      
                                      //reviews-----------------------------------------------------------------
                                      //------------------------------------------------------------------------
                                      Visibility(
                                        visible: placeDetails.data!.reviews.isNotEmpty?true:false,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 13,top:14,bottom:9),
                                          child: Row(
                                            children: [
                                              Text("Reviews",
                                                style: GoogleFonts.cabin(
                                                              textStyle:const TextStyle(
                                                                color: Color.fromARGB(255, 0, 0, 0),
                                                                fontSize: 16,
                                                                fontWeight:FontWeight.bold
                                                                
                                                              ),
                                                            ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      //reviewslist------------------------------------------------------
                                      
                                      Visibility(
                                        visible: placeDetails.data!.reviews.isNotEmpty?true:false,
                                        child: Row(
                                          children: [
                                            
                                            Expanded(
                                              child: Column(
                                              
                                                children: placeDetails.data!.reviews.map<Widget>((review) => Padding(
                                                  padding: const EdgeInsets.only(bottom: 10.0),
                                                  child: Container(
                                                    width: 330,
                                              
                                                    decoration: BoxDecoration(
                                                      color:const Color.fromARGB(255, 240, 238, 238),
                                                      borderRadius: BorderRadius.circular(13)
                                                    ),
                                                              
                                                    child:Padding(
                                                      padding: const EdgeInsets.only(left:10,bottom:10),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              //profile photo-----------------------------------
                                                              Padding(
                                                                padding: const EdgeInsets.only(top:13),
                                                                child: Container(
                                                                  width:35,
                                                                  height:35,
                                                                  
                                                                  child: CircleAvatar(
                                                                    radius: 40,
                                                                    
                                                                    backgroundImage:NetworkImage(review['reviewerPhotoUrl']),
                                                                    
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(left:7,top:10),
                                                                child: Column(
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        //author name--------------------------------------
                                                                        SizedBox(
                                                                          width:200,
                                                                          child: Text(review['name'],
                                                                            style: GoogleFonts.cabin(
                                                                              textStyle:const TextStyle(
                                                                                color: Color.fromARGB(255, 0, 0, 0),
                                                                                fontSize: 14,
                                                                                fontWeight:FontWeight.bold
                                                                                
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                      
                                                                        //review date-------------------------------------------------
                                                                        Text(review['publishAt'],
                                                                            style: GoogleFonts.cabin(
                                                                              textStyle:const TextStyle(
                                                                                color: Color.fromARGB(255, 112, 112, 112),
                                                                                fontSize: 9,
                                                                                fontWeight:FontWeight.bold
                                                                                
                                                                              ),
                                                                            ),
                                                                        )
                                                                        
                                                                      ],
                                                                    ),
                                                                    
                                                                  ],
                                                                ),
                                                              )
                                                              
                                                            ],
                                                          ),
                                                          //Review description-------------------------------------
                                                          Padding(
                                                            padding: const EdgeInsets.only(left:13),
                                                            child: SizedBox(
                                                              width: 250,
                                                              
                                                              
                                                              child: Text(review['text'],
                                                                  style: GoogleFonts.cabin(
                                                                    textStyle:const TextStyle(
                                                                      color: Color.fromARGB(255, 112, 112, 112),
                                                                      fontSize: 10,
                                                                      fontWeight:FontWeight.w400
                                                                      
                                                                    ),
                                                                  ),
                                                                  ),
                                                                ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  
                                                  ),
                                                )).toList(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextButton(
                                          onPressed: () {
                                            searchType!='city'?
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
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(left:12,top:12),
                                                        child: Row(
                                                          children: [
                                                            Text("Select trip and day",
                                                              style: GoogleFonts.cabin(
                                                                    textStyle:const TextStyle(
                                                                      color: Color.fromARGB(255, 0, 0, 0),
                                                                      fontSize: 16,
                                                                      fontWeight:FontWeight.bold
                                                                      
                                                                    ),
                                                                  ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left:12,top:6),
                                                        child: Row(
                                                          children: [
                                                            Text("Choose your best option to go to this place",
                                                              style: GoogleFonts.cabin(
                                                                    textStyle:const TextStyle(
                                                                      color: Color.fromARGB(255, 112, 112, 112),
                                                                      fontSize: 10,
                                                                      fontWeight:FontWeight.w400
                                                                      
                                                                    ),
                                                                  ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      //trip list------------------------------------------------
                                                      FutureBuilder(
                                                        future:tripBlo.getOnGoingTrips(),
                                                        builder: (BuildContext context, AsyncSnapshot<List<Trip>> onGoingTrips) { 
            
                                                          if(onGoingTrips.hasData){
            
                                                            return
                                                              Padding(
                                                                padding: const EdgeInsets.only(top:9),
                                                                child: SizedBox(
                                                                  height:115,
                                                                  child: Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child: ListView.builder(
                                                                          cacheExtent: 9999, 
                                                                          itemCount:onGoingTrips.data!.length+1,
                                                                          scrollDirection: Axis.horizontal, 
                                                                          itemBuilder: (context, index) {
                                                                            
                                                                            if(index ==0){
                                                                              
                                                                              return
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(left:7,right:6),
                                                                                  child: Container(
                                                                                    width:145,
                                                                                    height:110,
                                                                                    decoration: BoxDecoration(
                                                                                    color: Color.fromARGB(255, 124, 124, 124),
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                    
                                                                                                                                              
                                                                                    ),
                                                                                  child: GestureDetector(
                                                                                  onTap: ()=>{
                                                                                    //dierect place details page again---------------------
                                                                                      Navigator.push(
                                                                                      context,
                                                                                      MaterialPageRoute(builder: (context) => const createNewTrip(placeName:'',placePhotoUrl:'',isEditTrip: false,)),
                                                                                    ),
                                                                                  },
                                                                                    child:Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      children: [
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                                          children: [
                                                                                            Image.asset('assets/images/add.png',width:30,height:30)
                                                                                          ],
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.only(top:6),
                                                                                          child: Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                                            children: [
                                                                                              Text("Creat new trip",
                                                                                                style: GoogleFonts.cabin(
                                                                                                  textStyle:const TextStyle(
                                                                                                    color: Color.fromARGB(255, 255, 255, 255),
                                                                                                    fontSize: 12,
                                                                                                    fontWeight:FontWeight.w500
                                                                                                    
                                                                                                  ),
                                                                                                ),
                                                                                              )
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    )
                                                                                    
                                                                                  )
                                                                                      ),
                                                                                );
                                                              
                                                              
                                                                            }else{
                                                              
                                                                              return
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(left:6),
                                                                                  child: GestureDetector(
                                                                                    onTap: () async {
                                                                                                                      
                                                                                      final prefs = await SharedPreferences.getInstance();
                                                                                      final encodata = json.encode(onGoingTrips.data?[index-1]);
                                                                                      prefs.setString('trip',encodata );
                                                                                      prefs.setInt('selectDay',0 );
                                                            
                                                                                                                      
                                                                                      final tripId = onGoingTrips.data?[index-1].tripId;
                                                                                      //find database user selectdoc id -----------------------------------------
                                                                                      //final tripDocId=await fechApiData.getTripDocId(tripId);
                                                                                      //----------------------------------------------------------------------
                                                                                      // await prefs.setString('triDocId',tripDocId );
                                                            
                                                                                      // List selectedIds =[{
                                                                                      //                 'day':"" ,
                                                                                      //                 'places':[placeId],
                                                                                      //               }];
                                                                                      // final endata = json.encode(selectedIds);
                                                                                      // await prefs.setString('TripPlaceIds',endata);
                                                            
                                                                                      // await prefs.setString('searchType','attracrions');
                                                                                      // await prefs.setBool('isEditTrip',true);
                                                            
                                                                                      // print("tripid: ${tripId}");
                                                                                                                      
                                                                                      // Navigator.push(
                                                                                      // context,
                                                                                      // MaterialPageRoute(builder: (context) =>  tripDetailsPlan(isSelectPlaces: false,isEditPlace: true, isAddPlace: true,)),
                                                                                      // );
                                                                                    },
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.only(right:6,),
                                                                                      child: Container(
                                                                                        width:145,
                                                                                        height:110,
                                                                                        decoration: BoxDecoration(
                                                                                          color: Color.fromARGB(255, 216, 99, 99),
                                                                                          borderRadius: BorderRadius.circular(10),
                                                                                          image: DecorationImage(
                                                                                          image: NetworkImage(onGoingTrips.data![index-1].tripCoverPhoto),
                                                                                          fit: BoxFit.cover
                                                                                                      
                                                                                            ),
                                                                                        
                                                                                        ),
                                                                                        child:Padding(
                                                                                          padding: const EdgeInsets.only(top:11),
                                                                                          child: Column(
                                                                                            children: [
                                                                                              Row(
                                                                                                children: [
                                                                                                  SizedBox(
                                                                                                    height:25,
                                                                                                    width:50,
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
                                                                                                                      padding: const EdgeInsets.all(7.0),
                                                                                                                      child: Text('${onGoingTrips.data?[index-1].places[0].length} days',
                                                                                                                        style: GoogleFonts.cabin(
                                                                                                                          // ignore: prefer_const_constructors
                                                                                                                          textStyle: TextStyle(
                                                                                                                          color: Color.fromARGB(255, 95, 95, 95),
                                                                                                                          fontSize: 7,
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
                                                                                                padding: const EdgeInsets.only(top:10),
                                                                                                child: Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                  children: [
                                                                                                    
                                                                                                    Text('${onGoingTrips.data?[index-1].tripName}',
                                                                                                          style: GoogleFonts.cabin(
                                                                                                        // ignore: prefer_const_constructors
                                                                                                        textStyle: TextStyle(
                                                                                                        color: Color.fromARGB(255, 255, 255, 255),
                                                                                                        fontSize: 19,
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
                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                  children: [
                                                                                                    
                                                                                                    Text('${onGoingTrips.data?[index-1].durationCount}',
                                                                                                          style: GoogleFonts.cabin(
                                                                                                        // ignore: prefer_const_constructors
                                                                                                        textStyle: TextStyle(
                                                                                                        color: Color.fromARGB(255, 255, 255, 255),
                                                                                                        fontSize: 7,
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
                                                                                );
                                                                            }
                                                                          
                                                                          }
                                                                        
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
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
                                                    ],
                                                  ),
                                                  
                                                );
            
                                              }, 
                                              
                                            
                                            ):
                                            //derect trip plan page---------------------------------
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) =>  createNewTrip(placeName:placeDetails.data!.name,placePhotoUrl:placeDetails.data!.photoRef,isEditTrip: false,)),
                                            );
                                            
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color.fromARGB(255, 0, 0, 0),
                                            foregroundColor:Color.fromRGBO(255, 255, 255, 1),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20), // Set the radius here
                                              ),
                                            
                                          ),
                                          child: Text(searchType!='city'?'Add to trip':'Plan new trip',
                                              style: GoogleFonts.roboto(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  
                                          
                                              ),
                                          
                                          ),
                                        ),
                                      ),
                                
                                      ],
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
                  ),
                ),
              );


          }else{
              return
              Center(
                child: LoadingAnimationWidget.waveDots(
                  color: Color.fromARGB(255, 129, 129, 129), 
                  size: 35,
                ),
              );
              
          }


         },
       
      );
    
    
    
  }
}