import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'customPageRoutes.dart';
import 'navigationPage.dart';

class locationDetails extends StatefulWidget {
  const locationDetails({super.key});

  @override
  State<locationDetails> createState() => _locationDetailsState();
}

class _locationDetailsState extends State<locationDetails> {


  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async {
         Navigator.of(context).pushReplacement(customPageRoutes(
                    
        child:const navigationPage(isBackButtonClick:true)));  
      return false;
      },
      child: Scaffold(
       extendBodyBehindAppBar: true,
       appBar: AppBar(
        toolbarHeight: 2,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Color.fromARGB(0, 255, 255, 255),
          statusBarIconBrightness: Brightness.light, 
          ),
        elevation: 0,
        backgroundColor: Color.fromARGB(0, 255, 255, 255),

      ),
        body:Center(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height:500,
                    color: Color.fromARGB(255, 240, 86, 86),
                    child: Stack(
                      children:[ Container(
                        width:360,
                        height: 200,
                        decoration: const BoxDecoration(
                        
                        image: DecorationImage(
                        image: AssetImage('assets/images/Boat-Windows-10-Wallpaper.jpg'),
                        fit: BoxFit.cover
                                    
                          ),
                        
                        ),
                       
                      ),
                      Positioned(
                        
                        top:185,
                        
                        child: SizedBox(
                          width:360,
                          height: 100,
                          child: Container(
                            
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 240, 238, 238),
                              borderRadius: BorderRadius.circular(10)
                            ),
        
                          ),
        
                        ),
                        )
                      ]
                    ),
                  )
                ],
              )
            ],
          
          ),
          
        )
      ),
    );
  }
}