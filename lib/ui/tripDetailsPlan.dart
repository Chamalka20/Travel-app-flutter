import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../blocs/trip/trip_bloc.dart';
import '../blocs/trip/trip_event.dart';
import '../blocs/trip/trip_state.dart';
import '../models/place.dart';
import '../models/trip.dart';
import 'components/emptyTripPlaces.dart';
import 'components/modalBottomSheetButton.dart';
import 'navigationPage.dart';

// ignore: must_be_immutable
class tripDetailsPlan extends StatefulWidget {

 bool isEditPlace;
 bool isAddPlace;
 Trip trip; 
 Place place;
 tripDetailsPlan({required this.isEditPlace,required this.isAddPlace,required this.trip ,required this.place,Key? key}) : super(key: key);
  
  @override
  State<tripDetailsPlan> createState() => _tripDetailsPlanState(isEditPlace,isAddPlace,trip,place);
}

class _tripDetailsPlanState extends State<tripDetailsPlan> {

  bool isEditPlace;
  bool isAddPlace;
  Trip trip;
  Place place;
  List listTiles = [];
  var newEndDate;
  var newDurationCount;
  var day = 1;
  bool isTextFieldClicked= false;
  String  inputData='';
  List dailogBoxState=[{
    'isSelectCity':false,
    'isTextfiledEmpty':false,
    'selectedPlaces':[],
  }];

  var currentIndex = 0 ;
  var  tripPlaces;
  var addPlaces =[];
  var tripDays ={};
  var storeTripDays={};
  late List<dynamic>  selectedData ;
  bool isDaySlect = false;
  bool isAddDay =false;
  List selectedIds =[];
  var dayInPlacesList=[];
  var allTripPlaces={};
  ScrollController scrollController = ScrollController();
  
  _tripDetailsPlanState(this.isEditPlace,this.isAddPlace,this.trip,this.place);


   @override
  void initState() {
    super.initState();
    
    if(isEditPlace== true) {
      
      setTripDetails();
      editTrip();
  
    }else{
     
      setTripDetails();
    }
   
     scrollController; 
  }

@override
  void dispose(){
   
    super.dispose();
    scrollController.dispose();
    
  }

  


   Future <void> setTripDetails()async{

    currentIndex = 0;
    //when tap the add button scrolling to the related day-----------------------------
    scrollController.animateTo(
        currentIndex * (100),
        duration: const Duration(microseconds: 800),
        curve: Curves.decelerate,
    );
    

    
     for(var i=0;i<=trip.durationCount;i++){

      if(listTiles.contains(i)){
        return;
      }else{

        listTiles.add(i);
      }
      

    
    }
   
    
    print(listTiles);

    setState(() {
      listTiles;
    });

   }
 
//-----------------------------------------------------------------------
  Future <void> editTrip()async{

    BlocProvider.of<tripBloc>(context).add(editPlaces(trip.places));

  } 
//-------------------------------------------------------------------

  //move places---------------------------------------------

  Future<void> reorderData(int oldIndex, int newIndex) async {
    setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final item = dayInPlacesList.removeAt(oldIndex);
          dayInPlacesList.insert(newIndex, item);
        });

    //temporaly store user changers------------------------------------
    // final prefs = await SharedPreferences.getInstance();
    // final encodata = json.encode(storeTripDays);
    // prefs.setString('tripdays',encodata );


  }

  void createTrip (){

    Trip newTrip=Trip(
          tripId: trip.tripId, 
          tripName: trip.tripName, 
          tripBudget: trip.tripBudget, 
          tripLocation: trip.tripLocation, 
          tripDescription: trip.tripDescription, 
          tripCoverPhoto: trip.tripCoverPhoto,
          tripDuration: '${DateFormat('yyyy-MM-dd').format(trip.startDate)} - ${DateFormat('yyyy-MM-dd').format(newEndDate??trip.endDate)}', 
          durationCount:newDurationCount ?? trip.durationCount,
          startDate: trip.startDate, 
          endDate:newEndDate?? trip.endDate, 
          places: allTripPlaces
        );

    if(allTripPlaces.isNotEmpty){

      if(isEditPlace!=true){

        BlocProvider.of<tripBloc>(context).add
            (creatTrip(newTrip));

      }else{
        
        BlocProvider.of<tripBloc>(context).add
            (updateTrip(newTrip));

      }
    }

  }

  

//user add place to the trip and pop up message--------------------------------------
//================================================================================
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {

        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
          title:  Text("Select Day",
                    style: GoogleFonts.cabin(
                    // ignore: prefer_const_constructors
                    textStyle: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                                                  
                    ) 
                  )
                ),
          content: 
          
          SizedBox(
            height:200,
            child: Column(
              children: [
                Expanded(
                    child: ScrollConfiguration(
                      behavior:const ScrollBehavior(),
                      child: GlowingOverscrollIndicator(
                        axisDirection: AxisDirection.down,
                        color:Color.fromARGB(255, 83, 83, 83),
                        child: ListView.builder(
                                  cacheExtent: 9999,
                                  scrollDirection: Axis.vertical, 
                                  itemCount: listTiles.length,
                                  itemBuilder: (context, index) {
                                    
                                    if (index == listTiles.length - 1) {
                                        
                                      
                                      return GestureDetector(
                                        // add trip days------------------------------
                                        onTap: ()  {
                                    
                                         
                                          
                                        },
                                        child: Container(
                                            width: 40,
                                            height:40,
                                            color:Color.fromARGB(0, 230, 230, 230),
                                            child: Image.asset('assets/images/add-black.png')
                                            
                                            ),
                                      );
                                    }else{
                                        
                                      return GestureDetector(
                                        onTap: () async {
                                    
                                            BlocProvider.of<tripBloc>(context).add
                                                (planingPlaces([place],index));
                                            
                                            setState(() {
                                    
                                              day =listTiles[index];
                                              isAddPlace = false;
                                              currentIndex=index;
                                              //when tap the add button scrolling to the related day-----------------------------
                                              scrollController.animateTo(
                                                  index * (100),
                                                  duration: const Duration(microseconds: 800),
                                                  curve: Curves.decelerate,
                                              );
                                    
                                              tripDays;
                                            });
                                            print(index);
                                          
                                    
                                          Navigator.pop(context, true);
                                          
                                          
                                        
                                        },
                                        child: Card(
                                        elevation: 0,
                                        color:Color.fromARGB(255, 0, 0, 0),
                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                        shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                        child:Container(
                                          height:60,
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
                                                              color: Color.fromARGB(255, 255, 255, 255),
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
                    ),
                ),
              ],
            ),
          ),
          actions: [
           
          TextButton(
            onPressed: () {
              
              Navigator.pop(context, true);
              Navigator.pop(context, true);// Dismisses dialog
              Navigator.pop(context, true);// Navigates back to previous screen   
            },
            child: Text('Go back'),
          ),
            
          ],
          
        ),
    
    );

      },
    );
  }


  @override
  Widget build(BuildContext parentContext) {
    //if show popupbox when user add place to the trip-----------------------
    // ignore: unrelated_type_equality_checks
    if(isAddPlace == true){

      Future.delayed(Duration.zero, () => _showDialog());
      return 
        buildBody(parentContext);
    
    }else{
      return
        buildBody(parentContext);

    }
    
  }
 //==============================================================================
 //============================================================================== 

Widget buildBody(BuildContext parentContext) {
   
  return
    WillPopScope(
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
                          BlocProvider.of<tripBloc>(context).add(cancelPlaningPlaces());
                          dayInPlacesList=[];
                          Navigator.pop(context, true);  
                        },
                        child: Text('No'),
                      ),
                    ],
                  );
                },
              );
      return confirmExit;
      }, 
      child: 
           Scaffold(
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
                                 padding: const EdgeInsets.only(top:15,left:240),
                                 child: TextButton(
                                  onPressed:() async{
                                    createTrip();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromARGB(255, 2, 94, 14),
                                    foregroundColor:Color.fromARGB(255, 255, 255, 255),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10), 
                                      ),
                                    
                                  ),
                                  child: Text('Create Trip',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          
                                  
                                      ),
                                  
                                  ),
                                ),
                               ),
                               Padding(
                                 padding: const EdgeInsets.only(top:9,left:10,right: 10),
                                 child: SizedBox(
                                   height: 50,
                                     child: Row(
                                       children: [
                                         Expanded(
                                         child: ScrollConfiguration(
                                           behavior:const ScrollBehavior(),
                                           child: GlowingOverscrollIndicator(
                                             axisDirection: AxisDirection.right,
                                             color:Color.fromARGB(255, 83, 83, 83),
                                             child: ListView.builder(
                                               controller: scrollController,
                                               cacheExtent: 9999,
                                               scrollDirection: Axis.horizontal, 
                                               itemCount: listTiles.length,
                                               itemBuilder: (context, index) {
                                                 
                                                 if (index == listTiles.length - 1) {
                                                       
                                                   
                                                   return GestureDetector(
                                                     // add trip days------------------------------
                                                     onTap: () async {
                                                       currentIndex=0;
                                                       
                                                       setState(()  {
                                                         listTiles.add(listTiles.length+1);
                                                         isAddDay =true;
                                                         currentIndex =index;
                                                         
                                                       });
                                             
                                                       if(newEndDate!=null && newDurationCount!=null){
                                                        var oldDate =newEndDate;
                                                        var newDate=DateTime(oldDate.year,oldDate.month,oldDate.day+1);
                                                        newEndDate= newDate;
                                                        newDurationCount+=1;
                                                        print(newDurationCount);
                                                       }else{
                                             
                                                        var oldDate =trip.endDate;
                                                        var newDate=DateTime(oldDate.year,oldDate.month,oldDate.day+1);
                                                        newEndDate= newDate;
                                                        newDurationCount=trip.durationCount+1;
                                                        print(newDurationCount);
                                             
                                                       }
                                             
                                                        //when tap the add button scrolling to the center-----------------------------
                                                       scrollController.animateTo(scrollController.offset + 130,
                                                         curve: Curves.linear, duration: Duration(milliseconds: 500));
                                             
                                                        BlocProvider.of<tripBloc>(context).add
                                                          (planingPlaces([],currentIndex));
                                                      
                                                       
                                             
                                                       
                                                       
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
                                                       
                                                      setState(() {
                                                           
                                                        day =listTiles[index];
                                                        currentIndex = index;
                                                        tripDays;
                                                      }),
                                                      
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
             
             body: tripList(parentContext),
             
           ),
    );

}


  Widget tripList(BuildContext parentContext) {

    return
    BlocConsumer<tripBloc,tripState>( 
      listener: (context, state) {
        if(state is tripCreateErrorState){
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Something went wrong")));

        }else if(state is tripCreatingSuccessState){
           Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  navigationPage(isBackButtonClick: true,autoSelectedIndex: 2,)),
          );
        }

      },
      builder: (BuildContext context, state) { 
          if(state is storeTripPlacesState){
            
            if(state.storeTripPlaces['${currentIndex}']!=null){

              if(state.storeTripPlaces['${currentIndex}'].isNotEmpty){
              
                allTripPlaces=state.storeTripPlaces;
              
                return
                Padding(
                padding: const EdgeInsets.only(top:17),
                child: Column(
                  children: [
                      Expanded(
                        child: Stack(
                          children: [
                         ScrollConfiguration(
                           behavior:const ScrollBehavior(),
                           child: GlowingOverscrollIndicator(
                            axisDirection: AxisDirection.down,
                            color:Color.fromARGB(255, 83, 83, 83),
                            child: ReorderableListView(
                                
                                padding: const EdgeInsets.symmetric(horizontal: 10,),
                                onReorder: reorderData,
                                children: <Widget>[
                                  
                                  for (int index = 0; index < state.storeTripPlaces['$currentIndex'].length; index += 1)
                                    
                                      
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
                                                    image: NetworkImage(state.storeTripPlaces['$currentIndex'][index]['imageUrls']),
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
                                                          child: Text(state.storeTripPlaces['$currentIndex'][index]['title'],
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
                                        ),
                                  
                                ]
                              ),
                            ),
                         ),
                          Visibility(
                          visible: state.storeTripPlaces['$currentIndex'].isNotEmpty,
                            child: Positioned(
                            top:410,
                            left:100,
                            child:Row(
                              children: [
                                SizedBox(
                                  width:150,
                                  child:modalBottomSheetButton(currentIndex: currentIndex, parentContext: parentContext,)
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
            }else{
              return emptyTripPlaces(currentIndex: currentIndex, parentContext:context,);
            }
          }else{
            return emptyTripPlaces(currentIndex: currentIndex, parentContext:context,);
          }

       }else{
        return emptyTripPlaces(currentIndex: currentIndex, parentContext:context,);
       }
      }
       
    );
  }
}