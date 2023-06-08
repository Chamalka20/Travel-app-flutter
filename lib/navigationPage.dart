import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelapp/fechApiData.dart';
import "package:travelapp/fechLastViews.dart";
import 'package:travelapp/search.dart';
import 'package:travelapp/bottomNavigationBar.dart';

import 'Home.dart';

class navigationPage extends StatefulWidget {
  
 const navigationPage({super.key});

  @override
  State<navigationPage> createState() => _navigationPageState();
}

class _navigationPageState extends State<navigationPage> {

  int _selectedIndex = 0;
 
  static const List<Widget> _pages = <Widget>[
    home(isBackButtonClick: true),
    search(),
    // PlanPage(),
    // FavoritePage(),
    // AccountPage(),
  ];

  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: buildBody(),
    );
  }



   Widget buildBody() {
      return WillPopScope(
      onWillPop: () async {
        bool confirmExit = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Confirm Exit'),
                content: const Text('Are you sure you want to exit the app?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      // User confirmed exit
                       SystemNavigator.pop();
                    },
                    child: Text('Yes'),
                  ),
                  TextButton(
                    onPressed: () {
                      // User canceled exit
                      Navigator.of(context).pop(false);
                    },
                    child: Text('No'),
                  ),
                ],
              );
            },
          );

          return confirmExit ;
        
      }, child: Scaffold(

          body:_pages[_selectedIndex],

          bottomNavigationBar:navigationBar(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
            


              
            

          )

      ), 

      );

    
  }
}