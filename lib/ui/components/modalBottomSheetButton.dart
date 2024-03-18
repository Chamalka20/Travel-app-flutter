import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../blocs/trip/trip_bloc.dart';
import '../../blocs/trip/trip_event.dart';
import 'cityList.dart';



class modalBottomSheetButton extends StatefulWidget {

  final currentIndex;
  final BuildContext parentContext;
  const modalBottomSheetButton({required this.currentIndex,required this.parentContext});

  @override
  State<modalBottomSheetButton> createState() => _modalBottomSheetButtonState(this.currentIndex,this.parentContext);
}

class _modalBottomSheetButtonState extends State<modalBottomSheetButton> {

  final currentIndex;
  final BuildContext parentContext;
  bool isTextFieldClicked=false;
  final TextEditingController dialogBoxSearchController = TextEditingController();
  Timer? _timer;
  String  inputData='';
  List dailogBoxState=[{
    'isSelectCity':false,
    'isTextfiledEmpty':false,
    'selectedPlaces':[],
  }];

  _modalBottomSheetButtonState(this.currentIndex,this.parentContext);

  
  @override
  Widget build(context) {
    return TextButton(
    onPressed: () {
    showModalBottomSheet(
        context:parentContext,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
          ), 
        builder: (modContext) { 
          return StatefulBuilder(builder: (stfContext, stfSetState) {
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
                      onTap: () {

                        showDialog(
                          context: modContext, 
                          builder: (dialogContext) {
                            
                            return StatefulBuilder(builder: (stfContext, stfSetState) {
                          
                            return
                                WillPopScope(
                                    onWillPop: () async{

                                      stfSetState(() {
                                        isTextFieldClicked=false;
                                      });
                                      
                                      return true;
                                    },
                                    child: AlertDialog(
                                      title:  Text("Get the places you want to visit",
                                                textAlign:TextAlign.center,
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
                                          height: 500,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 35,
                                                child: TextField(
                                                  controller: dialogBoxSearchController, 
                                                  onTap: () {
                                                    stfSetState(() {
                                                      isTextFieldClicked=true;
                                                    });
                                                  },
                                                  //get keyboard input value-------------
                                                  onChanged: (value) {
                                                    if(value !=''){
                                                      
                                                        if (_timer?.isActive ?? false) _timer!.cancel();
                                                      _timer = Timer(const Duration(milliseconds: 1000), () {

                                                        stfSetState(() {
                                                        inputData = value;
                                                        
                                                      });

                                                      });
                                                    }
                                                  },
                                                  decoration: InputDecoration(
                                                  filled: true,                    
                                                  fillColor:  Color.fromARGB(255, 240, 238, 238),
                                                  hintText:dailogBoxState[0]['isSelectCity']? 'Search places':'Search city',
                                                  prefixIcon: Icon(Icons.search),
                                                  hintStyle: GoogleFonts.cabin(
                                                                // ignore: prefer_const_constructors
                                                                textStyle: TextStyle(
                                                                color: Color.fromARGB(255, 145, 144, 144),
                                                                fontSize: 14,
                                                                fontWeight:FontWeight.w400,
                                                                
                                                                ) 
                                                              ),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius: BorderRadius.circular(15.0),
                                                    
                                                    ),
                                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                                                  ),
                                                                                                                  
                                                                                                                  
                                                ),
                                              ),
                                              Visibility(
                                                visible: !isTextFieldClicked,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top:130),
                                                  child: Text("To select Places,first \nselect a city",
                                                      textAlign:TextAlign.center,
                                                      style: GoogleFonts.cabin(
                                                      // ignore: prefer_const_constructors
                                                      textStyle: TextStyle(
                                                      color: Color.fromARGB(255, 145, 144, 144),
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      
                                                                                  
                                                      ) 
                                                    )
                                                  ),
                                                ),
                                              ),
                                              Visibility(
                                                visible: isTextFieldClicked,
                                                child: cityList(isTextFieldClicked: isTextFieldClicked,
                                                  searchType:'attraction', inputValue:inputData,
                                                  dailogBoxState: (val) => stfSetState(() {
                                                    dailogBoxState = val;
                                                    if(val[0]['isTextfiledEmpty']== true){
                                                      dialogBoxSearchController.text='';
                                                    }
                                                    if(val[0]['selectedPlaces']!= null){
                                                      BlocProvider.of<tripBloc>(context).add
                                                      (planingPlaces(val[0]['selectedPlaces'],widget.currentIndex));
                                                    }
                                                    })
                                                    ,),
                                              )

                                            ],
                                          ),
                                        )
                                    )
                              );
                          }
                            );
                          }

                        );
                        
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

          } 
          );
        }

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
    );
  }
}