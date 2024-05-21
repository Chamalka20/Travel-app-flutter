import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:travelapp/blocs/place/placeList_bloc.dart';

import '../../blocs/place/place_event.dart';
import '../../models/place.dart';

class PlaceCoveImage extends StatefulWidget {
  final bool isLoading;
  final Place placeDetails; 
  const PlaceCoveImage({required this.isLoading,required this.placeDetails,super.key});

  @override
  State<PlaceCoveImage> createState() => _PlaceCoveImageState(isLoading,placeDetails);

}

class _PlaceCoveImageState extends State<PlaceCoveImage> {

  final bool isLoading;
  final Place placeDetails; 

  _PlaceCoveImageState(this.isLoading,this.placeDetails);

  @override
  Widget build(BuildContext context) {

    if(isLoading){
      return
        Container(
        width:360,
        height: 250,
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
      
      );
      
    }else{
      return  Container(
        width:360,
        height: 250,
        decoration: BoxDecoration(
        
        image: DecorationImage(
        image: NetworkImage(placeDetails.photoRef),
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
                        future:placeBloc.checkFavorites([placeDetails]),
                        builder: (BuildContext context, AsyncSnapshot<dynamic> favSnapshot) { 
                          
                          if(favSnapshot.hasData){

                            return
                                InkWell(
                                onTap: () async =>{
                                if (favSnapshot.data[0] == false) {
                                                       
                                  BlocProvider.of<placeListBloc>(context).add(placeAddToFavorites(atPlaceId: placeDetails.id,
                                    placeName: placeDetails.name, placeImgUrl: placeDetails.photoRef, type: placeDetails.type)),
                                    
                                        
                                    setState(() {
                                          favSnapshot.data[0] = true;
                                    }),
                                                              
                                  } else {
                                    
                                    //remove favorite form the database-----------------
                                        
                                      BlocProvider.of<placeListBloc>(context).add(placeRemoveFromFavorites(atPlaceId:placeDetails.id)),
                                        
                                    
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
                                color: const Color.fromARGB(255, 129, 129, 129), 
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
      
      );

    }

  
  }

}


  
  
  
