import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';

class mytrips extends StatefulWidget {
  const mytrips({super.key});

  @override
  State<mytrips> createState() => _mytripsState();
}

class _mytripsState extends State<mytrips> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 2,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Color.fromARGB(0, 255, 255, 255),
          statusBarIconBrightness: Brightness.dark, 
          ),
        elevation: 0,
        backgroundColor: Color.fromARGB(0, 20, 12, 12),

        
      ),
      body: Container(
        width: 360,
        child: Column(
          children: [
            Row(
              children: [
                Text("My Trips",
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
            Expanded(
              child:
                ListView.builder(
                    cacheExtent: 9999, 
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return
                        Padding(
                          padding: const EdgeInsets.only(bottom: 9),
                          child: Container(
                            width: 150,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 216, 99, 99),
                              borderRadius: BorderRadius.circular(17),
                              image: DecorationImage(
                              image: NetworkImage(''),
                              fit: BoxFit.cover
                                          
                                ),
                            
                            ),
                            child:Column(),
                          ),
                        );
      
                    }
                  
                  )
              
              )
          ],
        ),
      ),

    );
  }
}