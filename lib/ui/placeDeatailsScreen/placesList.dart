import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../blocs/place/placeList_bloc.dart';
import '../../blocs/place/place_event.dart';
import '../../models/place.dart';
import 'locationDetails.dart';

typedef Callback = void Function(bool val);

class placesList extends StatefulWidget {

  final String placeName;
  final String placeType;
  final Callback navigateBackState;
  const placesList({super.key, required this.placeName,required this.placeType,
  required this.navigateBackState});

  @override
  State<placesList> createState() => _placesListState(placeName,placeType,navigateBackState);
}

class _placesListState extends State<placesList> {

 final String placeName;
 final String placeType;
 final Callback navigateBackState;
 bool isBack= false;
 bool isLoading= true;
 List<Place> placeList = [];
 late List<dynamic> isFavList;
 int displayedItemCount = 5;
 _placesListState(this.placeName,this.placeType,this.navigateBackState);

@override
  void initState () {    
  super.initState();
      getPlacesList();

  }

 @override
  void dispose() {  
    super.dispose();
    
  }
  Future<void> getPlacesList() async {
    placeList=await placeBloc.getplaces(placeName,placeType);
    checkFavorites(placeList);
  }
  Future<void> checkFavorites(placeList) async {
    isFavList=[];
    isFavList=await placeBloc.checkFavorites(placeList);
    if (mounted) {
      setState(() {
        placeList;
        isFavList;
        isLoading = false;
      });
    
    }

  }

  Future<void> navigateAndDisplaySelection(atPlaceId) async {
    
    isBack=await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  
      locationDetails(placeId:atPlaceId,searchType: 'attraction',)),
    );
    //refresh ui when pop--------
    if(isBack == true){
      isLoading=true;
      isFavList=[];
      navigateBackState(true);
      checkFavorites(placeList); 
    }

  }

  void _loadMore() {
    setState(() {
      displayedItemCount += 5;
      if (displayedItemCount > placeList.length) {
        displayedItemCount = placeList.length;
      }
    });
  }
 

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:10.0,top:10),
      child: SizedBox(
      height: 190,
      child:isLoading!=true? Expanded(
        child:placeList.isNotEmpty? 
        ScrollConfiguration(
          behavior:const ScrollBehavior(),
          child: GlowingOverscrollIndicator(
            axisDirection: AxisDirection.right,
            color:Color.fromARGB(255, 83, 83, 83),
            child: ListView.builder(
                    cacheExtent: 9999,
                    scrollDirection: Axis.horizontal, 
                    itemCount: displayedItemCount + (displayedItemCount < placeList.length ? 1 : 0),
                    itemBuilder: (context, index) {
                      final attraction = placeList[index];
                      final atPlaceId = attraction.id;
                      final attractionName = attraction.name;
                      final attractionImgUrl = attraction.photoRef;
                      final attractionRating = attraction.rating;
                      final address = attraction.address;
                      final type = attraction.type;
                      
                        if(index < displayedItemCount) {
                          return GestureDetector(
                            onTap: ()=>{
                              //dierect place details page again-------------------
                              navigateAndDisplaySelection(atPlaceId)
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
                                                image: NetworkImage(attractionImgUrl),
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
                                                                                    
                                                                if (isFavList[index] == false) {
              
                                                                      BlocProvider.of<placeListBloc>(context).add(placeAddToFavorites(atPlaceId: atPlaceId,
                                                                        placeName: attractionName, placeImgUrl: attractionImgUrl, type: type)),
                                                                  
                                                                  setState(() {
                                                                        isFavList[index] = true;
                                                                  }),
                                                                                            
                                                                } else {
                                                                  
                                                                  //remove favorite form the database-----------------
              
                                                                    BlocProvider.of<placeListBloc>(context).add(placeRemoveFromFavorites(atPlaceId: atPlaceId)),
              
                                                                  setState(() {
                                                                        isFavList[index] = false;
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
                                                                            
                                                                            Image.asset(isFavList[index]?"assets/images/heartBlack.png":"assets/images/heart.png",width:18,height:18),
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
                                            child: Text(attractionName,
                                            
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
                                        padding: const EdgeInsets.only(left:3),
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
                                        height:10,
                                        child: Text(address,
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
                      }else{
                       return
                        GestureDetector(
                          onTap: () => _loadMore(),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(child: Text("See more")),
                          )
                        );
                      } 
                    },
                  ),
          ),
        ):
              const SizedBox(
                    width:360,
                    height:130,
                    child: Center(
                      child: Text("No Data")
                  )
                ),
          ):
          ListView.builder(
                      scrollDirection: Axis.horizontal, 
                      itemCount: 5,
                      physics:const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        
                          return Card(
                          elevation: 0,
                          color:Color.fromARGB(255, 255, 255, 255),
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
                                      height: 180,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                
                                          
                                  ],
                                ),
                                
                               ],
                                                      
                            ),
                          )
                            
                        ); 
                      },
                    ),
        
        
        ),
      );
    
    
  }
}