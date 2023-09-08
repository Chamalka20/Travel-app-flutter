import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelapp/navigationPage.dart';
import 'package:travelapp/tripDetailsPlan.dart';
import 'package:travelapp/fechApiData.dart';


class createNewTrip extends StatefulWidget {

  final String placeName;
  final String placePhotoUrl;
  final isEditTrip;

  const createNewTrip({super.key, required this.placeName,required this.placePhotoUrl,required this.isEditTrip }) ;

  @override
  State<createNewTrip> createState() => _createNewTripState(placeName,placePhotoUrl,isEditTrip);
}

class _createNewTripState extends State<createNewTrip> {
  var isDataReady =false;
  final String placeName;
  final bool isEditTrip;
  late final String backGroundPlacePhotoUrl;
  late final defultBacPhotoUrl;
  late final String planTrips = '5';
  late  String tripName ='';
  var daysDuration;
  var endDate;

  TextEditingController dateinput = TextEditingController(); 
  final TripNameController = TextEditingController();
  final TripBudgetController = TextEditingController();
  final TripLocationController = TextEditingController();
  final TripDescriptionController = TextEditingController();

  _createNewTripState(this.placeName,this.backGroundPlacePhotoUrl,this.isEditTrip);

  
  @override
  void initState(){
     super.initState();
    //get data list from api-------------------------------
    getBackGroundImage ();

    if(isEditTrip ==true){
      editTrip();

    }
  
   
    
  }

  @override
  void dispose(){
    super.dispose();
    TripNameController.dispose();
    TripBudgetController.dispose();
    TripLocationController.dispose();
    TripDescriptionController.dispose();
  }

  Future<void> editTrip()async{

    final prefs = await SharedPreferences.getInstance();
    final endata = prefs.getString('tripdays');
    final storeTripDays =jsonDecode(endata!);

    TripNameController.text =storeTripDays['tripName'];
    tripName =storeTripDays['tripName'];

    defultBacPhotoUrl =storeTripDays['tripCoverPhoto'];

    dateinput.text =storeTripDays['tripDuration'];
    TripBudgetController.text =storeTripDays['tripBudget'];
    TripLocationController.text =storeTripDays['tripLocation'];
    TripDescriptionController.text =storeTripDays['tripDescription'];
  
  }

  Future<void> createTrip ()async{

    if(isEditTrip != true){
    
      final trip ={
        'tripName':TripNameController.text,
        'tripDays':daysDuration??0,
        'tripDuration':dateinput.text,
        'tripudget':TripBudgetController.text,
        'tripLocation':TripLocationController.text,
        'tripDescription':TripDescriptionController.text,
        'tripCoverPhoto':defultBacPhotoUrl.isNotEmpty?defultBacPhotoUrl:backGroundPlacePhotoUrl,
        'endDate':endDate,
      };

      print(trip);

    //temporaly store trip data -------------------------
      final prefs = await SharedPreferences.getInstance();
      final data = json.encode(trip);
      prefs.setString('trip',data );
      prefs.setInt('selectDay',0 );

    }else{

      final prefs = await SharedPreferences.getInstance();
      final endata = prefs.getString('tripdays');
      final storeTripDays =jsonDecode(endata!);

      final places = jsonEncode(storeTripDays['places']);


      final trip ={
        'tripName':TripNameController.text,
        'tripDays':daysDuration!=null?daysDuration:int.parse(storeTripDays['duration'])+1,
        'tripDuration':dateinput.text,
        'tripudget':TripBudgetController.text,
        'tripLocation':TripLocationController.text,
        'tripDescription':TripDescriptionController.text,
        'tripCoverPhoto':defultBacPhotoUrl.isNotEmpty?defultBacPhotoUrl:backGroundPlacePhotoUrl,
        'endDate':endDate!=null?endDate:storeTripDays['endDate'],
        'places':places,
      };

      print(trip);

    //temporaly store trip data -------------------------
      
      final data = json.encode(trip);
      prefs.setString('trip',data );
      prefs.setInt('selectDay',0 );


    }


  }



  //get background image with phone gallary---------------------------------------
   Future<void> getBackGroundImagewithPhone (ImageSource media)async{
    
    final ImagePicker picker = ImagePicker();

    var  response = await picker.pickImage(source: media);

    

    XFile? files = response;

    print(files!.path);


   }


  Future<void> getBackGroundImage ()async{
    

    const apiUrl = 'https://api.pexels.com/v1/search';
    const apiKey = 'xJ7YjKPafnbAqRwAXOw3ambPcpyW2t7NQxKl9l5o1KIn32ZCftaR2LQp';
    final url ='$apiUrl?query=Landscape&per_page=20&orientation=landscape&size=medium';

    final response = await http.get(
      Uri.parse(url),
      headers: {
       
        'Authorization': apiKey,
      },
      
    );

    if (response.statusCode == 200) {

      final tripCount=await fechApiData.countTotalTrips();
      print('photo url get susses');
      
      final data = jsonDecode(response.body);
      final photoUrl = data['photos'][tripCount]['src']['medium']??'https://www.pexels.com/photo/mountain-covered-snow-under-star-572897/';

      if(placeName!="" && backGroundPlacePhotoUrl!="" && isEditTrip ==false){

          defultBacPhotoUrl =  backGroundPlacePhotoUrl ; //set your choose location photo
          tripName =  placeName;     
      }else if(isEditTrip ==false){

        defultBacPhotoUrl = photoUrl;

      }

      if(defultBacPhotoUrl == null){

        setState(() {
          isDataReady= false;
        });
        
      }else{
         setState(() {
          isDataReady= true;
        });
      }
      

    }else{
      print('photo url get faild${response.statusCode}');
    }

    setState(() {
      defultBacPhotoUrl;
    });

  } 
  
  @override
  Widget build(BuildContext context) {

    if(isDataReady == true){

    return WillPopScope(
      onWillPop: () async {
         Navigator.pop(context);
      return true;
      }, 
      child: GestureDetector(
        onTap: () {
          setState(() {
            tripName;
          });
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
           appBar: AppBar(
            toolbarHeight: 1,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Color.fromARGB(0, 255, 255, 255),
              statusBarIconBrightness: Brightness.light, 
              ),
            elevation: 0,
            backgroundColor: Color.fromARGB(0, 20, 12, 12),
      
            
          ),
            body:LimitedBox(
              maxHeight:700,
              child: SingleChildScrollView(
                
                child: Container(
                  width: 360,
                  
                  child: Stack(
                
                    children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width:360,
                              height: 250,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                image: NetworkImage(defultBacPhotoUrl),
                                fit: BoxFit.cover
                                            
                                  ),
                              
                              ),
                              child: Container(
                                width:360,
                                child: Column(
                                                      
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top:40),
                                      child: Column(
                                        children: [
                                          Row(
                                            
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left:130),
                                                child: SizedBox(
                                                  width:150,
                                                  child: Text("Informations Trip",
                                                    style: GoogleFonts.cabin(
                                                        // ignore: prefer_const_constructors
                                                        textStyle: TextStyle(
                                                        color: Color.fromARGB(255, 255, 255, 255),
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                                                        
                                                        ) 
                                                      )
                                                  ),
                                                ),
                                              ),
                                              //uplode image from phone gallery------------------------------------------
                                              Padding(
                                                padding: const EdgeInsets.only(),
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(left:20),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          getBackGroundImagewithPhone (ImageSource.gallery);
                                                        },
                                                        child: Container(
                                                          width:35,
                                                          height:35,
                                                          decoration: BoxDecoration(
                                                            color: Color.fromARGB(100, 255, 255, 255),
                                                            borderRadius: BorderRadius.circular(45)
                                                          ),
                                                          child:const Icon(
                                                            Icons.camera_alt_outlined,
                                                            color: Color.fromARGB(255, 153, 152, 152),
                                                            
                                                            ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    
                                    Padding(
                                      padding: const EdgeInsets.only(top:120,left:13),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width:310,
                                            child: Text(tripName.isNotEmpty?tripName:"My Trip",
                                              overflow: TextOverflow.ellipsis,
                                               style: GoogleFonts.cabin(
                                                    // ignore: prefer_const_constructors
                                                    textStyle: TextStyle(
                                                    color: Color(0xFFEEE6E6),
                                                    fontSize: 33,
                                                    fontWeight: FontWeight.bold,
                                                                                    
                                                    ) 
                                                  )
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                    
                            
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          //text form field----------------------------------------------                      
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                 Padding(
                                   padding: const EdgeInsets.only(top:20),
                                   child: Container(
                                    width:300,
                                    height:60,
                                     child: TextField(
                                      controller: TripNameController,
                                      onTap: () {
                                        setState(() {
                                         
                                        });
                                      },
                                      //get keyboard input value-------------
                                      onChanged: (value) {
                                         //if text filed is empty do this------------------ 
                                        tripName= value;
                                   
                                      },
                                      decoration: InputDecoration(
                                      filled: true,
                                      fillColor:  Color.fromARGB(255, 240, 238, 238),
                                      hintText: 'Trip name',
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
                              ],
                            ),
                            //select trip days----------------------------------------------------------------
                             Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                 Container(
                                  width:300,
                                  height:60,
                                   child: TextField(
                                    controller: dateinput,
                                    readOnly: true,
                                    onTap: () async {
                  
                                       DateTimeRange? pickedDate = await showDateRangePicker(
                                          context: context,
                                          currentDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2101)
                                      );
                  
                  
                                      if(pickedDate != null ){
                                        print(pickedDate);  
                                        String formattedDate1 = DateFormat('yyyy-MM-dd').format(pickedDate.start);
                                        String formattedDate2 = DateFormat('yyyy-MM-dd').format(pickedDate.end); 
                                        
                                        print(pickedDate.duration.inDays); 
                                        daysDuration =pickedDate.duration.inDays;
                                        endDate = formattedDate2;
                                        setState(() {
                                          dateinput.text = '${formattedDate1} - ${formattedDate2}';                      //set output date to TextField value. 
                                        });
                                      }else{
                                          print("Date is not selected");
                                      }
                                        
                                    },
                                    //get keyboard input value-------------
                                    onChanged: (value) {
                                        
                                      
                                 
                                    },
                                    decoration: InputDecoration(
                                    filled: true,
                                    fillColor:  Color.fromARGB(255, 240, 238, 238),
                                    hintText: 'Days',
                                    prefixIcon: Icon(Icons.calendar_month),
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
                              ],
                            ),
                            // select trip budget----------------------------------------------------------------
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                 Container(
                                  width:300,
                                  height:60,
                                   child: TextField(
                                    controller: TripBudgetController,
                                    onTap: () {
                                      setState(() {
                                       
                                      });
                                    },
                                    //get keyboard input value-------------
                                    onChanged: (value) {
                                      
                                      
                                 
                                    },
                                    
                                    decoration: InputDecoration(
                                    filled: true,
                                    fillColor:  Color.fromARGB(255, 240, 238, 238),
                                    hintText: 'Trip budget',
                                    prefixIcon: Icon(Icons.money_sharp),
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
                              ],
                            ),
                            //enter trip location------------------------------------------
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                 Container(
                                  width:300,
                                  height:70,
                                   child: TextField(
                                    controller: TripLocationController,
                                    onTap: () {
                                      setState(() {
                                       
                                      });
                                    },
                                    //get keyboard input value-------------
                                    onChanged: (value) {
                                      
                                      
                                 
                                    },
                                    
                                    decoration: InputDecoration(
                                    filled: true,
                                    fillColor:  Color.fromARGB(255, 240, 238, 238),
                                    hintText: 'Enter location',
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
                                      borderRadius: BorderRadius.circular(12.0),
                                      
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                                    ),
                                                       
                                                       
                                    ),
                                 ),
                              ],
                            ),
                             //enter trip description------------------------------------------
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                 Container(
                                  width:300,
                                  height:70,
                                   child: TextField(
                                    controller: TripDescriptionController,
                                    maxLines: 10,
                                    onTap: () {
                                      setState(() {
                                       
                                      });
                                    },
                                    //get keyboard input value-------------
                                    onChanged: (value) {
                                      
                                      
                                 
                                    },
                                    
                                    decoration: InputDecoration(
                                    filled: true,
                                    fillColor:  Color.fromARGB(255, 240, 238, 238),
                                    hintText: 'Description',
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
                                      borderRadius: BorderRadius.circular(12.0),
                                      
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                                    ),
                                                       
                                                       
                                    ),
                                 ),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Visibility(
                                      visible: isEditTrip,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 20.0,right: 20),
                                        child: SizedBox(
                                            width: 100,
                                            height: 45,
                                            child: TextButton(
                                              onPressed: () async {

                                                //save user edit details--------------------------------------
                                                final prefs = await SharedPreferences.getInstance();
                                                final endata = prefs.getString('tripdays');
                                                final storeTripDays =jsonDecode(endata!);

                                                final places = jsonEncode(storeTripDays['places']);
                                                

                                                await fechApiData.editTrip(TripNameController.text,TripBudgetController.text
                                                    ,TripLocationController.text,dateinput.text,TripDescriptionController.text,
                                                    defultBacPhotoUrl.isNotEmpty?defultBacPhotoUrl:backGroundPlacePhotoUrl,daysDuration==null? storeTripDays['duration']:daysDuration.toString(),endDate?? storeTripDays['endDate'],places);

                                                Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) =>  navigationPage(isBackButtonClick: true,autoSelectedIndex: 2,)),
                                                );
                                                
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Color.fromARGB(255, 0, 0, 0),
                                                foregroundColor:Color.fromARGB(255, 255, 255, 255),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20), 
                                                  ),
                                                
                                              ),
                                              child: Text('Save',
                                                  style: GoogleFonts.roboto(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16,
                                                      
                                              
                                                  ),
                                              
                                              ),
                                            ),
                                          ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20.0,),
                                      child: SizedBox(
                                          width:isEditTrip?100: 270,
                                          height: 45,
                                          child: TextButton(
                                            onPressed: () async {
                                              final prefs = await SharedPreferences.getInstance();

                                              if(isEditTrip ==true){
                                                 
                                                prefs.setBool('isEditTrip',true);
                                                createTrip ();
                                                Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) =>  tripDetailsPlan(isSelectPlaces: false,isEditPlace: true,)),
                                                );


                                              }else{
                                                prefs.setBool('isEditTrip',false);
                                                createTrip ();
                                                Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) =>  tripDetailsPlan(isSelectPlaces: false,isEditPlace: false,)),
                                                );
                                                
                                              }

                                              
                                              
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color.fromARGB(255, 0, 0, 0),
                                              foregroundColor:Color.fromARGB(255, 255, 255, 255),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20), 
                                                ),
                                              
                                            ),
                                            child: Text(isEditTrip?"Edit places":'Next',
                                                style: GoogleFonts.roboto(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    
                                            
                                                ),
                                            
                                            ),
                                          ),
                                        ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                          ],
                        )
                      ],
                    
                    )
                    ],
                    )
                  ]
                  ),
                ),
              ),
            ),
          
        ),
      ),
    );

    }else{
      return const Center(
        child: CircularProgressIndicator(),
      );

    }
  }
}