import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travelapp/models/favorites.dart';
import 'package:travelapp/ui/components/shimmer.dart';
import 'package:travelapp/ui/components/shimmerLoading.dart';
import '../blocs/place/placeList_bloc.dart';
import '../blocs/place/place_event.dart';
import 'placeDeatailsScreen/locationDetails.dart';

class myFavorite extends StatefulWidget {
  const myFavorite({super.key});

  @override
  State<myFavorite> createState() => _myFavoriteState();
}

class _myFavoriteState extends State<myFavorite> {

  final _shimmerGradient = const LinearGradient(
  colors: [
    Color(0xFFEBEBF4),
    Color(0xFFF4F4F4),
    Color(0xFFEBEBF4),
  ],
  stops: [
    0.1,
    0.3,
    0.4,
  ],
  begin: Alignment(-1.0, -0.3),
  end: Alignment(1.0, 0.3),
  tileMode: TileMode.clamp,
);

  List<Favorite> favListSnapshot = [];
  bool isLoading= true;
  bool isback = false;

  @override
  void initState() {
    super.initState();
    getFavorites();
  } 

  Future<void> getFavorites() async {
    favListSnapshot=await placeBloc.getFavorites();
    setState(() {
      favListSnapshot;
      isLoading=false;
    });
  }

  Future<void> navigateAndDisplaySelection(BuildContext context,placeType,placeId) async {

    if(placeType=='locality'){
                
      isback=await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => locationDetails(
            placeId:placeId,searchType:'city')));

    }else{
    
      isback=await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => locationDetails(
          placeId:placeId,searchType:'attraction')));

    }
    //refresh ui when pop--------
    if(isback == true){
      getFavorites();
      isback=false;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      linearGradient: _shimmerGradient,
      child: Scaffold(
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
                 // ignore: unnecessary_null_comparison
                 isLoading!=true? Expanded(
                   child: ScrollConfiguration(
                       behavior:const ScrollBehavior(),
                       child:favListSnapshot.isNotEmpty? 
                       GlowingOverscrollIndicator(
                         axisDirection: AxisDirection.down,
                         color:Color.fromARGB(255, 83, 83, 83),
                         child: ListView.builder(
                           itemCount: favListSnapshot.length,
                           itemBuilder: (context, index){
                             return
                               GestureDetector(
                                 onTap: () {
                                     navigateAndDisplaySelection(context,favListSnapshot[index].placeType,
                                     favListSnapshot[index].placeId);
                                 },
                                 child: Card(
                                 color:const Color.fromARGB(255, 253, 250, 250),
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
                                             image: NetworkImage(favListSnapshot[index].placePhotoUrl),
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
                                                   child: Text(favListSnapshot[index].placeName,
                                                   overflow: TextOverflow.ellipsis,
                                                     style: GoogleFonts.cabin(
                                                           // ignore: prefer_const_constructors
                                                           textStyle: TextStyle(
                                                           color: const Color.fromARGB(255, 12, 6, 6),
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
                                                             color:const Color.fromARGB(197, 221, 220, 220),
                                                             clipBehavior: Clip.antiAliasWithSaveLayer,
                                                             shape: RoundedRectangleBorder(
                                                                     borderRadius: BorderRadius.circular(5.0),
                                                                   ),
                                                               child: FittedBox(
                                                                       fit: BoxFit.cover,
                                                                       child:Padding(
                                                                         padding: const EdgeInsets.all(10.0),
                                                                         child: Text(favListSnapshot[index].placeType,
                                                                           style: GoogleFonts.cabin(
                                                                             // ignore: prefer_const_constructors
                                                                             textStyle: TextStyle(
                                                                             color: const Color.fromARGB(255, 95, 95, 95),
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
                                               onTap: () {
                                                 //remove favorite form the database-----------------
                                                  BlocProvider.of<placeListBloc>(context).add(
                                                   placeRemoveFromFavorites(atPlaceId:favListSnapshot[index].placeId ));
                                                 setState(() {
                                                   favListSnapshot.removeWhere((element) =>
                                                     element.placeId ==favListSnapshot[index].placeId);
                                                 });
                                                 // //show message to the user-----------------
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
                         
                         ),
                       ):Padding(
                       padding: const EdgeInsets.only(top:210),
                       child: Container(
                         height:200,
                         alignment: Alignment.topCenter,
                         child: Column(
                           children: [
                             Container(
                               width: 70,
                               height:80,
                               child:Image.network("https://cdn-icons-png.flaticon.com/128/4715/4715416.png"),
                             ),
                             Text("No favorites add to the list",
                               style: GoogleFonts.cabin(
                                 // ignore: prefer_const_constructors
                                 textStyle: TextStyle(
                                 color: const Color.fromARGB(255, 95, 95, 95),
                                 fontSize: 16,
                                 fontWeight: FontWeight.bold,
                                                                                           
                                 ) 
                               )
                             
                             )
                           ],
                         ),
                       ),
                     ),
                   ),
                 ):

            
                Expanded(
                child:
                  ListView.builder(
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return
                        Card(
                        color:const Color.fromARGB(255, 253, 250, 250),
                        key: ValueKey(index),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(17.0),
                        ),
                        elevation: 2,
                        child: Container(
                          height:90,
                          child: Row(
                            children: [
                              ShimmerLoading(
                                isLoading: true,
                                child: Container(
                                  height: 90,
                                  width: 90,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
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
                                          child:  ShimmerLoading(
                                            isLoading: true,
                                            child: Container(
                                            width: 150,
                                            height: 15,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.circular(16),
                                            ),
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
                                                    color:const Color.fromARGB(197, 221, 220, 220),
                                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                                    shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(5.0),
                                                          ),
                                                      child: FittedBox(
                                                              fit: BoxFit.cover,
                                                              child:Padding(
                                                                padding: const EdgeInsets.all(10.0),
                                                                child:  ShimmerLoading(
                                                                  isLoading: true,
                                                                  child: Container(
                                                                    width: 60,
                                                                    height: 16,
                                                                    decoration: BoxDecoration(
                                                                      color: Colors.black,
                                                                      borderRadius: BorderRadius.circular(16),
                                                                    ),
                                                                  ),
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
                                      ShimmerLoading(
                                        isLoading: true,
                                        child: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                          ),
                                      ),
                                  ],
                                ),
                              )
                            ],
                          )
                        )
                        );
                    
                    }
                  
                  ),

              ),
              ]
        ),
      ),
      );
                      
                
                
                
      
            
  }
}

  