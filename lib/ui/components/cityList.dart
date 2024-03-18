import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../blocs/place/placeList_bloc.dart';
import '../../models/place.dart';

typedef Callback = void Function(List val);


class cityList extends StatefulWidget {

  final inputValue; 
  final searchType;
  final isTextFieldClicked;
  final Callback dailogBoxState;
  const cityList({required this.inputValue,required this.searchType,required this.isTextFieldClicked,
  required this.dailogBoxState});

  @override
  State<cityList> createState() => _cityListState(inputValue,searchType,isTextFieldClicked,dailogBoxState);
}

class _cityListState extends State<cityList> {

  String searchType;
  bool isTextFieldClicked;
  List<Place> selectedPlaces=[];
  String inputValue;
  Callback dailogBoxState;
  bool isSelectCity= false;
  bool isPlaceSelect=false;
  bool isMoveing = false;
  var cityName;
  
  _cityListState(this.inputValue, this.searchType,this.isTextFieldClicked,this.dailogBoxState);
  String capitalize(String s) =>s.isNotEmpty? s[0].toUpperCase() + s.substring(1):'';


   @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    if(isMoveing != true){

      return FutureBuilder(
              future:isSelectCity? placeBloc.getplaces(cityName,searchType):placeBloc.searchPlaces(capitalize(widget.inputValue), 'city'),
              builder: (BuildContext context, results) { 
                
                if(results.hasData){

                  return
                    Expanded(
                      child:Stack(
                        children:[ 
                          ListView.builder(
                            itemCount: results.data?.length,
                            itemBuilder: (context, index) {
                              final searchRe = results.data?[index];
                              final placeId = searchRe?.id;
                              final name = searchRe?.name;
                              
                              return Column(
                                children: [
                                  
                                  GestureDetector(
                                    onTap: () {
                                      
                                      FocusManager.instance.primaryFocus?.unfocus();

                                      if(isSelectCity == false){
                                        setState(() {
                                          isSelectCity=true;
                                          cityName=searchRe?.name;
                                          isMoveing=true;
                                        });
                                        
                                        dailogBoxState([{
                                          'isSelectCity':isSelectCity,
                                          'isTextfiledEmpty':true,
                                          'selectedPlaces':null,
                                        }]);
                                        
                                        Timer(const Duration(milliseconds: 500), () {
                                            setState(() {
                                              isMoveing=false;
                                            });
                                        });

                                      }else{

                                        setState(() {
                                          isPlaceSelect=true;
                       
                                         if((selectedPlaces.any((itemToCheck) => itemToCheck.id == placeId))){

                                          selectedPlaces.removeWhere((item) => item.id == placeId);

                                         }else{

                                          selectedPlaces.add(results.data![index]);

                                         }
                                      
                                        });
                                        
                                      }

                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 220,
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Color.fromARGB(255, 226, 226, 226).withOpacity(0.5), 
                                                width: 1, 
                                              ),
                                            ),
                                          ),//------------------------
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              
                                              children: [
                                                Column(
                                                  
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(bottom:4),
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            width:182,
                                                            child: Text(name!,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: GoogleFonts.cabin(
                                                                // ignore: prefer_const_constructors
                                                                textStyle: TextStyle(
                                                                color: const Color.fromARGB(255, 27, 27, 27),
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w600,
                                                                                                        
                                                                ) 
                                                              )
                                                            ),
                                                          ),
                                                          Visibility(
                                                            visible: isSelectCity,
                                                            child: SizedBox(
                                                              height: 20,
                                                              width: 20,
                                                              child:selectedPlaces.any((itemToCheck) => itemToCheck.id == placeId)?Image.asset("assets/images/correct.png") 
                                                              :Image.asset("assets/images/dry-clean.png")
                                                            
                                                            ),
                                                          ),
                                                          
                                                        ],
                                                      ),
                                                    ),
                                                     
                                                    
                                                  ],
                                                ),
                                                
                                              ],
                                            ),
                                          ), 
                                        ),
                                        
                                      ],
                                    ),
                                  )
                                  
                                        
                                ],
                                        
                              );
                                    
                            }
                          ),
                           Visibility(
                              visible: isSelectCity,
                              child: Positioned(
                                top:420,
                                left:0,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                                width: 110,
                                                height: 45,
                                                child: TextButton(
                                                  onPressed:() async{
                                                    
                                                    setState(() {
                                                      isSelectCity=false;
                                                      isPlaceSelect=false;
                                                      isMoveing=true;
                                                    });
                                                   
                                                    dailogBoxState([{
                                                      'isSelectCity':isSelectCity,
                                                      'isTextfiledEmpty':true,
                                                      'selectedPlaces':selectedPlaces
                                                    }]);
                                                     print("hii");
                                                    Timer(const Duration(milliseconds: 500), () {
                                                        setState(() {
                                                          isMoveing=false;
                                                        });
                                                    });
                                                    
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Color.fromARGB(255, 2, 94, 14),
                                                    foregroundColor:Color.fromARGB(255, 255, 255, 255),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(20), 
                                                      ),
                                                    
                                                  ),
                                                  child: Text('Select new places',
                                                      textAlign: TextAlign.center,
                                                      style: GoogleFonts.roboto(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 12,
                                                          
                                                  
                                                      ),
                                                  
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                                
                              ),
                            ),

                          Visibility(
                              visible: selectedPlaces.isNotEmpty,
                              child: Positioned(
                                top:420,
                                left:120,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                                width: 110,
                                                height: 45,
                                                child: TextButton(
                                                  onPressed:() async{
                                                    
                                                    dailogBoxState([{
                                                      'isSelectCity':isSelectCity,
                                                      'isTextfiledEmpty':true,
                                                      'selectedPlaces':selectedPlaces,
                                                    }]);
                                                    Navigator.pop(context, true);
                                                    Navigator.pop(context, true);
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Color.fromARGB(255, 0, 0, 0),
                                                    foregroundColor:Color.fromARGB(255, 255, 255, 255),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(20), 
                                                      ),
                                                    
                                                  ),
                                                  child: Text('${selectedPlaces.length}\nplaces add to trip',
                                                      textAlign: TextAlign.center,
                                                      style: GoogleFonts.roboto(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 12,
                                                          
                                                  
                                                      ),
                                                  
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                                
                              ),
                            )
                          
                        ]
                      )
                      
                      
                    );

                }else{

                  return
                    Padding(
                      padding: const EdgeInsets.only(top:40),
                      child: LoadingAnimationWidget.waveDots(
                        color: Color.fromARGB(255, 129, 129, 129), 
                        size: 35,
                      ),
                    );

                }

               },
              
            );


    }else{
      return
        Padding(
          padding: const EdgeInsets.only(top:120),
          child: LoadingAnimationWidget.beat(
            color: Color.fromARGB(255, 129, 129, 129), 
            size: 35,
          ),
        );


    }

  }
  
}