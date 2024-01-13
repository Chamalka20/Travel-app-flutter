import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../blocs/place/placeList_bloc.dart';
import '../../blocs/place/place_event.dart';
import '../locationDetails.dart';

class placesList extends StatefulWidget {

  final String placeName;
  final String placeType;
  const placesList({super.key, required this.placeName,required this.placeType});

  @override
  State<placesList> createState() => _placesListState(placeName,placeType);
}

class _placesListState extends State<placesList> {

 final String placeName;
 final String placeType;

  _placesListState(this.placeName,this.placeType);

@override
  void initState () {

        
  super.initState();

  }

  
 

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:10.0,top:10),
      child: SizedBox(
      height: 190,
        child:FutureBuilder<List<dynamic>>(
     future: placeBloc.getplaces(placeName,placeType),
     builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot){

       if (snapshot.hasData ) {
        if (snapshot.data!.isNotEmpty ) {
         
         return
            FutureBuilder<List>(
              future:placeBloc.checkFavorites(snapshot.data),
              builder: (BuildContext context, AsyncSnapshot<List> snapshot2){

                if(snapshot2.hasData){

                  return
                    ListView.builder(
                      cacheExtent: 9999,
                      scrollDirection: Axis.horizontal, 
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        
                        final attraction = snapshot.data?[index];
                        final atPlaceId = attraction?.id;
                        final attractionName = attraction?.name;
                        final attractionImgUrl = attraction?.photoRef;
                        final attractionRating = attraction?.rating;
                        final address = attraction?.address;
                        final type = attraction?.type;
                        
                        
                          return GestureDetector(
                            onTap: ()=>{
                              //dierect place details page again-------------------
              
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>  locationDetails(placeId:atPlaceId,searchType: 'attraction',)),
                              ),
                            },
                            child: Card(
                            elevation: 0,
                            color:const Color.fromARGB(255, 240, 238, 238),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                            child:Container(
                              width: 230,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 230,
                                        height: 120,
                                        
                                            decoration:  BoxDecoration(
                                              
                                              image: DecorationImage(
                                                image: NetworkImage(attractionImgUrl!),
                                                fit: BoxFit.fill,
                                                
                                          
                                                  ),
                                              
                                              ),
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
                                                                    child: Text('${type}',
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
                          
                                                Padding(
                                                  padding: const EdgeInsets.only(left:119,top:5),
                                                  child: SizedBox(
                                                      width:37,
                                                      height:37,
                                                          
                                                          child: InkWell(
                                                            onTap: () =>{
                                                              //favorites =await fechApiData.getFavorites(),
                                                                                            
                                                                if (snapshot2.data?[index] == false) {

                                                                  
                                                                      BlocProvider.of<placeListBloc>(context).add(placeAddToFavorites(atPlaceId: atPlaceId,
                                                                        placeName: attractionName, placeImgUrl: attractionImgUrl, type: type)),
                                                                 

                                                                  setState(() {
                                                                        snapshot2.data?[index] = true;
                                                                  }),
                                                                                            
                                                                } else {
                                                                  
                                                                  //remove favorite form the database-----------------

                                                                    BlocProvider.of<placeListBloc>(context).add(placeRemoveFromFavorites(atPlaceId: atPlaceId)),

                                                                  
                                                                  setState(() {
                                                                        snapshot2.data?[index] = false;
                                                                  }),
                                                                    
                                                                  
                                                              }
                                                              
                                                              },
                                                            
                                                                child:Card(
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
                                                                            
                                                                            Image.asset(snapshot2.data?[index]?"assets/images/heartBlack.png":"assets/images/heart.png",width:18,height:18),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),  
                                                                                                                  
                                                              ),
                                                              
                                                              
                                                            ),


                                                      
                                                        
                                                      ),
                                                      ),
                                                
                                            
                                                
                          
                                              ],
                                            ),
                                          ],
                                        ), 
                                          
                                        
                                      ),
                                  
                                            
                                    ],
                                  ),
                                  Row(
                                    
                                    children: [
                                        SizedBox(
                                        width: 190,
                                        height:30,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left:6,top:5),
                                            child: Text(attractionName!,
                                            
                                            overflow: TextOverflow.ellipsis,
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
                          
                                      Image.asset("assets/images/star.png",width:14,height:14),
                                      Padding(
                                        padding: const EdgeInsets.only(left:4),
                                        child: Text("$attractionRating",
                                            style: GoogleFonts.cabin(
                                          // ignore: prefer_const_constructors
                                          textStyle: TextStyle(
                                          color: const Color.fromARGB(255, 27, 27, 27),
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                                                          
                                          ) 
                                        )
                                        
                                        ),
                                      ),  
                                    ],
                                  
                                  ),
                                  Row(
                                  
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left:4),
                                        child: Image.asset('assets/images/location.png',width:15,height:15),
                                      ),
                                      SizedBox(
                                        width:200,
                                        height:7,
                                        child: Text(address!,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.cabin(
                                            // ignore: prefer_const_constructors
                                            textStyle: TextStyle(
                                            color: Color.fromARGB(255, 94, 94, 94),
                                            fontSize: 7,
                                            fontWeight: FontWeight.bold,
                                                                            
                                            ) 
                                          )
                                        
                                        
                                        ),
                                      )
                                    ],
                                  )
                                ],
                                            
                                            
                              ),
                            )
                              
                              
                            
                            ),
                          ); 
                      },
                    );


                }else{
                  return
                    LoadingAnimationWidget.waveDots(
                      color: Color.fromARGB(255, 129, 129, 129), 
                      size: 35,
                    );

                }

              }
            );
           

        }else{

          return
            const SizedBox(
                    width:360,
                    height:130,
                    child: Center(
                      child: Text("No Data")
            
            
                  )
      
                );
        }
       }else{

          return
           const SizedBox(
                   width:360,
                   height:130,
                   child: Center(
                     child: Text("Loading..")
           
           
                 )
     
               );
       }
     }

        )
        
        
        ),
      );
    
    
  }
}