import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travelapp/ui/fechApiData.dart';

import 'placeDeatailsScreen/locationDetails.dart';

class myFavorite extends StatefulWidget {
  const myFavorite({super.key});

  @override
  State<myFavorite> createState() => _myFavoriteState();
}

class _myFavoriteState extends State<myFavorite> {

  List favorites =[];

  @override
  void initState() {
    super.initState();

    getFavoriteList ();
  } 

Future <void> getFavoriteList ()async{

  

favorites=await fechApiData.getFavorites();

  setState(() {
   favorites;
  });

  //   if(trips == null){

  //       setState(() {
  //         isDataReady= false;
          
  //     });
        
  //   }else{
  //        setState(() {
  //         isDataReady= true;
          
  //         print(trips[1]);
  //       });
  //     }

    
   }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left:13,bottom: 15,top:25),
                child: Row(
                  children: [
                    Text("Favorites",
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
              Expanded(
                child:
                  ListView.builder(
                    cacheExtent: 9999, 
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      return
                        GestureDetector(
                          onTap: () {
                            if(favorites[index]['placeType']=='city'){

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => locationDetails(placeId:favorites[index]['placeId'],searchType:'city')));

                            }else{
                            
                              Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => locationDetails(placeId:favorites[index]['placeId'],searchType:'attraction')));

                            }  

                          },
                          child: Card(
                           color:Color.fromARGB(255, 253, 250, 250),
                           key: ValueKey(index),
                           shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(17.0),
                           ),
                           elevation: 2,
                           child: Container(
                             height:90,
                             child: Row(
                              children: [
                                Container(
                                  height: 90,
                                  width: 90,
                                   decoration: BoxDecoration(
                                    
                                    borderRadius: BorderRadius.circular(17),
                                    image: DecorationImage(
                                      image: NetworkImage(favorites[index]['placePhotoUrl']),
                                      fit: BoxFit.cover
                                              
                                    ),
                                  
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left:6,top:5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 200,
                                            child: Text(favorites[index]['placeName'],
                                            overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.cabin(
                                                    // ignore: prefer_const_constructors
                                                    textStyle: TextStyle(
                                                    color: Color.fromARGB(255, 12, 6, 6),
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                            
                                                    ) 
                                                  ),
                                            
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top:13),
                                            child: SizedBox(
                                                height:28,
                                                child: Card(
                                                    elevation: 0,
                                                      color:Color.fromARGB(197, 221, 220, 220),
                                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                                      shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(5.0),
                                                            ),
                                                        child: FittedBox(
                                                                fit: BoxFit.cover,
                                                                child:Padding(
                                                                  padding: const EdgeInsets.all(10.0),
                                                                  child: Text('${favorites[index]['placeType']}',
                                                                    style: GoogleFonts.cabin(
                                                                      // ignore: prefer_const_constructors
                                                                      textStyle: TextStyle(
                                                                      color: Color.fromARGB(255, 95, 95, 95),
                                                                      fontSize: 16,
                                                                      fontWeight: FontWeight.bold,
                                                                                                                                
                                                                      ) 
                                                                    )
                                                                                                                                  
                                                                  ),
                                                                ), 
                                                          )
                                                    
                                                ),
                                              ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top:35),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () async{
                                          
                                          //remove favorite form the database-----------------
                                          await fechApiData.removeFavorites(favorites[index]['placeId']);
                                          getFavoriteList();
                        
                                          //show message to the user-----------------
                                          ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(content:Text("Removed place from the favorites"))); 
                                        },
                                        child: SizedBox(
                                          width:30,
                                          child: Image.asset("assets/images/heartBlack.png",width:25,height:25),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                             )
                           )
                                               ),
                        );
                    
                    }
                  
                  )
              )
              

            ],
        
      ),

    );
  }
}

  