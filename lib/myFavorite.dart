import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travelapp/fechApiData.dart';

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
                padding: const EdgeInsets.only(left:13,bottom: 20,top:25),
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
                        Card(
                         color:const Color.fromARGB(255, 240, 238, 238),
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
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 200,
                                          child: Text(favorites[index]['placeName'],
                                            style: GoogleFonts.cabin(
                                                  // ignore: prefer_const_constructors
                                                  textStyle: TextStyle(
                                                  color: const Color.fromARGB(255, 27, 27, 27),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                          
                                                  ) 
                                                ),
                                          
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top:35),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width:30,
                                      child: Text('${index+1}',
                                        style: GoogleFonts.cabin(
                                                      // ignore: prefer_const_constructors
                                                      textStyle: TextStyle(
                                                      color: const Color.fromARGB(255, 27, 27, 27),
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.w600,
                                              
                                                      ) 
                                                    ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                           )
                         )
                       );
                    
                    }
                  
                  )
              )
              

            ],
        
      ),

    );
  }
}

  