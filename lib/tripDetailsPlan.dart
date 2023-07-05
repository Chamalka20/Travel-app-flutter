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
import 'navigationPage.dart';

class tripDetailsPlan extends StatefulWidget {

 bool isSelectPlaces;

 tripDetailsPlan({required this.isSelectPlaces, Key? key}) : super(key: key);
 
  

  @override
  State<tripDetailsPlan> createState() => _tripDetailsPlanState(isSelectPlaces);
}

class _tripDetailsPlanState extends State<tripDetailsPlan> {

  bool isSelectPlaces;
  
  List listTiles = [];
  var day = 1;
  var currentIndex = 0 ;
  var  tripPlaces;
  var addPlaces =[];
  var tripDays ={};
  var storeTripDays={};
  late List<dynamic>  selectedData ;
  bool isTriphasData =false;
  bool isAddDay =false;
  ScrollController scrollController = ScrollController();
  
  _tripDetailsPlanState(this.isSelectPlaces);



   @override
  void initState() {
    super.initState();

    if(isSelectPlaces == true) {

       _asyncMethod() ;
    }else{

      setTripDetails();
    }
   
     scrollController; 
  }

  _asyncMethod() async {

    final prefs = await SharedPreferences.getInstance();
    final searchType = prefs.getString('searchType');
    //get data list from database-------------------------------
    
    if(searchType =='city'){
  
      selectedData = await fechApiData.getCityDetails();
      listSelectedPlaces (); 
      

    }else if(searchType =='attracrions'){
      setTripDetails();
      selectedData = await fechApiData.getattractionDetails();
      listSelectedPlaces ();   
      
    }else if(searchType =='resturants'){
      setTripDetails();
      selectedData = await fechApiData.getResturantDetails();
      listSelectedPlaces (); 
    }
    

  } 


   Future <void> setTripDetails()async{

    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('trip');
    currentIndex = prefs.getInt('selectDay')!;
    final trip = jsonDecode(data!);


    if(isSelectPlaces!= true){

      final encodata = json.encode(tripDays);
      prefs.setString('tripdays',encodata ); 

    }
    

    
    for(var i=1;i<=trip['tripDays'];i++){

      listTiles.add(i);

      
    }
    print(listTiles);

    setState(() {
      listTiles;
    });

   }


  Future <void> listSelectedPlaces ()async{

    final prefs = await SharedPreferences.getInstance();
    final tripPlace = prefs.getString('TripPlaceIds');
    

    setState(() {
      isTriphasData =true;

    });
    
    
    


    final decodeData = jsonDecode(tripPlace!);

    addPlaces=selectedData.map((element) { 

      if(decodeData[0]['places'].contains(element['placeId'])){
        
        return {
          "name":element['title'],
          "photo_reference":element['imageUrls'][0],

        };

      }

    }).where((element) => element != null).toList();  

    if(addPlaces!=null){
      tripPlaces=addPlaces;
    }
    
   
  final endata = prefs.getString('tripdays');
  storeTripDays =jsonDecode(endata!);

  if(storeTripDays['${currentIndex}'] == null){

    storeTripDays['${currentIndex}']=addPlaces;

    final encodata = json.encode(storeTripDays);
    prefs.setString('tripdays',encodata );

    print(storeTripDays);

  }else{
    
    storeTripDays['${currentIndex}']+=addPlaces;

    final encodata = json.encode(storeTripDays);
    prefs.setString('tripdays',encodata );

    print(storeTripDays);

  }

  

    setState(() {
      tripDays;
      tripPlaces;
    });

     

  }
  
  Future<void> reorderData(int oldIndex, int newIndex) async {
    setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final item = storeTripDays['${currentIndex}'].removeAt(oldIndex);
          storeTripDays['${currentIndex}'].insert(newIndex, item);
        });

    //temporaly store user changers------------------------------------
    final prefs = await SharedPreferences.getInstance();
    final encodata = json.encode(storeTripDays);
    prefs.setString('tripdays',encodata );


  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
                        onPressed: () async{
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setString('trip','' );
                          prefs.setString('tripdays','' );

                          Navigator.of(context).pushReplacement(customPageRoutes(
                    
                          child: navigationPage(isBackButtonClick:true)));  
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
          onPressed: () =>{},// Navigator.of(context).pop(),
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
                                    controller: scrollController,
                                    cacheExtent: 9999,
                                    scrollDirection: Axis.horizontal, 
                                    itemCount: listTiles.length,
                                    itemBuilder: (context, index) {
                                      
                                      if (index == listTiles.length - 1) {

                                        // add trip days------------------------------
                                        return GestureDetector(
                                          onTap: () async {
                                            currentIndex=0;
                                            setState(()  {
                                              listTiles.add(listTiles.length+1);
                                              isAddDay =true;
                                              currentIndex =index;
                                            });


                                            //when tap the add button scrolling to the center-----------------------------
                                            scrollController.animateTo(scrollController.offset + 130,
                                              curve: Curves.linear, duration: Duration(milliseconds: 500));
                                            //change trip days-----------------------------
                                            final prefs = await SharedPreferences.getInstance();
                                            final data = prefs.getString('trip');
                                            final trip = jsonDecode(data!);
                                            trip['tripDays'] =listTiles.length;
                                            //Re store temproly -----------------------------------
                                            final endata = jsonEncode(trip);
                                            prefs.setString('trip', endata);
                                            
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

                                            if(isSelectPlaces==true && storeTripDays['${currentIndex}']==null && isAddDay ==false){

                                              null
                                            }else{

                                              setState(() {
   
                                                day =listTiles[index];
                                                currentIndex = index;
                                                isSelectPlaces=false;
                                                tripDays;
                                              }),
                                              print("${currentIndex+1}"),
                                            }
                                            
                                           
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
      body: buildBody(),
      ),
    );
  }




  Widget buildBody() {

  final ColorScheme colorScheme = Theme.of(context).colorScheme;
  final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
  final Color evenItemColor = colorScheme.primary.withOpacity(0.15);

   if(isSelectPlaces==true && storeTripDays['${currentIndex}']!=null){
   return  
   
      Padding(
         padding: const EdgeInsets.only(top:17),
         child: Column(
           children: [
               Expanded(
                 child: Stack(
                   children: [
                    ReorderableListView(
                     
                     padding: const EdgeInsets.symmetric(horizontal: 10,),
                     onReorder: reorderData,
                     children: <Widget>[
                       for (int index = 0; index < storeTripDays['${currentIndex}'].length; index += 1)
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
                                    image: NetworkImage(storeTripDays['${currentIndex}'][index]['photo_reference']),
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
                                          child: Text(storeTripDays['${currentIndex}'][index]['name'],
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
                       )
                     ],
                   ),
                   Visibility(
                    visible: isTriphasData,
                     child: Positioned(
                      top:410,
                      left:20,
                      child:Row(
                        children: [
                          SizedBox(
                            width:150,
                            child: TextButton(
                                onPressed:() async{

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
                                                  onTap: () async{

                                                    final prefs = await SharedPreferences.getInstance();
                                                    prefs.setInt('selectDay',currentIndex );
                                                    prefs.setString('searchType','attracrions' ); 

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
                                                  onTap: () async {
                                                    final prefs = await SharedPreferences.getInstance();
                                                    prefs.setInt('selectDay',currentIndex );
                                                    prefs.setString('searchType','resturants' ); 

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
                                  backgroundColor: Color.fromARGB(255, 2, 94, 14),
                                  foregroundColor:Color.fromARGB(255, 255, 255, 255),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20), 
                                    ),
                                  
                                ),
                                child: Text('Add places',
                                    style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        
                                
                                    ),
                                
                                ),
                              ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left:10),
                            child: SizedBox(
                              width:150,
                              child: TextButton(
                                  onPressed:() async{
                                    
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromARGB(255, 0, 0, 0),
                                    foregroundColor:Color.fromARGB(255, 255, 255, 255),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20), 
                                      ),
                                    
                                  ),
                                  child: Text('Create a trip',
                                      style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          
                                  
                                      ),
                                  
                                  ),
                                ),
                            ),
                          )
                        ],
                      ),
                      
                      ),
                   )
                   ]
                 ),
               )
             
              
           ],
         ),
       );
}else if(isSelectPlaces==false && storeTripDays['${currentIndex}']!=null){
    return  
   
       Padding(
         padding: const EdgeInsets.only(top:17),
         child: Column(
           children: [
               Expanded(
                 child: Stack(
                   children: [
                    ReorderableListView(
                     
                     padding: const EdgeInsets.symmetric(horizontal: 10,),
                     onReorder: reorderData,
                     children: <Widget>[
                       for (int index = 0; index < storeTripDays['${currentIndex}'].length; index += 1)
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
                                    image: NetworkImage(storeTripDays['${currentIndex}'][index]['photo_reference']),
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
                                          child: Text(storeTripDays['${currentIndex}'][index]['name'],
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
                       )
                     ],
                   ),
                   Visibility(
                    visible: isTriphasData,
                     child: Positioned(
                      top:410,
                      left:20,
                      child:Row(
                        children: [
                          SizedBox(
                            width:150,
                            child: TextButton(
                                onPressed:() async{
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
                                                  onTap: () async{

                                                    final prefs = await SharedPreferences.getInstance();
                                                    prefs.setInt('selectDay',currentIndex );
                                                    prefs.setString('searchType','attracrions' );

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
                                                  onTap: () async {
                                                    
                                                    final prefs = await SharedPreferences.getInstance();
                                                    prefs.setInt('selectDay',currentIndex );
                                                    prefs.setString('searchType','resturants' );

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
                                  backgroundColor: Color.fromARGB(255, 2, 94, 14),
                                  foregroundColor:Color.fromARGB(255, 255, 255, 255),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20), 
                                    ),
                                  
                                ),
                                child: Text('Add places',
                                    style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        
                                
                                    ),
                                
                                ),
                              ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left:10),
                            child: SizedBox(
                              width:150,
                              child: TextButton(
                                  onPressed:() async{
                                    final prefs = await SharedPreferences.getInstance();
                                    final data = prefs.getString('trip');
                                    final trip = jsonDecode(data!);
                                    final enTrip = jsonEncode(storeTripDays);

                                    await fechApiData.creatTrip(trip['tripName'],trip['tripudget'],trip['tripLocation'],
                                    trip['tripDuration'],trip['tripDescription'],'fgdf',enTrip);

                                    print('done');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromARGB(255, 0, 0, 0),
                                    foregroundColor:Color.fromARGB(255, 255, 255, 255),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20), 
                                      ),
                                    
                                  ),
                                  child: Text('Create a trip',
                                      style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          
                                  
                                      ),
                                  
                                  ),
                                ),
                            ),
                          ),
                        ],
                      ),
                      
                      ),
                   )
                   ]
                 ),
               )
             
              
           ],
         ),
       );

   }else if(isSelectPlaces==true && storeTripDays['${currentIndex}']==null&& isAddDay ==false){

     return const Center(
        child: CircularProgressIndicator(),
      );


   }else{

     return Center(
           child: Container(
   
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                                              onTap: () async{

                                                final prefs = await SharedPreferences.getInstance();
                                                prefs.setInt('selectDay',currentIndex );
                                                prefs.setString('searchType','attracrions' );
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
                                              onTap: () async {
                                                final prefs = await SharedPreferences.getInstance();
                                                prefs.setInt('selectDay',currentIndex );
                                                prefs.setString('searchType','resturants' );
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
         ); 
   
  


   }
  }
}