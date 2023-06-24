import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';


class createNewTrip extends StatefulWidget {

  final String placeName;
  final String placePhotoUrl;
  

  const createNewTrip({super.key, required this.placeName,required this.placePhotoUrl }) ;

  @override
  State<createNewTrip> createState() => _createNewTripState(placeName,placePhotoUrl);
}

class _createNewTripState extends State<createNewTrip> {
  final String placeName;
  final String backGroundPlacePhotoUrl;
  late final defultBacPhotoUrl;
  late final String planTrips = '5';
  late  String tripName ='';
  TextEditingController dateinput = TextEditingController(); 


  _createNewTripState(this.placeName,this.backGroundPlacePhotoUrl);

  
  @override
  void initState(){
     super.initState();
    //get data list from api-------------------------------
  
   getBackGroundImage ();

    
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

      print('photo url get susses');
      final data = jsonDecode(response.body);
      final photoUrl = data['photos'][17]['src']['medium']??'https://www.pexels.com/photo/mountain-covered-snow-under-star-572897/';

      if(placeName!="" && backGroundPlacePhotoUrl!=""){

          defultBacPhotoUrl =  backGroundPlacePhotoUrl ; //set your choose location photo
          tripName =  placeName;     
      }else{

        defultBacPhotoUrl = photoUrl;

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
                              child: Column(
                        
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top:40),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text("Informations Trip",
                                          style: GoogleFonts.cabin(
                                              // ignore: prefer_const_constructors
                                              textStyle: TextStyle(
                                              color: Color.fromARGB(255, 255, 255, 255),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                                                              
                                              ) 
                                            )
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top:130,left:13),
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
                                 Padding(
                                   padding: const EdgeInsets.only(top:20),
                                   child: Container(
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
                                          String formattedDate1 = DateFormat('yyyy/MM/dd').format(pickedDate.start);
                                          String formattedDate2 = DateFormat('yyyy/MM/dd').format(pickedDate.end); 
                                          print(pickedDate.duration.inDays); 
                                          
                  
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
                                 ),
                              ],
                            ),
                            // select trip budget----------------------------------------------------------------
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
  }
}