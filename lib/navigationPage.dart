import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelapp/fechApiData.dart';
import 'package:travelapp/search.dart';
import 'package:travelapp/bottomNavigationBar.dart';

import 'Home.dart';
import 'customPageRoutes.dart';

class navigationPage extends StatefulWidget {

 final   bool isBackButtonClick;  
 const navigationPage({required this.isBackButtonClick, Key? key}) : super(key: key);

  @override
  State<navigationPage> createState() => _navigationPageState(isBackButtonClick);
}



class _navigationPageState extends State<navigationPage> {

  bool isBackButtonClick;
  int _selectedIndex = 0;
  late List<Widget> _pages;

   _navigationPageState(this.isBackButtonClick);
  
 
 void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
       isBackButtonClick = true;

      _pages = [
      home(isBackButtonClick: isBackButtonClick),
      const search(),
      // PlanPage(),
      // FavoritePage(),
      // AccountPage(),
    ] ;

    });
  }

   @override
  void initState() {
    super.initState();
    isBackButtonClick = isBackButtonClick;
    _selectedIndex =_selectedIndex;
    
    _pages = [
      home(isBackButtonClick: isBackButtonClick),
      const search(),
      // PlanPage(),
      // FavoritePage(),
      // AccountPage(),
    ];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: buildBody(),
    );
  }



   Widget buildBody() {
      return GestureDetector(
         onTap: () {
        // Dismiss the keyboard when the user taps outside of the text fields 
        FocusScope.of(context).unfocus();
        
        },
        child: WillPopScope(
          onWillPop: () async {
            
            if(_selectedIndex==0){
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
        
              
        
            }else{
              
                Navigator.of(context).pushReplacement(customPageRoutes(
                    
                child: navigationPage(isBackButtonClick:true)));  
        
          
            
              
            }
            
          return false ;
            
          }, child: Scaffold(
        
              body:_pages[_selectedIndex],
        
              bottomNavigationBar:navigationBar(
                selectedIndex: _selectedIndex,
                onItemTapped: _onItemTapped,
        
              )
        
            ), 
        
          ),
      );

    
  }
}